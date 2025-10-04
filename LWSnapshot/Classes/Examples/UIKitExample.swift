//
// UIKitExample.swift
// Example usage of LWSnapshot with UIKit
// Created by Luo Wei on 2025/10/04.
//

import UIKit

class SnapshotExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Example 1: Long press gesture with two fingers to trigger screenshot
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(_:)))
        longPressGesture.numberOfTouchesRequired = 2
        view.addGestureRecognizer(longPressGesture)

        // Example 2: Listen for system screenshot notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidTakeScreenshot(_:)),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Screenshot Notifications

    @objc private func appDidTakeScreenshot(_ notification: Notification) {
        showSnapshotView()
    }

    // MARK: - Gesture Actions

    @objc private func longPressGestureAction(_ gesture: UILongPressGestureRecognizer) {
        print("--------: Long press gesture detected")

        if gesture.state == .began {
            showSnapshotView()
        }
    }

    // MARK: - Button Actions

    @IBAction func buttonAction(_ sender: UIButton) {
        showSnapshotView()
    }

    // MARK: - Show Snapshot

    private func showSnapshotView() {
        // Method 1: Using static method
        let snapshotMaskView = LWSnapshotMaskView.showSnapshotMask(in: view)
        snapshotMaskView.snapshotFrame = CGRect(
            x: (view.frame.size.width - 200) / 2,
            y: (view.frame.size.height - 200) / 2,
            width: 200,
            height: 200
        )

        // Method 2: Using convenience extension
        // showSnapshotMask { [weak self] in
        //     print("Snapshot mask closed")
        // }

        // Method 3: Using LWSnapshot API
        // LWSnapshot.show(in: view) {
        //     print("Snapshot closed")
        // }
    }
}

// MARK: - Usage Examples

/*
 // Example 1: Basic usage in view controller
 class MyViewController: UIViewController {
     @IBAction func takeScreenshot(_ sender: UIButton) {
         showSnapshotMask()
     }
 }

 // Example 2: Custom snapshot frame
 class MyViewController: UIViewController {
     @IBAction func takeScreenshot(_ sender: UIButton) {
         let maskView = LWSnapshot.show(in: view)
         maskView.snapshotFrame = CGRect(x: 50, y: 100, width: 300, height: 400)
     }
 }

 // Example 3: With close handler
 class MyViewController: UIViewController {
     @IBAction func takeScreenshot(_ sender: UIButton) {
         showSnapshotMask { [weak self] in
             print("User cancelled screenshot")
             self?.performSomeAction()
         }
     }
 }

 // Example 4: Show in current window
 LWSnapshot.show {
     print("Screenshot cancelled")
 }

 // Example 5: Hide programmatically
 hideSnapshotMask()
 // or
 LWSnapshot.hide()
 */
