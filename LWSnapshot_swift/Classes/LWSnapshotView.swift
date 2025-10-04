//
// LWSnapshotView.swift
// SwiftUI wrapper for LWSnapshotMaskView
// Created by Luo Wei on 2025/10/04.
// Copyright (c) 2017 wodedata. All rights reserved.
//

import SwiftUI

// MARK: - LWSnapshotView (SwiftUI)

@available(iOS 13.0, *)
public struct LWSnapshotView: UIViewRepresentable {

    @Binding var isPresented: Bool
    var onClose: (() -> Void)?
    var snapshotFrame: Binding<CGRect>?

    public init(
        isPresented: Binding<Bool>,
        snapshotFrame: Binding<CGRect>? = nil,
        onClose: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.snapshotFrame = snapshotFrame
        self.onClose = onClose
    }

    public func makeUIView(context: Context) -> LWSnapshotMaskView {
        let view = LWSnapshotMaskView(frame: .zero)
        view.closeBlock = {
            isPresented = false
            onClose?()
        }
        return view
    }

    public func updateUIView(_ uiView: LWSnapshotMaskView, context: Context) {
        if let snapshotFrame = snapshotFrame {
            snapshotFrame.wrappedValue = uiView.snapshotFrame
        }
    }
}

// MARK: - View Extension for SwiftUI

@available(iOS 13.0, *)
extension View {
    /// Present snapshot mask view
    public func snapshot(
        isPresented: Binding<Bool>,
        snapshotFrame: Binding<CGRect>? = nil,
        onClose: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                LWSnapshotView(
                    isPresented: isPresented,
                    snapshotFrame: snapshotFrame,
                    onClose: onClose
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

// MARK: - Snapshot Modifier

@available(iOS 13.0, *)
public struct SnapshotModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onClose: (() -> Void)?

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                LWSnapshotView(isPresented: $isPresented, onClose: onClose)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

@available(iOS 13.0, *)
extension View {
    public func snapshotMask(isPresented: Binding<Bool>, onClose: (() -> Void)? = nil) -> some View {
        modifier(SnapshotModifier(isPresented: isPresented, onClose: onClose))
    }
}
