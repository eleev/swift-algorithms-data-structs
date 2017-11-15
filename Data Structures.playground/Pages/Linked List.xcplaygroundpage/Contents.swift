//: [Previous](@previous)

public struct LinkedList<T> {
    
    // MARK: - Private properties
    
    fileprivate var head: Node<T>?
    fileprivate var _count: Int
    
    // MARK: - Public properties
    
    public var count: Int {
        return _count
    }
    
    // MARK: - Initializers
    
    public init() {
        head = nil
        _count = 0
    }
    
    // MARK: - API Methods
    
    public mutating func push(element: T) {
        let node = Node<T>(data: element)
        node.next = head
        head = node
        _count += 1
    }
    
    public mutating func pop() -> T? {
        if isEmpty() { return nil }
        
        let element = head?.data
        head = head?.next
        _count -= 1
        
        return element
    }
    
    public func peek() -> T? {
        return head?.data
    }
    
    public func isEmpty() -> Bool {
        return _count == 0
    }
    
}

/// Node class represents a generic node element that is used to construct resursuve linked list
private class Node<T> {
    fileprivate var next: Node<T>?
    fileprivate var data: T
    
    init(data: T) {
        next = nil
        self.data = data
    }
}


//: [Next](@next)
