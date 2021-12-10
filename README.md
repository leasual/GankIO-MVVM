# Re-signing an .ipa file for iOS distribution

There are several apps I currently have to re-sign. They are apps built by various outside vendors who do not want to share the source code, but we want the apps published from our account and we do not want to give them our certificate or access to publish the apps on our behalf.  ¯\\\_(ツ)\_/¯  These are the steps I use to re-sign them. I've decided to keep the steps manual because, frankly, it's an error-prone process, something done infrequently, and a moving target. Some detail always seems to shift with every major Xcode release or App Store change.

These steps are current as of iOS 14 and Xcode 12. They assume you already have your Distribution Certificate installed in Keychain.

----

I'm going to use an example named "Matt's App.ipa". If you need to provide instructions to a vendor to deliver this file to you properly, I've included what I use below. 

To begin, right-click on the .ipa > Open With > Archive Utility. This will create a "Matt's App" directory containing the key ./Payload directory.

Go looking for things that need to be re-signed, especially App Extensions. If there are any App Extensions, you'll need to add separate app IDs and provisioning profiles for each. You'll also have some extra steps when re-signing below.

    $ find -d . \( -name "*.app" -o -name "*.appex" -o -name "*.framework" -o -name "*.dylib" \)

If required by the app, create the APNS production certificate and provisioning profiles you need on the Apple Developer Center. Download the provisioning profiles.

If required by the app, create the app ID for the App Extension. Create the provisioning profile for it as well. Download the provisioning profile. The example below is for an app that has an App Extension for notifications.

Inspect the entitlements for the .app file. I do this to see if there is anything unexpected lurking in there.

    $ codesign -d --entitlements - Matt\'s\ App/Payload/Matt\'s\ App.app

Inspect the entitlements for the App Extension, if there is one, for the same reason as above.

    $ codesign -d --entitlements - Matt\'s\ App/Payload/Matt\'s\ App.app/PlugIns/notify.appex

NOTE: You can add ` > filename.entitlements` to the codesign command above to output the entitlements file or you can create and edit  hand-created versions you have. I chose to use the hand versions since they are unlikely to change much. (These are included below)

The following commands below are all relative to the directory with the .ipa and ./Matt's App/Payload. If you do not have an App Extension, skip the commands dealing with .appex files or paths.

Now we're going to clean up the existing codesign artifacts. 

    $ rm -rf ./Matt\'s\ App/Payload/Matt\'s\ App.app/_CodeSignature/
    $ rm -rf ./Matt\'s\ App/Payload/Matt\'s\ App.app/PlugIns/notify.appex/_CodeSignature/
    $ rm -rf ./Matt\'s\ App/Payload/Matt\'s\ App.app/Frameworks/*/_CodeSignature/

Now we're going to modify the app ID, version, and build number using PlistBuddy. First we do the app, then the app extension. Be sure to use your own values, of course.

    $ /usr/libexec/PlistBuddy ./Matt\'s\ App/Payload/Matt\'s\ App.app/Info.plist
    Print
    Set :CFBundleIdentifier com.companyname.ourappname
    Set :CFBundleShortVersionString 2.3
    Set :CFBundleVersion 1
    Print
    Save
    Quit

    $ /usr/libexec/PlistBuddy ./Matt\'s\ App/Payload/Matt\'s\ App.app/PlugIns/notify.appex/Info.plist
    Print
    Set :CFBundleIdentifier com.companyname.ourappname.notify
    Set :CFBundleShortVersionString 2.3
    Set :CFBundleVersion 1
    Print
    Save
    Quit

For reference, if you need to update other pieces of your .plist file, here are a few other things you can do.

    Update an existing privacy statement:
    
    Set :NSLocationWhenInUseUsageDescription "We\'ll use your location to ..."

    Add a new privacy statement:
    
    Add :NSLocationAlwaysUsageDescription string "We\'ll use your location to ..."

    Edit a dictionary:

    Print :CFBundleURLTypes
    Add :CFBundleURLTypes:1 dict
    Add :CFBundleURLTypes:1:CFBundleTypeRole string "Editor"
    Add :CFBundleURLTypes:1:CFBundleURLName string "com.companyname.someotherapp"
    Add :CFBundleURLTypes:1:CFBundleURLSchemes array
    Add :CFBundleURLTypes:1:CFBundleURLSchemes: string "com-companyname-someotherapp"
    Print :CFBundleURLTypes
    
    Index into an array:
    
    Print :CFBundleDocumentTypes
    Add :CFBundleDocumentTypes:0:LSHandlerRank string "Alternate"
    Print :CFBundleDocumentTypes
    
    Delete an oddball entry -- note the double quotes:
    
    Delete :"NSBluetoothAlwaysUsageDescription - 2"

Now we're going to copy the downloaded provisioning files into place and sign the files with our distribution certificate. Note that the certificate name string is _exactly_ what appears in Keychain Access. 

    $ cp /Users/username/Projects/MattsApp/MattsApp_PROD.mobileprovision ./Matt\'s\ App/Payload/Matt\'s\ App.app/embedded.mobileprovision
 
    $ cp /Users/username/Projects/MattsApp/MattsApp_Notify_PROD.mobileprovision ./Matt\'s\ App/Payload/Matt\'s\ App.app/PlugIns/notify.appex/embedded.mobileprovision
 
    $ codesign -f -s "iPhone Distribution: Our Company Name (OurTeamID)" ./Matt\'s\ App/Payload/Matt\'s\ App.app/Frameworks/*
 
    $ codesign -f -s "iPhone Distribution: Our Company Name (OurTeamID)" --entitlements /Users/username/Projects/MattsApp/appex-notify.entitlements ./Matt\'s\ App/Payload/Matt\'s\ App.app/PlugIns/notify.appex
 
    $ codesign -f -s "iPhone Distribution: Our Company Name (OurTeamID)" --entitlements /Users/username/Projects/MattsApp/app.entitlements ./Matt\'s\ App/Payload/Matt\'s\ App.app
 
 Now we're going to Zip the results back into a .ipa file. This step assumes that is it a Swift project.
 
    $ cd Matt\'s\ App
    $ zip -qr ../MattsApp-resigned.ipa Payload SwiftSupport Symbols
    $ cd ..

For an Objective-C project, all I needed was this below. Don't use both! Pick which is appropriate for your project.

    $ zip -qr MattsApp-resigned.ipa ./Payload

Now we'll run altool to see if there are any validation problems. Here's more information on the App-Specific Password Apple now requires. https://support.apple.com/en-us/HT204397

    $ xcrun altool --validate-app -f ./MattsApp-resigned.ipa -t ios -u YourAppleID -p YourAppleAppSpecificPassword --output-format normal

If you get errors with the `altool` step, Google is your friend. They could have been introduced by re-signing. They could be in the original app code or configuration. It can be challenging to track them down.

If validation runs clean, you can upload the re-signed app! Previously you would use Application Loader, but that has changed.

    $ xcrun altool --upload-app --file ./MattsApp-resigned.ipa -t ios -u YourAppleID -p YourAppleAppSpecificPassword

Here is the app.entitlements file referenced above. If you have APNS involved, you'll need to change the aps-environment setting to "production" in your .entitlements file.

 ```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>application-identifier</key>
    <string>YourTeamID.com.companyname.ourappname</string>
    <key>aps-environment</key>
    <string>production</string>
    <key>beta-reports-active</key>
    <true/>
    <key>com.apple.developer.team-identifier</key>
    <string>YourTeamID</string>
    <key>get-task-allow</key>
    <false/>
</dict>
</plist>
```

Here is the appex-notify.entitlements file referenced above.
 
 ```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>application-identifier</key>
    <string>YourTeamID.com.companyname.ourappname.notify</string>
    <key>aps-environment</key>
    <string>production</string>
    <key>beta-reports-active</key>
    <true/>
    <key>com.apple.developer.team-identifier</key>
    <string>YourTeamID</string>
    <key>get-task-allow</key>
    <false/>
</dict>
</plist>
```

## Instructions to give to a vendor whose .ipa file you need to re-sign

Avoid using the same App ID that you intend to use. If you're using reverse DNS with your company name, that will be fine.

Create an archive as you normally would by selecting the Generic iOS Device for the device and then Product > Archive.

Validate the archive using the Organizer.

Use the Organizer to distribute the app selecting iOS App Store > Export. Select the symbol and signing options as you would normally. You'll be prompted to save the export to a folder.

From the source code, copy the app's .plist file and the app's .entitlements file into the export folder. You'll review these for things like URL schemes, app groups, etc. and any settings that need to make sure are enabled on the transferred app ID under our account. If we're not transferring, we'll create a new app ID on our end.

Zip up the folder and deliver it to us by whatever means is best for you.

Let us know the details on any of the following:

* Will push notifications be used? You'll generate a new certificate and share if needed.
* Are any application services enabled for the app ID currently, such as HealthKit, iCloud, etc?
* Are there any special steps you normally take to sign and prepare the app?

## Final comments

Be mindful of path names with spaces or apostrophes. I used an example with them because I've had to deal with it myself.

I've tried iResign (and it's various forks) and "sigh" from Fastlane, but they either didn't work or required as much setup as the steps above. This approach works best for me in my current context. You might want to give those tools a try.

Good luck. If you're here, I sincerely hope this helps you!

