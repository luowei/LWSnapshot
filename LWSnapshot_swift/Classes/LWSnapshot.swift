//
// LWSnapshot.swift
// Convenience API for LWSnapshot library
// Created by Luo Wei on 2025/10/04.
// Copyright (c) 2017 wodedata. All rights reserved.
//

import UIKit

// MARK: - LWSnapshot Main API

public class LWSnapshot {

    /// Show snapshot mask in the given view
    /// - Parameters:
    ///   - view: The view to add snapshot mask to
    ///   - closeHandler: Optional closure called when user cancels
    /// - Returns: The snapshot mask view instance
    @discardableResult
    public static func show(in view: UIView, closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView {
        let maskView = LWSnapshotMaskView.showSnapshotMask(in: view)
        maskView.closeBlock = closeHandler
        return maskView
    }

    /// Hide snapshot mask in the given view
    /// - Parameter view: The view to remove snapshot mask from
    public static func hide(in view: UIView) {
        LWSnapshotMaskView.hideSnapshotMask(in: view)
    }

    /// Show snapshot mask in the current key window
    /// - Parameter closeHandler: Optional closure called when user cancels
    /// - Returns: The snapshot mask view instance
    @discardableResult
    public static func show(closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView? {
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first else {
            return nil
        }
        return show(in: window, closeHandler: closeHandler)
    }

    /// Hide snapshot mask in the current key window
    public static func hide() {
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first else {
            return
        }
        hide(in: window)
    }
}

// MARK: - UIViewController Extension

extension UIViewController {

    /// Show snapshot mask in view controller's view
    /// - Parameter closeHandler: Optional closure called when user cancels
    /// - Returns: The snapshot mask view instance
    @discardableResult
    public func showSnapshotMask(closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView {
        LWSnapshot.show(in: view, closeHandler: closeHandler)
    }

    /// Hide snapshot mask in view controller's view
    public func hideSnapshotMask() {
        LWSnapshot.hide(in: view)
    }
}

// MARK: - UIView Extension (Convenience)

extension UIView {

    /// Show snapshot mask in this view
    /// - Parameter closeHandler: Optional closure called when user cancels
    /// - Returns: The snapshot mask view instance
    @discardableResult
    public func showSnapshotMask(closeHandler: (() -> Void)? = nil) -> LWSnapshotMaskView {
        LWSnapshot.show(in: self, closeHandler: closeHandler)
    }

    /// Hide snapshot mask in this view
    public func hideSnapshotMask() {
        LWSnapshot.hide(in: self)
    }
}
