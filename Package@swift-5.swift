// swift-tools-version:5.0
import PackageDescription

var package = Package(
    name: "Base32",
    products: [
      .library(name: "Base32", targets: ["Base32"])
    ],
    targets: [
        .target(name: "Base32"),
        .testTarget(name: "Base32Tests", dependencies: ["Base32"])
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)

#if os(macOS)
    package.targets.append(.testTarget(name: "SecEncodeTransformTests", dependencies: ["Base32"]))
#endif
