//: [Previous](@previous)

import Foundation

enum RedBlackTreeColorType: Int {
    case red = 0, black
}

class RedBlackTree<T: Comparable> {
    
    // MARK: - Properties
    
    var value: T
    var color: RedBlackTreeColorType
    var leftChild: RedBlackTree?
    var rightChild: RedBlackTree?
    weak var parent: RedBlackTree?
    
    // MARK: Initializers
    
    convenience init(value: T) {
        self.init(value: value, color: .black, leftChild: nil, rightChild: nil, parent: nil)
    }
    
    init(value: T, color: RedBlackTreeColorType, leftChild: RedBlackTree?, rightChild: RedBlackTree?, parent: RedBlackTree?) {
        self.value = value
        self.color = color
        self.leftChild = leftChild
        self.rightChild = rightChild
        self.parent = parent
    }
    
    // MARK: - Methods
    
    // FIXME: - Requires implementation 
    
}


//: [Next](@next)
