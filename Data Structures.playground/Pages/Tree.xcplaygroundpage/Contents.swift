//: [Previous](@previous)

import Foundation

class Node<T: Comparable> {
    
    // MARK: - Properties
    
    weak var parent: Node?
    var value: T
    var children: [Node] = []
    
    // MARK: - Initializers
    
    init(value: T) {
        self.value = value
    }
    
    // MARK: - Methods
    
    
    func insert(child: Node) {
        children.append(child)
        child.parent = self
    }
    
    func search(value: T) -> Node? {
        if value == self.value {
            return self
        }
        
        children.forEach { child in
            if let foundChild = child.search(value: value) {
                return foundChild
            }
        }
        return nil
    }
    
}

extension Node: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Overriden properties
    
    var description: String {
        return prepareStringConvertable()
    }
    
    var debugDescription: String {
        return prepareStringConvertable()
    }
    
    // MARK: - Methods
    
    func prepareStringConvertable() -> String {
        var desc = "\(value)"
        
        if !children.isEmpty {
            desc += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return desc
    }
}


//: Usage

let nodeApple = Node<String>(value: "Apple")
let nodeFoo = Node<String>(value: "Foo")
let nodeBar = Node<String>(value: "Bar")
let nodeChair = Node<String>(value: "Chair")

nodeApple.insert(child: nodeFoo)
nodeApple.insert(child: nodeBar)
nodeBar.insert(child: nodeChair)

print(nodeApple)

//: [Next](@next)
