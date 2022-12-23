extension Trie {
  @usableFromInline
  final class InternalNode {
    @usableFromInline
    var children: [CollectionType.Element: InternalNode] = [:]
    
    @usableFromInline
    var isTerminating = false
    
    @inlinable @inline(__always)
    init() {}
  }
}
