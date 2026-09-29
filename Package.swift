// swift-tools-version: 6.4

import PackageDescription

extension String {
    static let svgRendering: Self = "SVG Rendering"
    var tests: Self { self + " Tests" }
}

extension Target.Dependency {
    static var svgRendering: Self { .target(name: .svgRendering) }
}

extension Target.Dependency {
    static var rendering: Self {
        .product(name: "Renderer", package: "swift-renderer")
    }
    static var svgStandard: Self {
        .product(name: "SVG Standard", package: "swift-svg-standard")
    }
    static var ascii: Self {
        .product(name: "ASCII", package: "swift-ascii")
    }
    static var formatting: Self {
        .product(name: "Formatter", package: "swift-formatter")
    }
    static var dimension: Self {
        .product(name: "Spatial", package: "swift-spatial")
    }
    static var dictionary: Self {
        .product(name: "Dictionary", package: "swift-dictionary")
    }
    static var sharedPrimitive: Self {
        .product(name: "Ownership Shared Primitive", package: "swift-ownership-shared")
    }
    static var hashIndexedPrimitive: Self {
        .product(name: "Hash Indexed Primitive", package: "swift-hash-table")
    }

    static var hashTablePrimitive: Self {
        .product(name: "Hash Table Primitive", package: "swift-hash-table")
    }
    static var bufferLinearPrimitive: Self {
        .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear")
    }
}

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
        .library(name: .svgRendering, targets: [.svgRendering]),
        .library(name: "SVG Rendering Test Support", targets: ["SVG Rendering Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-renderer.git",
            branch: "main", traits: ["Document"]),
        .package(url: "https://github.com/swift-standards/swift-svg-standard.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-formatter.git",
            branch: "main", traits: ["Number", "Conversions", "Tagged"]),
        .package(
            url: "https://github.com/swift-atoms/swift-spatial.git",
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
            name: .svgRendering,
            dependencies: [
                .rendering,
                .svgStandard,
                .ascii,
                .formatting,
                .dimension,
                .dictionary,
                .product(
                    name: "Dictionary Ordered",
                    package: "swift-dictionary-ordered"
                ),
                .sharedPrimitive,
                .hashIndexedPrimitive,
                .hashTablePrimitive,
                .bufferLinearPrimitive,
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Buffer Linear Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer Linear Bounded Primitive", package: "swift-buffer-linear"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Memory Allocator Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Pool", package: "swift-memory-allocation"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Ownership Shared Primitive", package: "swift-ownership-shared"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Geometry", package: "swift-geometry"),
                .product(name: "SVG Standard", package: "swift-svg-standard"),
            ]
        ),
        .target(
            name: "SVG Rendering Test Support",
            dependencies: [
                .svgRendering,
                .product(
                    name: "Spatial Test Support",
                    package: "swift-spatial"
                ),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: .svgRendering.tests,
            dependencies: [
                .svgRendering,
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
