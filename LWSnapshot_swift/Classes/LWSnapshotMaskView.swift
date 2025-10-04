//
// LWSnapshotMaskView.swift
// Created by Luo Wei on 2025/10/04.
// Copyright (c) 2017 wodedata. All rights reserved.
//

import UIKit

// MARK: - Point Location Enum

public enum PointLocation: Int {
    case outside = 1
    case inControl = 2
    case onControl = 4
    case onTopEdge = 12      // 8 | 4
    case onBottomEdge = 20   // 16 | 4
    case onLeftEdge = 36     // 32 | 4
    case onRightEdge = 68    // 64 | 4
    case onLeftTopCorner = 132    // 128 | 4
    case onRightTopCorner = 260   // 256 | 4
    case onLeftBottomCorner = 516 // 512 | 4
    case onRightBottomCorner = 1028 // 1024 | 4
}

// MARK: - LWSnapshotMaskView

public class LWSnapshotMaskView: UIView {

    // MARK: - Constants

    private let edgePadding: CGFloat = 20
    private let defaultHalfLen: CGFloat = 80
    private let cornerPointDia: CGFloat = 6

    // MARK: - Public Properties

    public var selectRegion: UIView?
    public var cancelBtn: UIButton
    public var shareBtn: UIButton
    public var fullScreenBtn: UIButton
    public var snapshotFrame: CGRect = .zero
    public var pointLocation: PointLocation = .outside
    public var prePoint: CGPoint = .zero
    public var closeBlock: (() -> Void)?

    // MARK: - Private Properties

    private var color: UIColor
    private var bgColor: UIColor
    private var btnIsHidden: Bool = false

    // MARK: - Initialization

    public override init(frame: CGRect) {
        self.cancelBtn = UIButton(type: .custom)
        self.shareBtn = UIButton(type: .custom)
        self.fullScreenBtn = UIButton(type: .custom)
        self.color = .white
        self.bgColor = UIColor.black.withAlphaComponent(0.6)

        super.init(frame: frame)

        setupView(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView(frame: CGRect) {
        backgroundColor = .clear

        // Configure cancel button
        addSubview(cancelBtn)
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 16, right: 10)
        cancelBtn.titleLabel?.font = .systemFont(ofSize: 14)
        cancelBtn.layer.cornerRadius = 4
        cancelBtn.addTarget(self, action: #selector(cancelBtnTouchUpInside(_:)), for: .touchUpInside)

        // Configure share button
        addSubview(shareBtn)
        shareBtn.setTitle(NSLocalizedString("Share", comment: ""), for: .normal)
        shareBtn.setTitleColor(.white, for: .normal)
        shareBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        shareBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 16, right: 10)
        shareBtn.titleLabel?.font = .systemFont(ofSize: 14)
        shareBtn.layer.cornerRadius = 4
        shareBtn.addTarget(self, action: #selector(shareBtnTouchUpInside(_:)), for: .touchUpInside)

        // Configure full screen button
        addSubview(fullScreenBtn)
        fullScreenBtn.setTitle(NSLocalizedString("FullScreen", comment: ""), for: .normal)
        fullScreenBtn.setTitleColor(.white, for: .normal)
        fullScreenBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        fullScreenBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 16, right: 10)
        fullScreenBtn.titleLabel?.font = .systemFont(ofSize: 14)
        fullScreenBtn.layer.cornerRadius = 4
        fullScreenBtn.addTarget(self, action: #selector(fullScreenBtnTouchUpInside(_:)), for: .touchUpInside)

        // Setup constraints
        setupConstraints()

        // Initialize snapshot frame
        prePoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        snapshotFrame = CGRect(
            x: frame.size.width / 2 - defaultHalfLen,
            y: frame.size.height / 2 - defaultHalfLen,
            width: defaultHalfLen * 2,
            height: defaultHalfLen * 2
        )

        // Add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:)))
        addGestureRecognizer(panGesture)
    }

    private func setupConstraints() {
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        fullScreenBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Cancel button constraints
            cancelBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cancelBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cornerPointDia),

            // Share button constraints
            shareBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            shareBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -cornerPointDia),

            // Full screen button constraints
            fullScreenBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            fullScreenBtn.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        if let superviewBounds = superview?.bounds {
            frame = superviewBounds
        }
    }

    // MARK: - Drawing

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Draw background color
        let rectanglePath = UIBezierPath(rect: bounds)
        bgColor.setFill()
        rectanglePath.fill()

        // Draw transparent rectangle frame
        drawRectangle(withFrame: snapshotFrame)
    }

    private func drawRectangle(withFrame frame: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let snapshotPath = UIBezierPath(rect: frame)

        // Set clear color mode to fill transparently
        context.setBlendMode(.clear)
        color.setFill()
        snapshotPath.fill()

        if btnIsHidden {
            return
        }

        // Set to dashed line type
        context.setBlendMode(.normal)
        snapshotPath.setLineDash(phase: 0, lengths: [8, 5])
        color.setStroke()
        snapshotPath.lineWidth = 1.0
        snapshotPath.stroke()

        // Draw 4 corner points
        let cornerPoints = [
            CGRect(x: frame.minX - cornerPointDia/2, y: frame.minY - cornerPointDia/2, width: cornerPointDia, height: cornerPointDia),
            CGRect(x: frame.maxX - cornerPointDia/2, y: frame.minY - cornerPointDia/2, width: cornerPointDia, height: cornerPointDia),
            CGRect(x: frame.minX - cornerPointDia/2, y: frame.maxY - cornerPointDia/2, width: cornerPointDia, height: cornerPointDia),
            CGRect(x: frame.maxX - cornerPointDia/2, y: frame.maxY - cornerPointDia/2, width: cornerPointDia, height: cornerPointDia)
        ]

        for cornerRect in cornerPoints {
            let ovalPath = UIBezierPath(ovalIn: cornerRect)
            color.setFill()
            ovalPath.fill()
        }
    }

    // MARK: - Touch Handling

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if btnIsHidden {
            cancelBtn.isHidden = false
            fullScreenBtn.isHidden = false
            shareBtn.isHidden = false
        }
        next?.touchesBegan(touches, with: event)
    }

    // MARK: - Gesture Handling

    @objc private func onDrag(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            prePoint = panGesture.location(in: self)
            pointLocation = location(of: prePoint)

        case .changed:
            let point = panGesture.location(in: self)
            updateSnapshotFrame(with: point)
            setNeedsDisplay()

        case .ended:
            let point = panGesture.location(in: self)
            updateSnapshotFrame(with: point)
            pointLocation = .outside
            setNeedsDisplay()

        default:
            pointLocation = .outside
        }
    }

    // MARK: - Snapshot Frame Update

    private func updateSnapshotFrame(with point: CGPoint) {
        switch pointLocation {
        case .inControl:
            let size = snapshotFrame.size
            let deltaX = point.x - prePoint.x
            let deltaY = point.y - prePoint.y
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x + deltaX,
                y: snapshotFrame.origin.y + deltaY,
                width: size.width,
                height: size.height
            )
            prePoint = point

        case .onLeftEdge:
            let width = max(30, snapshotFrame.size.width + (snapshotFrame.origin.x - point.x))
            snapshotFrame = CGRect(
                x: point.x,
                y: snapshotFrame.origin.y,
                width: width,
                height: snapshotFrame.size.height
            )

        case .onRightEdge:
            let width = max(30, snapshotFrame.size.width - ((snapshotFrame.origin.x + snapshotFrame.size.width) - point.x))
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x,
                y: snapshotFrame.origin.y,
                width: width,
                height: snapshotFrame.size.height
            )

        case .onTopEdge:
            let height = max(30, snapshotFrame.size.height + (snapshotFrame.origin.y - point.y))
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x,
                y: point.y,
                width: snapshotFrame.size.width,
                height: height
            )

        case .onBottomEdge:
            let height = max(30, snapshotFrame.size.height - ((snapshotFrame.origin.y + snapshotFrame.size.height) - point.y))
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x,
                y: snapshotFrame.origin.y,
                width: snapshotFrame.size.width,
                height: height
            )

        case .onLeftTopCorner:
            let width = max(30, snapshotFrame.size.width + (snapshotFrame.origin.x - point.x))
            let height = max(30, snapshotFrame.size.height + (snapshotFrame.origin.y - point.y))
            snapshotFrame = CGRect(x: point.x, y: point.y, width: width, height: height)

        case .onRightTopCorner:
            let width = max(30, snapshotFrame.size.width - ((snapshotFrame.origin.x + snapshotFrame.size.width) - point.x))
            let height = max(30, snapshotFrame.size.height + (snapshotFrame.origin.y - point.y))
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x,
                y: point.y,
                width: width,
                height: height
            )

        case .onLeftBottomCorner:
            let width = max(30, snapshotFrame.size.width + (snapshotFrame.origin.x - point.x))
            let height = max(30, snapshotFrame.size.height - ((snapshotFrame.origin.y + snapshotFrame.size.height) - point.y))
            snapshotFrame = CGRect(
                x: point.x,
                y: snapshotFrame.origin.y,
                width: width,
                height: height
            )

        case .onRightBottomCorner:
            let width = max(30, snapshotFrame.size.width - ((snapshotFrame.origin.x + snapshotFrame.size.width) - point.x))
            let height = max(30, snapshotFrame.size.height - ((snapshotFrame.origin.y + snapshotFrame.size.height) - point.y))
            snapshotFrame = CGRect(
                x: snapshotFrame.origin.x,
                y: snapshotFrame.origin.y,
                width: width,
                height: height
            )

        default:
            break
        }

        // Constrain to bounds
        let minX = max(0, snapshotFrame.minX > 5 ? snapshotFrame.minX : 0)
        let minY = max(0, snapshotFrame.minY > 5 ? snapshotFrame.minY : 0)
        let maxX = min(bounds.size.width, snapshotFrame.maxX < bounds.size.width - 5 ? snapshotFrame.maxX : bounds.size.width)
        let maxY = min(bounds.size.height, snapshotFrame.maxY < bounds.size.height - 5 ? snapshotFrame.maxY : bounds.size.height)
        snapshotFrame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    // MARK: - Point Location Detection

    public func location(of point: CGPoint) -> PointLocation {
        let isInControl = snapshotFrame.insetBy(dx: edgePadding, dy: edgePadding).contains(point)
        let isOnTopEdge = point.y > snapshotFrame.origin.y - edgePadding && point.y < snapshotFrame.origin.y + edgePadding
        let isOnBottomEdge = point.y > snapshotFrame.maxY - edgePadding && point.y < snapshotFrame.maxY + edgePadding
        let isOnLeftEdge = point.x > snapshotFrame.origin.x - edgePadding && point.x < snapshotFrame.origin.x + edgePadding
        let isOnRightEdge = point.x > snapshotFrame.maxX - edgePadding && point.x < snapshotFrame.maxX + edgePadding
        let isOnLeftTopCorner = isOnLeftEdge && isOnTopEdge
        let isOnRightTopCorner = isOnRightEdge && isOnTopEdge
        let isOnLeftBottomCorner = isOnLeftEdge && isOnBottomEdge
        let isOnRightBottomCorner = isOnRightEdge && isOnBottomEdge

        if isInControl {
            return .inControl
        } else if isOnLeftTopCorner {
            return .onLeftTopCorner
        } else if isOnRightTopCorner {
            return .onRightTopCorner
        } else if isOnLeftBottomCorner {
            return .onLeftBottomCorner
        } else if isOnRightBottomCorner {
            return .onRightBottomCorner
        } else if isOnTopEdge {
            return .onTopEdge
        } else if isOnLeftEdge {
            return .onLeftEdge
        } else if isOnBottomEdge {
            return .onBottomEdge
        } else if isOnRightEdge {
            return .onRightEdge
        }

        return .outside
    }

    // MARK: - Button Actions

    @objc private func cancelBtnTouchUpInside(_ button: UIButton) {
        closeBlock?()
        removeFromSuperview()
    }

    @objc private func fullScreenBtnTouchUpInside(_ button: UIButton) {
        snapshotFrame = bounds
        setNeedsDisplay()
    }

    @objc private func shareBtnTouchUpInside(_ button: UIButton) {
        guard let viewController = snapshot_superView(withClass: UIViewController.self) as? UIViewController,
              let image = superview?.snapshot_image(in: snapshotFrame) else {
            return
        }

        print("======Share Image======")
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.modalPresentationStyle = .popover
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = viewController.view
                popover.sourceRect = UIScreen.main.bounds
                popover.permittedArrowDirections = []
            }
        }

        viewController.present(activityVC, animated: true, completion: nil)
        removeFromSuperview()
    }

    // MARK: - Rotation Handling

    public func rotationToInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        snapshot_rotationToInterfaceOrientation(orientation)
        removeFromSuperview()
    }

    // MARK: - Static Methods

    @discardableResult
    public static func showSnapshotMask(in view: UIView) -> LWSnapshotMaskView {
        // Check if snapshot mask already exists
        for subview in view.subviews {
            if let snapshotMask = subview as? LWSnapshotMaskView {
                view.bringSubviewToFront(snapshotMask)
                return snapshotMask
            }
        }

        // Create new snapshot mask
        let snapshotMask = LWSnapshotMaskView(frame: view.bounds)
        view.addSubview(snapshotMask)
        view.bringSubviewToFront(snapshotMask)
        return snapshotMask
    }

    public static func hideSnapshotMask(in view: UIView) {
        for subview in view.subviews {
            if subview is LWSnapshotMaskView {
                subview.removeFromSuperview()
                break
            }
        }
    }
}

// MARK: - UIView Extension

extension UIView {

    /// Get parent view of specified class type
    public func snapshot_superView<T: UIResponder>(withClass clazz: T.Type) -> UIResponder? {
        var responder: UIResponder? = self
        while responder != nil && !(responder is T) {
            responder = responder?.next
        }
        return responder is T ? responder : nil
    }

    /// Recursively send rotation message to subviews
    public func snapshot_rotationToInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        for subview in subviews {
            subview.snapshot_rotationToInterfaceOrientation(orientation)
        }
    }

    /// Capture image of UIView in specified rect
    public func snapshot_image(in rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        drawHierarchy(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: bounds.size.width, height: bounds.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
