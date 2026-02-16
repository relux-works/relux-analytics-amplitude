// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "relux-analytics-amplitude",
    platforms: [
           .iOS(.v15),
    ],
    products: [
        .library(
            name: "ReluxAnalyticsAmplitude",
            targets: ["ReluxAnalyticsAmplitude"]),
    ],
    dependencies: [
        .package(url: "https://github.com/relux-works/relux-analytics.git", from: "3.0.0"),
        .package(url: "https://github.com/relux-works/swift-amplitude.git", from: "9.0.0"),
    ],
    targets: [
        .target(
            name: "ReluxAnalyticsAmplitude",
            dependencies: [
                .product(name: "ReluxAnalytics", package: "relux-analytics"),
                .product(name: "Amplitude", package: "swift-amplitude")
            ]
        )
    ]
)
