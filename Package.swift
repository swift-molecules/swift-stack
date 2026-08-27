// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-stack",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Stack",
            targets: ["Stack"]
        ),
        .library(
            name: "Stack Standard Library Integration",
            targets: ["Stack Standard Library Integration"]
        ),
        .library(
            name: "Stack Apple Foundation Integration",
            targets: ["Stack Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Stack",
            dependencies: [
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(
                    name: "Buffer Linear Bounded Primitive",
                    package: "swift-buffer-linear"
                ),
                .product(name: "Storage Primitive", package: "swift-storage"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Index", package: "swift-index"),
            ]
        ),
        .target(
            name: "Stack Standard Library Integration",
            dependencies: ["Stack"]
        ),
        .target(
            name: "Stack Apple Foundation Integration",
            dependencies: [
                "Stack",
                "Stack Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Stack Tests",
            dependencies: ["Stack"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
