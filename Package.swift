// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftUpdater",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "SwiftUpdater",
            targets: ["SwiftUpdater"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            from: "0.1.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftUpdater",
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLintPlugins"
                )
            ]
        ),
        .testTarget(
            name: "SwiftUpdaterTests",
            dependencies: ["SwiftUpdater"],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLintPlugins"
                )
            ]
        )
    ]
)
