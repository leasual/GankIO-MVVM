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


This are the options available for the exportOptins Property List file:

compileBitcode : Bool

For non-App Store exports, should Xcode re-compile the app from bitcode? Defaults to YES.

destination : String

Determines whether the app is exported locally or uploaded to Apple. Options are export or upload. The available options vary based on the selected distribution method. Defaults to export.

embedOnDemandResourcesAssetPacksInBundle : Bool

For non-App Store exports, if the app uses On Demand Resources and this is YES, asset packs are embedded in the app bundle so that the app can be tested without a server to host asset packs. Defaults to YES unless onDemandResourcesAssetPacksBaseURL is specified.

generateAppStoreInformation : Bool

For App Store exports, should Xcode generate App Store Information for uploading with iTMSTransporter? Defaults to NO.

iCloudContainerEnvironment : String

If the app is using CloudKit, this configures the "com.apple.developer.icloud-container-environment" entitlement. Available options vary depending on the type of provisioning profile used, but may include: Development and Production.

installerSigningCertificate : String

For manual signing only. Provide a certificate name, SHA-1 hash, or automatic selector to use for signing. Automatic selectors allow Xcode to pick the newest installed certificate of a particular type. The available automatic selectors are "Mac Installer Distribution" and "Developer ID Installer". Defaults to an automatic certificate selector matching the current distribution method.

manifest : Dictionary

For non-App Store exports, users can download your app over the web by opening your distribution manifest file in a web browser. To generate a distribution manifest, the value of this key should be a dictionary with three sub-keys: appURL, displayImageURL, fullSizeImageURL. The additional sub-key assetPackManifestURL is required when using on-demand resources.

method : String

Describes how Xcode should export the archive. Available options: app-store, validation, ad-hoc, package, enterprise, development, developer-id, and mac-application. The list of options varies based on the type of archive. Defaults to development.

onDemandResourcesAssetPacksBaseURL : String

For non-App Store exports, if the app uses On Demand Resources and embedOnDemandResourcesAssetPacksInBundle isn't YES, this should be a base URL specifying where asset packs are going to be hosted. This configures the app to download asset packs from the specified URL.

provisioningProfiles : Dictionary

For manual signing only. Specify the provisioning profile to use for each executable in your app. Keys in this dictionary are the bundle identifiers of executables; values are the provisioning profile name or UUID to use.

signingCertificate : String

For manual signing only. Provide a certificate name, SHA-1 hash, or automatic selector to use for signing. Automatic selectors allow Xcode to pick the newest installed certificate of a particular type. The available automatic selectors are "Mac App Distribution", "iOS Distribution", "iOS Developer", "Developer ID Application", and "Mac Developer". Defaults to an automatic certificate selector matching the current distribution method.

signingStyle : String

The signing style to use when re-signing the app for distribution. Options are manual or automatic. Apps that were automatically signed when archived can be signed manually or automatically during distribution, and default to automatic. Apps that were manually signed when archived must be manually signed during distribtion, so the value of signingStyle is ignored.

stripSwiftSymbols : Bool

Should symbols be stripped from Swift libraries in your IPA? Defaults to YES.

teamID : String

The Developer Portal team to use for this export. Defaults to the team used to build the archive.

thinning : String

For non-App Store exports, should Xcode thin the package for one or more device variants? Available options: (Xcode produces a non-thinned universal app), (Xcode produces a universal app and all available thinned variants), or a model identifier for a specific device (e.g. "iPhone7,1"). Defaults to .

uploadBitcode : Bool

For App Store exports, should the package include bitcode? Defaults to YES.

uploadSymbols : Bool

For App Store exports, should the package include symbols? Defaults to YES.

## Final comments

Be mindful of path names with spaces or apostrophes. I used an example with them because I've had to deal with it myself.

I've tried iResign (and it's various forks) and "sigh" from Fastlane, but they either didn't work or required as much setup as the steps above. This approach works best for me in my current context. You might want to give those tools a try.

Good luck. If you're here, I sincerely hope this helps you!

