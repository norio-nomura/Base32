import Foundation

#if !swift(>=4.2)
extension Collection {
    public func firstIndex(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Index? {
        return try index(where: predicate)
    }
}
#endif

#if swift(>=4.2)
#if !compiler(>=5)
extension Data {
    func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
        return try withUnsafeBytes {
            try apply(UnsafeRawBufferPointer(start: $0, count: count))
        }
    }
}
#endif
#else
extension Data {
    func withUnsafeBytes<Result>(_ apply: (UnsafeRawBufferPointer) throws -> Result) rethrows -> Result {
        return try withUnsafeBytes {
            try apply(UnsafeRawBufferPointer(start: $0, count: count))
        }
    }
}
#endif
