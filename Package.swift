// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftUpdater",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "SwiftUpdater",
            targets: ["SwiftUpdater"]
        ),
        .library(
            name: "SwiftUpdaterUI",
            targets: ["SwiftUpdaterUI"]
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
        .target(
            name: "SwiftUpdaterUI",
            dependencies: ["SwiftUpdater"],
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
