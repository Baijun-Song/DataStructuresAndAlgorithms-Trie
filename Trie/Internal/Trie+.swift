extension Trie {
  @usableFromInline
  func _count(
    from node: InternalNode,
    result: inout Int
  ) {
    if node.isTerminating {
      result += 1
    }
    for (_, child) in node.children {
      _count(from: child, result: &result)
    }
  }
}

extension Trie where CollectionType: RangeReplaceableCollection {
  @usableFromInline
  func _collections(
    possibleCollection: CollectionType,
    after node: InternalNode,
    result: inout [CollectionType]
  ) {
    if node.isTerminating {
      result.append(possibleCollection)
    }
    for (key, child) in node.children {
      var possibleCollection = possibleCollection
      possibleCollection.append(key)
      _collections(
        possibleCollection: possibleCollection,
        after: child,
        result: &result
      )
    }
  }
}
