extension Trie {
  mutating func _update() {
    guard !isKnownUniquelyReferenced(&_root) else {
      return
    }
    _root = __duplicate(_root)
  }
  
  private func __duplicate(
    _ node: _Node
  ) -> _Node {
    let newNode = _Node()
    newNode._isTerminating = node._isTerminating
    for (key, child) in node._children {
      newNode._children[key] = __duplicate(child)
    }
    return newNode
  }
}
