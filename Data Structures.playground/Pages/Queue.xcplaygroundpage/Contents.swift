//: [Previous](@previous)

import Foundation

public struct Queue<T> {
    
    // MARK: - Private properties
    
    private var data: [T]
    
    // MARK: - Public properties
    
    public var count: Int {
        return data.count
    }
    
    public var capacity: Int {
        get {
            return data.capacity
        }
        set {
            data.reserveCapacity(capacity)
        }
    }
    
    // MARK: - Initializers
    
    public init() {
        data = [T]()
    }
    
    public init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
        data.append(contentsOf: elements)
    }
    
    
    // MARK: - API methods 
    
    public mutating func dequeue() -> T? {
        return data.removeFirst()
    }
    
    public func peek() -> T? {
        return data.first
    }
    
    public mutating func enqueue(element: T) {
        data.append(element)
    }
    
    public mutating func clear() {
        data.removeAll()
    }
    
    public func isFull() -> Bool {
        return count == data.capacity
    }
    
    public func isEmpty() -> Bool {
        return data.isEmpty
    }
    
}

// MARK: - CustomStringConvertable and CustomStirngDebugConvertable protocols conformance

extension Queue: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return data.description
    }
    
    public var debugDescription: String {
        return data.description
    }
}

// MARK: - ExpressibleByArrayLiteral protocol conformance

extension Queue: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}


//: [Next](@next)
