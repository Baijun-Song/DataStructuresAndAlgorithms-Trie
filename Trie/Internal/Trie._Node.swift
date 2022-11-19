extension Trie {
  final class _Node {
    var _children: [CollectionType.Element: _Node] = [:]
    var _isTerminating = false
  }
}
