#if !swift(>=4.2)
extension Collection {
    public func firstIndex(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Index? {
        return try index(where: predicate)
    }
}
#endif
