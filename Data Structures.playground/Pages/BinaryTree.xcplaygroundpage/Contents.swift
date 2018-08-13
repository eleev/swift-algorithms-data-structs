//: [Previous](@previous)

import Foundation

/// This version of Binary Tree data strucure uses functional, value-based approach, instead of class-based, reference alternative. This was done to demonstrate that using Swift it's possible to use more functional style data structures development. Although take it with a grain of salt :)

enum BinaryTree<T> where T : Comparable {
    
    // MARK: - Cases
    
    case empty
    indirect case node(BinaryTree, T, BinaryTree)
    
    // MARK: - Properties
    
    var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty:
            return 0
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        case .node(_, _, _):
            return false
        }
    }
    
    var elements: [T] {
        switch self {
        case .empty:
            return []
        case .node(let left, let element, let right):
            return left.elements + [element] + right.elements
        }
    }
    
    var height: Int {
        switch self {
        case .empty:
            return 0
        case .node(let left, let _ , let right):
            return 1 + max(left.height, right.height)
        }
    }
    
    // MARK: - Static methods
    
    static func contains(element: T, tree: BinaryTree<T>) -> Bool {
        switch tree {
        case .empty:
            return false
        case .node(let left, let item, let right):
            if element < item {
                return contains(element: element, tree: left)
            } else if element > item {
                return contains(element: element, tree: right)
            }
            return true
        }
    }
    
    
    static func constructEmpty() -> BinaryTree {
        return .empty
    }
}

//: There are several ways how Binary Trees can be constructed. Classic approach is to use reference types e.g. classes. The implementation is pretty similar to the Tree data structure that is implemented in this playground file. However we used a different approach - value types... well sort of. Swift has several value types: structures (aka struct) and enumeration types (aka enum). In Swift enumeration type has many cool features and their practical application usage is far more extended and advanced in comparison to Java or Objective C for example. You may think that it sounds a bit weird... and you will be right. Value types have fixed size, meaning that compiler knows in advance the size of a struct or enum type. However when building recursion compiler does not have information about the size of the type. The last two mentioned conditions contradict each other, so we need to tell the compiler about our intentions. Swift has such mechanims and a special keyword called `indirect`. `Indirect` keyword introduces a layer of indirection behind the scenes which allows us to use value cases or whole enumeration types recursiveley. You need to note that this keyword only works with enums. Structs do not support this feature.


//: Lets conform to CustomStringConvertible and CustomDebugStringConvirtable protocols, which greathly reduces complexity of degugging and inspecting the trees.

extension BinaryTree: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Conformance to CustomStringCovertible and CustomDebugStringConvertible protocols
    
    var description: String {
        return cnstructDebugInfo()
    }
    
    var debugDescription: String {
        return cnstructDebugInfo()
    }
    
    // MARK: - Private helpers
    
    private func cnstructDebugInfo() -> String {
        switch self {
        case let .node(left, value, right):
            return """
                \t value: \(value),
                   \t left = [ \(left.description) ],
                     \t right = [ \(right.description) ]
                """
        case .empty:
            return """
                    \t
                    """
        }
    }
}

//: Usage:

//: The following expression: 2 + 3 * 5 can be easility represented by Binary Tree data structre using the following construction:

let tree5 = BinaryTree.node(.empty, "5", .empty)
let tree3 = BinaryTree.node(.empty, "3", .empty)
let treeMult = BinaryTree.node(tree5, "*", tree3)

let tree2 = BinaryTree.node(.empty, "2", .empty)
let finalTree = BinaryTree.node(tree2, "+", treeMult)

print(finalTree)

let containsThree = BinaryTree.contains(element: "3", tree: finalTree)
print(containsThree)

let containsFour = BinaryTree.contains(element: "4", tree: finalTree)
print(containsFour)

let treeElementsArray = finalTree.elements
print(treeElementsArray)

print(finalTree.height) 

//: In order to properly construct Binary Tree you need to start building the tree by layers. The means the first thing you need to do is to draw the tree and split every single operation into separate layer. Multiplying 5 and 3 is the first operation that happens, that is why we compose this operation separately and form a Binary Tree node separately. Then we define 2 as a separate leaf node and add it to the first layer, which results into a final tree node that contains all the nodes.

//: [Next](@next)
