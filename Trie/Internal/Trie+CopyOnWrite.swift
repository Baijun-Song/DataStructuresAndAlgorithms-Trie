extension Trie {
  @inlinable @inline(__always)
  mutating func update() {
    guard !isKnownUniquelyReferenced(&root) else {
      return
    }
    root = _duplicate(root)
  }
  
  @usableFromInline
  func _duplicate(
    _ node: InternalNode
  ) -> InternalNode {
    let newNode = InternalNode()
    newNode.isTerminating = node.isTerminating
    for (key, child) in node.children {
      newNode.children[key] = _duplicate(child)
    }
    return newNode
  }
}
