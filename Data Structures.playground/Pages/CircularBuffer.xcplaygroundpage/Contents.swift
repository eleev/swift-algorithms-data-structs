//: [Previous](@previous)

public struct CircularBuffer<T> {
    fileprivate var data: [T]
    fileprivate var head: Int = 0, tail: Int = 0
    private var internalCount: Int = 0
    private var overwriteOperation: CircularBufferOperation = CircularBufferOperation.overwrite
    
    public init() {
        data = [T]()
        data.reserveCapacity(Constants.defaultBufferCapacity)
    }
    
    public init(_ count: Int, overwriteOperation: CircularBufferOperation = .overwrite) {
        var capacity = count
        if (capacity < 1) {
            capacity = Constants.defaultBufferCapacity
            
        }
        if ((capacity & (~capacity + 1)) != capacity) {
            var b = 1
            while (b < capacity) {
                b = b << 1
                
            }
            capacity = b
            
        }
        data = [T]()
        data.reserveCapacity(capacity)
        self.overwriteOperation = overwriteOperation
    }
    
    public init<S: Sequence>(_ elements: S, size: Int) where S.Iterator.Element == T {
        self.init(size)
        elements.forEach({ push(element: $0) })
        
    }
    
    public mutating func pop() -> T? {
        if isEmpty() {
            return nil
            
        }
        let el = data[head]
        head = incrementPointer(pointer: head)
        internalCount -= 1
        return el
        
    }
    
    public func peek() -> T? {
        if isEmpty() {
            return nil
            
        }
        return data[head]
        
    }
    
    public mutating func push(element: T) {
        if isFull() {
            switch(overwriteOperation) {
            case .ignore:
                return
            case .overwrite:
                pop()
            }
        }
        if (data.endIndex < data.capacity) {
            data.append(element)
            
        } else {
            data[tail] = element
            
        }
        tail = incrementPointer(pointer: tail)
        internalCount += 1
    }
    
    public mutating func clear() {
        head = 0
        tail = 0
        internalCount = 0
        data.removeAll(keepingCapacity: true)
        
    }
    
    public var count: Int {
        return internalCount
        
    }
    
    public var capacity: Int {
        get {
            return data.capacity
        } set {
            data.reserveCapacity(newValue)
        }
    }
    
    public func isFull() -> Bool {
        return count == data.capacity
    }
    
    public func isEmpty() -> Bool {
        return (count < 1)
    }
    
    fileprivate func incrementPointer(pointer: Int) -> Int {
        return (pointer + 1) & (data.capacity - 1)
    }
    
    fileprivate func decrementPointer(pointer: Int) -> Int {
        return (pointer - 1) & (data.capacity - 1)
    }
    
    fileprivate func convertLogicalToRealIndex(logicalIndex: Int) -> Int {
        return (head + logicalIndex) & (data.capacity - 1)
    }
    
    fileprivate func checkIndex(index: Int) {
        if index < 0 || index > count {
            fatalError("Index out of range")
            
        }
    }
    
}

private struct Constants {
    fileprivate static let defaultBufferCapacity:Int = 16
    
}

public enum CircularBufferOperation {
    case ignore, overwrite
}

extension CircularBuffer: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return data.description
    }
    
    public  var debugDescription: String {
        return data.debugDescription
    }
}

extension CircularBuffer: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var newData = [T]()
        
        if count > 0 {
            newData = [T](repeating: data[head], count: count)
            if head > tail {
                let front = data.capacity - head
                newData[0..<front] = data[head..<data.capacity]
                if front < count {
                    newData[front + 1..<newData.capacity] = data[0..<count - front]
                }
            } else {
                newData[0..<tail - head] = data[head..<tail]
            }
        }
        return AnyIterator(IndexingIterator(_elements: newData.lazy))
    }
        
}


//: [Next](@next)

