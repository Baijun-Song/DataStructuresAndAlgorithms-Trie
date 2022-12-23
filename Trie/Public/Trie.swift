import Stack

public struct Trie<
  CollectionType: Collection & Hashable
> where CollectionType.Element: Hashable {
  @usableFromInline
  var root = InternalNode()
  
  @inlinable @inline(__always)
  public init() {}
}

extension Trie {
  @inlinable @inline(__always)
  public var isEmpty: Bool {
    count == 0
  }
  
  @inlinable @inline(__always)
  public var count: Int {
    var result = 0
    _count(from: root, result: &result)
    return result
  }
  
  @inlinable
  public mutating func insert(_ newCollection: CollectionType) {
    update()
    var currentNode = root
    for newElement in newCollection {
      if currentNode.children[newElement] == nil {
        currentNode.children[newElement] = InternalNode()
      }
      currentNode = currentNode.children[newElement]!
    }
    currentNode.isTerminating = true
  }
  
  @inlinable
  public func contains(_ collection: CollectionType) -> Bool {
    var currentNode = root
    for element in collection {
      if let child = currentNode.children[element] {
        currentNode = child
      } else {
        return false
      }
    }
    return currentNode.isTerminating
  }
  
  @inlinable
  @discardableResult
  public mutating func remove(
    _ collection: CollectionType
  ) -> CollectionType? {
    update()
    var currentNode = root
    var tracked = Stack<(
      key: CollectionType.Element,
      parentNode: InternalNode
    )>()
    for element in collection {
      if let child = currentNode.children[element] {
        tracked.push((element, currentNode))
        currentNode = child
      }
    }
    
    guard currentNode.isTerminating else {
      return nil
    }
    currentNode.isTerminating = false
    while let (key, parentNode) = tracked.pop() {
      guard
        currentNode.children.isEmpty,
        !currentNode.isTerminating
      else {
        break
      }
      currentNode = parentNode
      currentNode.children[key] = nil
    }
    return collection
  }
}

extension Trie where CollectionType: RangeReplaceableCollection {
  @inlinable @inline(__always)
  public var collections: [CollectionType] {
    collections(startingWith: .init())
  }
  
  @inlinable
  public func collections(
    startingWith possiblePrefix: CollectionType
  ) -> [CollectionType] {
    var result: [CollectionType] = []
    var currentNode = root
    for element in possiblePrefix {
      if let child = currentNode.children[element] {
        currentNode = child
      } else {
        return result
      }
    }
    _collections(
      possibleCollection: possiblePrefix,
      after: currentNode,
      result: &result
    )
    return result
  }
}
