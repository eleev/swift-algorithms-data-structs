import Foundation

class RedBlackTreeNode<T: Comparable> {
    var value: T
    var isRed: Bool
    var left: RedBlackTreeNode?
    var right: RedBlackTreeNode?

    init(value: T, isRed: Bool, left: RedBlackTreeNode?, right: RedBlackTreeNode?) {
        self.value = value
        self.isRed = isRed
        self.left = left
        self.right = right
    }

    static func isRedNode(node: RedBlackTreeNode?) -> Bool {
        if (node == nil) {
            return false
        }
        return node!.isRed
    }

    func clockwiseRotate() -> RedBlackTreeNode {
        let t = self.left!
        self.left = t.right
        t.right = self
        t.isRed = RedBlackTreeNode.isRedNode(node: t.right)
        t.right!.isRed = true
        return t
    }

    func counterclockwiseRotate() -> RedBlackTreeNode {
        let t = self.right!
        self.right = t.left
        t.left = self
        t.isRed =  RedBlackTreeNode.isRedNode(node: t.left)
        t.left!.isRed = true
        return t
    }

    func flip() {
        self.isRed = !self.isRed
    }

    func exchange() {
        self.flip()
        self.left?.flip()
        self.right?.flip()
    }

    func minimum() -> RedBlackTreeNode {
        if (self.left == nil) {
            return self
        }
        return self.left!.minimum()
    }

    func maximum() -> RedBlackTreeNode {
        if (self.right == nil) {
            return self
        }
        return self.right!.maximum()
    }

    func bubbleUp() -> RedBlackTreeNode {
        var t = self
        if (RedBlackTreeNode.isRedNode(node: t.right)) {
            t = t.counterclockwiseRotate()
        }
        if (RedBlackTreeNode.isRedNode(node: t.left) && RedBlackTreeNode.isRedNode(node: t.left!.left)) {
            t = t.clockwiseRotate()
        }
        if (RedBlackTreeNode.isRedNode(node: t.left) && RedBlackTreeNode.isRedNode(node: t.right)) {
            t.exchange()
        }
        return t
    }

    func alignLeftNode() -> RedBlackTreeNode {
        var t = self
        t.exchange()
        if (self.right != nil && RedBlackTreeNode.isRedNode(node: t.right!.left)) {
            t.right = t.right!.clockwiseRotate()
            t = t.counterclockwiseRotate()
            t.exchange()
        }
        return t
    }

    func alignRightNode() -> RedBlackTreeNode {
        var t = self
        t.exchange()
        if (self.left != nil && RedBlackTreeNode.isRedNode(node: t.left!.left)) {
            t = t.clockwiseRotate()
            t.exchange()
        }
        return t
    }

    func search(value: T) -> RedBlackTreeNode? {
        if (self.value == value) {
            return self
        } else if (self.value < value) {
            return self.left?.search(value: value)
        } else {
            return self.right?.search(value: value)
        }
    }

    func removeMinimum() -> RedBlackTreeNode? {
        if (self.left == nil) {
            return nil
        }
        var t = self
        if (!RedBlackTreeNode.isRedNode(node: t.left) && !RedBlackTreeNode.isRedNode(node: t.left!.left)) {
            t = t.alignLeftNode()
        }
        t.left = t.left!.removeMinimum()
        return t.bubbleUp()
    }

    func preorderTraversal() -> Array<T> {
        var traversal: Array<T> = [self.value]
        if (self.left != nil) {
            traversal += left!.inorderTraversal()
        }
        if (self.right != nil) {
            traversal += right!.inorderTraversal()
        }
        return traversal;
    }

    func inorderTraversal() -> Array<T> {
        var traversal: Array<T> = []
        if (self.left != nil) {
            traversal += left!.inorderTraversal()
        }
        traversal += [self.value]
        if (self.right != nil) {
            traversal += right!.inorderTraversal()
        }
        return traversal;
    }

    func postorderTraversal() -> Array<T> {
        var traversal: Array<T> = []
        if (self.left != nil) {
            traversal += left!.inorderTraversal()
        }
        if (self.right != nil) {
            traversal += right!.inorderTraversal()
        }
        traversal += [self.value]
        return traversal;
    }
}

class RedBlackTree<T: Comparable> {
    var root: RedBlackTreeNode<T>? = nil

    static func insert(inRoot: RedBlackTreeNode<T>?, val: T) -> RedBlackTreeNode<T>? {
        var root = inRoot
        if (root == nil) {
            return RedBlackTreeNode(value: val, isRed: true, left: nil, right: nil)
        }
        if (RedBlackTreeNode.isRedNode(node: root!.left) && RedBlackTreeNode.isRedNode(node: root!.right)) {
            root!.exchange()
        }
        if (val == root!.value) {
            root!.value = val
        } else if (val < root!.value) {
            root!.left = insert(inRoot: root!.left, val: val)
        } else {
            root!.right = insert(inRoot: root!.right, val: val)
        }
        if (RedBlackTreeNode.isRedNode(node: root!.right)) {
            root = root!.counterclockwiseRotate()
        }
        if (RedBlackTreeNode.isRedNode(node: root!.left) && RedBlackTreeNode.isRedNode(node: root!.left!.left)) {
            root = root!.clockwiseRotate()
        }
        if (RedBlackTreeNode.isRedNode(node: root!.left) && RedBlackTreeNode.isRedNode(node: root!.right)) {
            root!.exchange();
        }
        return root;
    }

    static func remove(inRoot: RedBlackTreeNode<T>?, val: T) -> RedBlackTreeNode<T>? {
        var root = inRoot;
        if (val < root!.value) {
            if (root!.left != nil && !(RedBlackTreeNode.isRedNode(node: root!.left)) && !(RedBlackTreeNode.isRedNode(node: root!.left!.left))) {
                root = root!.alignLeftNode()
            }
            root!.left = remove(inRoot: root!.left, val: val);
        } else {
            if (RedBlackTreeNode.isRedNode(node: root!.left)) {
                root = root!.clockwiseRotate()
            }
            if (val == root!.value && root!.right == nil) {
                return nil
            }
            if (root!.right != nil && !(RedBlackTreeNode.isRedNode(node: root!.right)) && !(RedBlackTreeNode.isRedNode(node: root!.right!.left))) {
                root = root!.alignRightNode()
            }
            if (val == root!.value) {
                root!.value = root!.right!.minimum().value
                root!.right = root!.right!.removeMinimum()
            } else {
                root!.right = remove(inRoot: root!.right, val: val);
            }
        }
        return root!.bubbleUp()
    }

    func insert(value: T) {
        root = RedBlackTree.insert(inRoot: root, val: value)
        if (root != nil) {
            root!.isRed = false
        }
    }

    func remove(value: T) {
        if (search(value: value) == nil) {
            return
        }
        root = RedBlackTree.remove(inRoot: root, val: value)
        if (root != nil) {
            root!.isRed = false
        }
    }

    func search(value: T) -> RedBlackTreeNode<T>? {
        return root?.search(value: value)
    }

    func preorderTraversal() -> Array<T> {
        if (root == nil) {
            return Array<T>()
        }
        return root!.preorderTraversal()
    }

    func inorderTraversal() -> Array<T> {
        if (root == nil) {
            return Array<T>()
        }
        return root!.inorderTraversal()
    }

    func postorderTraversal() -> Array<T> {
        if (root == nil) {
            return Array<T>()
        }
        return root!.postorderTraversal()
    }
}
