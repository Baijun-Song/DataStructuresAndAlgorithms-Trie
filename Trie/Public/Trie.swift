import Stack

public struct Trie<
  CollectionType: Collection & Hashable
> where CollectionType.Element: Hashable {
  var _root = _Node()
  
  public init() {}
}

extension Trie {
  public var isEmpty: Bool {
    count == 0
  }
  
  public var count: Int {
    var result = 0
    __count(from: _root, result: &result)
    return result
  }
  
  private func __count(
    from node: _Node,
    result: inout Int
  ) {
    if node._isTerminating {
      result += 1
    }
    for (_, child) in node._children {
      __count(from: child, result: &result)
    }
  }
  
  public mutating func insert(_ newCollection: CollectionType) {
    _update()
    var currentNode = _root
    for newElement in newCollection {
      if currentNode._children[newElement] == nil {
        currentNode._children[newElement] = _Node()
      }
      currentNode = currentNode._children[newElement]!
    }
    currentNode._isTerminating = true
  }
  
  public func contains(_ collection: CollectionType) -> Bool {
    var currentNode = _root
    for element in collection {
      if let child = currentNode._children[element] {
        currentNode = child
      } else {
        return false
      }
    }
    return currentNode._isTerminating
  }
  
  @discardableResult
  public mutating func remove(
    _ collection: CollectionType
  ) -> CollectionType? {
    _update()
    var currentNode = _root
    var tracked = Stack<(
      key: CollectionType.Element,
      parentNode: _Node
    )>()
    for element in collection {
      if let child = currentNode._children[element] {
        tracked.push((element, currentNode))
        currentNode = child
      }
    }
    
    guard currentNode._isTerminating else {
      return nil
    }
    currentNode._isTerminating = false
    while let (key, parentNode) = tracked.pop() {
      guard
        currentNode._children.isEmpty,
        !currentNode._isTerminating
      else {
        break
      }
      currentNode = parentNode
      currentNode._children[key] = nil
    }
    return collection
  }
}

extension Trie where CollectionType: RangeReplaceableCollection {
  public var collections: [CollectionType] {
    collections(startingWith: .init())
  }
  
  public func collections(
    startingWith possiblePrefix: CollectionType
  ) -> [CollectionType] {
    var result: [CollectionType] = []
    var currentNode = _root
    for element in possiblePrefix {
      if let child = currentNode._children[element] {
        currentNode = child
      } else {
        return result
      }
    }
    __collections(
      possibleCollection: possiblePrefix,
      after: currentNode,
      result: &result
    )
    return result
  }
  
  private func __collections(
    possibleCollection: CollectionType,
    after node: _Node,
    result: inout [CollectionType]
  ) {
    if node._isTerminating {
      result.append(possibleCollection)
    }
    for (key, child) in node._children {
      var possibleCollection = possibleCollection
      possibleCollection.append(key)
      __collections(
        possibleCollection: possibleCollection,
        after: child,
        result: &result
      )
    }
  }
}
