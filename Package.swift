import PackageDescription

let package = Package(
    name: "Base32",
    exclude: {
        #if os(Linux)
            return ["Tests/SecEncodeTransformTests"]
        #else
            return []
        #endif
    }()
)
