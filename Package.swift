// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LWSnapshot",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LWSnapshot",
            targets: ["LWSnapshot"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LWSnapshot",
            dependencies: [],
            path: "LWSnapshot/Classes",
            exclude: [
                "Examples",
                "LWSnapshotMaskView.h",
                "LWSnapshotMaskView.m"
            ],
            sources: [
                "LWSnapshotMaskView.swift",
                "LWSnapshotView.swift",
                "LWSnapshot.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
