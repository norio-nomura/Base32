// swift-tools-version:4.2
import PackageDescription

var package = Package(
    name: "Base32",
    products: [
      .library(name: "Base32", targets: ["Base32"])
    ],
    targets: [
        .target(name: "Base32"),
        .testTarget(name: "Base32Tests", dependencies: ["Base32"])
    ]
)

#if os(macOS)
    package.targets.append(.testTarget(name: "SecEncodeTransformTests", dependencies: ["Base32"]))
#endif
