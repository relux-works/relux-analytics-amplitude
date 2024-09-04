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
        .package(url: "git@github.com:ivalx1s/relux-analytics.git", from: "1.0.0"),
        .package(url: "git@github.com:ivalx1s/dawrin-amplitude.git", from: "8.14.010"),
    ],
    targets: [
        .target(
            name: "ReluxAnalyticsAmplitude",
            dependencies: [
                .product(name: "ReluxAnalytics", package: "relux-analytics"),
                .product(name: "Amplitude", package: "dawrin-amplitude")
            ]
        )
    ]
)
