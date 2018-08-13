//: [Previous](@previous)

import Foundation

/// Time complexity for the Binary earch tree is O(log(n)) where n is the depth of the tree. In cases when binary seach trees are built suing linked lists, time complexity increases to O(n) since more levels need to be traveresed in order to insert/delete/find elements.
// The implementation is going to be built around reference type. We begin from declaring new class and four main properties:
// - the value that the current node holds
// - reference to the left child node
// - reference to the right child node
// - reference to the parent node
// In order to prevent retain cycle we mark the parent node property as weak and we declare each node property as an optional. That is reuiqred so we will be able to freely choose where to add new nodes.

enum BinarySearchTreeError: Error {
    case wrongMethodCall(message: String)
}

class BinarySearchTree<T: Comparable> {
    
    // MARK: - Properties
    
    var value: T
    var leftChild: BinarySearchTree?
    var rightChild: BinarySearchTree?
    weak var parent: BinarySearchTree?
    
    // MARK: - Initializers
    
    convenience init(value: T) {
        self.init(value: value, leftChild: nil, rightChild: nil, parent: nil)
    }
    
    init(value: T, leftChild: BinarySearchTree?, rightChild: BinarySearchTree?, parent: BinarySearchTree?) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
        self.parent = parent
    }
    
    // MARK: - Methods
    
    func height() -> Int {
        if leftChild == nil, rightChild == nil {
            return 0
        }
        return 1 + max(leftChild?.height() ?? 0, rightChild?.height() ?? 0)
    }
    
    func depth() -> Int {
        guard var parentNode = parent else {
            return 0
        }
        
        var depth = 1
        while let grandParentNode = parentNode.parent {
            depth += 1
            parentNode = grandParentNode
        }
        return depth
    }
    
    /// Inorder binary tree traversal simply means a traversal with the following rule: left value < node value < right value
    /// As a result we get sorted results from the smallest value to the greathest (according to the comparator patter, since each element must conform to Comparable protocol)
    /// - node: is a BinarySearchTreeNode? which you would like to traverse
    /// - handler: is an escaping closure that accept T argument and returns void. Use this injectasble closure in order to get the values from the traversal, then accumulate them or process them in place.
    class func traverseInorder(from node: BinarySearchTree?, handler: @escaping (T)->()) {
        // Exit condition from the recursize method calls
        guard let node = node else {
            return
        }
        
        traverseInorder(from: node.leftChild, handler: handler)
        handler(node.value)
        traverseInorder(from: node.rightChild, handler: handler)
    }
    
    /// Preorder binary tree traversal simply means a traversal with the following rule: node value -> left value -> right value
    /// - node: is a BinarySearchTreeNode? which you would like to traverse
    /// - handler: is an escaping closure that accept T argument and returns void. Use this injectasble closure in order to get the values from the traversal, then accumulate them or process them in place.
    class func traversePreorder(from node: BinarySearchTree?, handler: @escaping (T)->()) {
        // Exit condition from the recursize method calls
        guard let node = node else {
            return
        }
        
        handler(node.value)
        traverseInorder(from: node.leftChild, handler: handler)
        traverseInorder(from: node.rightChild, handler: handler)
    }
    
    /// Preorder binary tree traversal simply means a traversal with the following rule: left value -> right value -> node value
    /// - node: is a BinarySearchTreeNode? which you would like to traverse
    /// - handler: is an escaping closure that accept T argument and returns void. Use this injectasble closure in order to get the values from the traversal, then accumulate them or process them in place.
    class func traversePostorder(from node: BinarySearchTree?, handler: @escaping (T)->()) {
        // Exit condition from the recursize method calls
        guard let node = node else {
            return
        }
        
        traverseInorder(from: node.leftChild, handler: handler)
        traverseInorder(from: node.rightChild, handler: handler)
        handler(node.value)
    }
    
    func search(value: T) -> BinarySearchTree? {
        if value == self.value {
            return self
        }
        
        if value < self.value {
            guard let left = leftChild else {
                return nil
            }
            return left.search(value: value)
        } else {
            guard let right = rightChild else {
                return nil
            }
            return right.search(value: value)
        }
    }
    
    func insertNode(for value: T) throws {
        // If root exists that means we are trying to incert new node not from the root of the tree, so the operation is aborted
        if let _ = self.parent {
            throw BinarySearchTreeError.wrongMethodCall(message: "The method must be called from the root node")
        }
        addNode(value: value)
    }
    
    func delete() {
        if let left = leftChild {
            if let _ = rightChild {
                // 2 children
                exchangeWithSuccessor(node: self)
            } else {
                // 1 child - left
                attachParent(to: left, for: self)
            }
        } else if let right = rightChild {
            // 1 child - right
            attachParent(to: right, for: self)
        } else {
            // connet the node to the parent node
            attachParent(to: nil, for: self)
        }
        parent = nil
        leftChild = nil
        rightChild = nil
    }
    
    func deleteNode(for value: T) -> Bool {
        guard let nodeToDelete = search(value: value) else {
            return false
        }
       
        if let left = nodeToDelete.leftChild {
            if let _ = nodeToDelete.rightChild {
                // 2 children
                exchangeWithSuccessor(node: nodeToDelete)
            } else {
                // 1 child - left
                attachParent(to: left, for: nodeToDelete)
            }
        } else if let right = nodeToDelete.rightChild {
            // 1 child - right
            attachParent(to: right, for: nodeToDelete)
        } else {
            // connet the node to the parent node
            attachParent(to: nil, for: nodeToDelete)
        }
        nodeToDelete.parent = nil
        nodeToDelete.leftChild = nil
        nodeToDelete.rightChild = nil
        
        return true
    }
    
    // MARK: - Private methods

    private func addNode(value: T) {
        if value < self.value {
            if let leftChild = self.leftChild {
                leftChild.addNode(value: value)
            } else {
                let newNode = createNewNode(with: value)
                newNode.parent = self
                leftChild = newNode
            }
        } else {
            if let rightChild = self.rightChild {
                rightChild.addNode(value: value)
            } else {
                let newNode = createNewNode(with: value)
                newNode.parent = self
                rightChild = newNode
            }
        }
    }
    
    private func createNewNode(with value: T) -> BinarySearchTree {
        let newNode = BinarySearchTree(value: value)
        return newNode
    }
    
    private func attachParent(to child: BinarySearchTree?, for node: BinarySearchTree) {
        guard let parent = node.parent else {
            child?.parent = node.parent
            return
        }
        if parent.leftChild === node {
            parent.leftChild = child
            child?.parent = parent
        } else if parent.rightChild === node {
            parent.rightChild = child
            child?.parent = parent
        }
    }
    
    private func exchangeWithSuccessor(node: BinarySearchTree) {
        guard let right = node.rightChild, let left = node.leftChild else {
            return
        }
        let successor = right.minNode()
        successor.delete()
        
        successor.leftChild = left
        left.parent = successor
        
        if right !== successor {
            successor.rightChild = right
            right.parent = successor
        } else {
            successor.rightChild = nil
        }
        attachParent(to: successor, for: node)
    }
    
    private func minValue() -> T {
        if let left = leftChild {
            return left.minValue()
        } else {
            return value
        }
    }
    
    private func maxValue() -> T {
        if let right = rightChild {
            return right.maxValue()
        } else {
            return value
        }
    }
    
    private func minNode() -> BinarySearchTree {
        if let left = leftChild {
            return left.minNode()
        } else {
            return self
        }
    }
    
    private func maxNode() -> BinarySearchTree {
        if let right = rightChild {
            return right.maxNode()
        } else {
            return self
        }
    }
    
}

extension BinarySearchTree: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Overriden properties
    
    var description: String {
        return prepareStringConvertable()
    }
    
    var debugDescription: String {
        return prepareStringConvertable()
    }
    
    // MARK: - Methods
    
    func prepareStringConvertable() -> String {
        var desc = """
        value: \(value)
        """
        
        if let leftChild = self.leftChild {
            desc += """
            \t left: [\(leftChild.description)]
            
            """
        }
        if let rightChild = self.rightChild {
            desc += """
            \t right: [\(rightChild.description)]
            """
        }
        
        return desc
    }
}

//: Usage:

// Let's use Int as out type for the current tree and see what results it produces in practice:

let rootNode = BinarySearchTree(value: 10)
try! rootNode.insertNode(for: 20)
try! rootNode.insertNode(for: 5)
try! rootNode.insertNode(for: 21)
try! rootNode.insertNode(for: 8)
try! rootNode.insertNode(for: 16)
try! rootNode.insertNode(for: 4)

print(rootNode)

let wasDeleted = rootNode.deleteNode(for: 5)
print("wasDeleted ", wasDeleted)

print(rootNode)

var assembledElements = [Int]()
BinarySearchTree.traverseInorder(from: rootNode, handler: { value in
    assembledElements += [value]
})
print(assembledElements)

var preorderElements = [Int]()
BinarySearchTree.traversePreorder(from: rootNode, handler: { value in
    preorderElements += [value]
})
print(preorderElements)

var postorderElements = [Int]()
BinarySearchTree.traversePostorder(from: rootNode, handler: { value in
    postorderElements += [value]
})
print(postorderElements)

// Search the number
let node = rootNode.search(value: 5)
print(node as Any)

// Great! Now let's change the type to String and do the same:

let rootNodeString = BinarySearchTree(value: "Hello")
try! rootNodeString.insertNode(for: "World")
try! rootNodeString.insertNode(for: "We")
try! rootNodeString.insertNode(for: "Love")
try! rootNodeString.insertNode(for: "Swift")
try! rootNodeString.insertNode(for: "Programming")
try! rootNodeString.insertNode(for: "Language")

print(rootNodeString)

var assembledElementsString = [String]()
BinarySearchTree.traverseInorder(from: rootNodeString, handler: { value in
    assembledElementsString += [value]
})
print(assembledElementsString)

//: [Next](@next)
