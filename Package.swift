// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-svg-render",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "SVG Rendering", targets: ["SVG Rendering"]),
        .library(name: "SVG Rendering Test Support", targets: ["SVG Rendering Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-renderer.git",
            branch: "main",
            traits: ["Document"]
        ),
        .package(url: "https://github.com/swift-standards/swift-svg-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-3987.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-formatter.git",
            branch: "main",
            traits: ["Number", "Conversions", "Tagged"]
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-space.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ascii.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-dictionary.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-dictionary-ordered.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-hash-table.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-buffer-linear.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-buffer.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-buffer-ring.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-geometry.git", branch: "main", traits: ["Affine"]),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-allocation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-storage.git", branch: "main", traits: ["Generational", "Memory"]),
        .package(url: "https://github.com/swift-atoms/swift-store.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "SVG Rendering",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Renderer", package: "swift-renderer"),
                .product(name: "SVG Standard", package: "swift-svg-standard"),
                .product(name: "RFC 3987", package: "swift-rfc-3987"),
                .product(name: "ASCII", package: "swift-ascii"),
                .product(name: "Formatter", package: "swift-formatter"),
                .product(name: "Space", package: "swift-space"),
                .product(name: "Dictionary", package: "swift-dictionary"),
                .product(
                    name: "Dictionary Ordered",
                    package: "swift-dictionary-ordered"
                ),
                .product(name: "Ownership Shared Primitive", package: "swift-ownership-shared"),
                .product(name: "Hash Indexed Primitive", package: "swift-hash-table"),
                .product(name: "Hash Table Primitive", package: "swift-hash-table"),
                .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Buffer Linear Bounded Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Memory Allocator Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Geometry", package: "swift-geometry"),
            ]
        ),
        .target(
            name: "SVG Rendering Test Support",
            dependencies: [
                .target(name: "SVG Rendering"),
                .product(
                    name: "Space Test Support",
                    package: "swift-space"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "SVG Rendering Tests",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .target(name: "SVG Rendering"),
                "SVG Rendering Test Support",
            ],
            path: "Tests/SVG Rendering Tests"
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
