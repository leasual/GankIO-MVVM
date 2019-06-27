//
//  DismissAnimationController.swift
//  ATGMediaBrowser
//
//  Created by Suraj Thomas K on 7/19/18.
//  Copyright © 2018 Al Tayer Group LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

internal class DismissAnimationController: NSObject {

    private enum Constants {

        static let minimumVelocity: CGFloat = 15.0
        static let minimumTranslation: CGFloat = 0.25
        static let transitionDuration = 0.3
        static let updateFrameRate: CGFloat = 60.0
        static let transitionSpeedFactor: CGFloat = 0.15
        static let minimumZoomDuringInteraction: CGFloat = 0.9
    }

    internal var image: UIImage?
    internal let gestureDirection: MediaBrowserViewController.GestureDirection
    internal weak var viewController: MediaBrowserViewController?
    internal var interactionInProgress = false

    private lazy var imageView = UIImageView()
    private var backgroundView: UIView?

    private var timer: Timer?
    private var distanceToMove: CGPoint = .zero
    private var relativePosition: CGPoint = .zero
    private var progressValue: CGFloat {
        return (gestureDirection == .horizontal) ? relativePosition.y : relativePosition.x
    }
    private var shouldZoomOutOnInteraction = false

    init(
        image: UIImage? = nil,
        gestureDirection: MediaBrowserViewController.GestureDirection,
        viewController: MediaBrowserViewController
        ) {

        self.image = image
        self.gestureDirection = gestureDirection
        self.viewController = viewController
    }

    internal func handleInteractiveTransition(_ recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: recognizer.view)

        let progress = CGPoint(
            x: translation.x / UIScreen.main.bounds.size.width,
            y: translation.y / UIScreen.main.bounds.size.height
        )

        switch recognizer.state {
        case .began:
            beginTransition()
            fallthrough
        case .changed:
            relativePosition = progress
            updateTransition()
        case .ended, .cancelled, .failed:
            var toMove: CGFloat = 0.0

            if abs(progressValue) > Constants.minimumTranslation {
                if let viewController = viewController,
                    let targetFrame = viewController.dataSource?.targetFrameForDismissal(viewController) {

                    animateToTargetFrame(targetFrame)
                    return

                } else {
                    toMove = (progressValue / abs(progressValue))
                }
            } else {
                toMove = -progressValue
            }

            if gestureDirection == .horizontal {
                distanceToMove.x = -relativePosition.x
                distanceToMove.y = toMove
            } else {
                distanceToMove.x = toMove
                distanceToMove.y = -relativePosition.y
            }

            if timer == nil {
                timer = Timer.scheduledTimer(
                    timeInterval: 1.0/Double(Constants.updateFrameRate),
                    target: self,
                    selector: #selector(update(_:)),
                    userInfo: nil,
                    repeats: true
                )
            }
        default:
            break
        }
    }

    internal func animateToTargetFrame(_ target: CGRect) {

        let frame = imageViewFrame(for: imageView.bounds.size, in: target, mode: .scaleAspectFill)
        UIView.animate(withDuration: Constants.transitionDuration, animations: {

            self.imageView.frame = frame
            self.backgroundView?.alpha = 0.0
        }) { finished in

            if finished {
                self.interactionInProgress = false
                if self.gestureDirection == .horizontal {
                    self.relativePosition.y = -1.0
                } else {
                    self.relativePosition.x = -1.0
                }
                self.finishTransition()
            }
        }
    }

    @objc private func update(_ timeInterval: TimeInterval) {

        let speed = (Constants.updateFrameRate * Constants.transitionSpeedFactor)
        let xDistance = distanceToMove.x / speed
        let yDistance = distanceToMove.y / speed
        distanceToMove.x -= xDistance
        distanceToMove.y -= yDistance
        relativePosition.x += xDistance
        relativePosition.y += yDistance
        updateTransition()

        let translation = CGPoint(
            x: xDistance * (UIScreen.main.bounds.size.width),
            y: yDistance * (UIScreen.main.bounds.size.height)
        )
        let directionalTranslation = (gestureDirection == .horizontal) ? translation.y : translation.x
        if abs(directionalTranslation) < 1.0 {

            relativePosition.x += distanceToMove.x
            relativePosition.y += distanceToMove.y
            updateTransition()
            interactionInProgress = false

            finishTransition()
        }
    }

    internal func beginTransition() {

        shouldZoomOutOnInteraction = false
        if let viewController = viewController {
            shouldZoomOutOnInteraction = viewController.dataSource?.targetFrameForDismissal(viewController) != nil
        }

        createTransitionViews()

        viewController?.mediaContainerView.isHidden = true
        viewController?.hideControls = true
        viewController?.visualEffectContainer.isHidden = true
    }

    private func finishTransition() {

        distanceToMove = .zero
        timer?.invalidate()
        timer = nil

        imageView.removeFromSuperview()

        backgroundView?.removeFromSuperview()
        backgroundView = nil

        let directionalPosition = (gestureDirection == .horizontal) ? relativePosition.y : relativePosition.x
        if directionalPosition != 0.0 {
            viewController?.dismiss(animated: false, completion: nil)
        } else {
            viewController?.mediaContainerView.isHidden = false
            viewController?.hideControls = false
            viewController?.visualEffectContainer.isHidden = false
        }
    }

    private func createTransitionViews() {

        backgroundView?.removeFromSuperview()
        backgroundView = nil

        if let viewController = viewController,
            let bg = viewController.visualEffectContainer.snapshotView(afterScreenUpdates: true) {
            backgroundView = bg
            viewController.view.addSubview(bg)
            NSLayoutConstraint.activate([
                bg.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                bg.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                bg.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                bg.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
                ])
        }

        imageView.image = image
        imageView.frame = imageViewFrame(
            for: image?.size ?? .zero,
            in: viewController?.view.bounds ?? .zero
        )
        viewController?.view.addSubview(imageView)
        imageView.transform = CGAffineTransform.identity
    }

    private func updateTransition() {

        var transform = CGAffineTransform.identity
        let directionalPosition = (gestureDirection == .horizontal) ? relativePosition.y : relativePosition.x

        if shouldZoomOutOnInteraction {
            let scale = CGFloat.maximum(Constants.minimumZoomDuringInteraction, 1.0 - abs(directionalPosition))
            transform = transform.scaledBy(x: scale, y: scale)
        }

        if gestureDirection == .horizontal {
            transform = transform.translatedBy(
                x: shouldZoomOutOnInteraction ? relativePosition.x * UIScreen.main.bounds.size.width : 0.0,
                y: relativePosition.y * UIScreen.main.bounds.size.height
            )
        } else {
            transform = transform.translatedBy(
                x: relativePosition.x * UIScreen.main.bounds.size.width,
                y: shouldZoomOutOnInteraction ? relativePosition.y * UIScreen.main.bounds.size.height : 0.0
            )
        }
        imageView.transform = transform

        let alpha = (directionalPosition < 0.0) ? directionalPosition + 1.0 : 1.0 - directionalPosition
        backgroundView?.alpha = alpha
    }


    private func imageViewFrame(for imageSize: CGSize, in frame: CGRect, mode: UIView.ContentMode = .scaleAspectFit) -> CGRect {

        guard imageSize != .zero,
            mode == .scaleAspectFit || mode == .scaleAspectFill else {
            return frame
        }

        var targetImageSize = frame.size

        let aspectHeight = frame.size.width / imageSize.width * imageSize.height
        let aspectWidth = frame.size.height / imageSize.height * imageSize.width

        if imageSize.width / imageSize.height > frame.size.width / frame.size.height {
            if mode == .scaleAspectFit {
                targetImageSize.height = aspectHeight
            } else {
                targetImageSize.width = aspectWidth
            }
        } else {
            if mode == .scaleAspectFit {
                targetImageSize.width = aspectWidth
            } else {
                targetImageSize.height = aspectHeight
            }
        }

        let x = frame.minX + (frame.size.width - targetImageSize.width) / 2.0
        let y = frame.minY + (frame.size.height - targetImageSize.height) / 2.0

        return CGRect(origin: CGPoint(x: x, y: y), size: targetImageSize)
    }
}
