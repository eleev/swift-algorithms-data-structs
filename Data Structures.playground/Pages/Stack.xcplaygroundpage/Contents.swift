//: [Previous](@previous)

/*:
 Stack is a common data structure in Comouter Science. Conceptually the data strcuture works using Last In First Out (LIFO) principle. Actually you already know how this principle works even if these are the first steps in programming. LIFO principle can be easily expressed as a stack of books: the last book added to the stack is the first one removed. Of cource, in real life you can remove any book that you want, we have more freedom to act, but imagine that books are stored in a container. That contaier physically restricts you from removing the last book, so you are forced to remove the top one in order to get to the last one. As I said - you already know what LIFO and Stack is.

 That introduction was mostly conceptual. Now lets dive into technical details and think about how we can implement such behaviour. First of all lets decide if Stack should be implemented as a class or a struct. Since structures in Swift are far more powerful than in other C-based programming languages and you can use the same protocol-oriented approach as you can with classes, it is a good idea to use structures over classes. Structures will allow us to create simple building blocks that are restricted from the box - meaning that you do not need to worry about inheritence, deinitialization and reference management.
 
 Lets think about the minimum required interface for our Stack data structure:
 
 Methods:
- push() - adds a new element to the top of the stack
- pop() - removes and returns an element from the top of the stack
- peek() - returns an elemtn form the top, but does not remove it

 Properties:
- isEmpty - returns a boolean indicator that tells if stack is empty or not
- count - contains the current number of elemtns in stack

 Stack can be implemented by using Array or Linked List data structures; each one has its pros and cons depending on the perfomance characteristics required.
 */

import UIKit

public struct Stack<T> {
    
    // MARK: - Private properties
    
    private var elements: [T]
    
    // MARK: - Public computed properties
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
    
    // MARK: - Initializers
    
    public init() {
        elements = [T]()
    }
    
    public init<S: Sequence>(stack: S) where S.Iterator.Element == T {
        self.elements = Array(stack.reversed())
    }
    
    // MARK: Methods
    
    public mutating func push(element: T) {
        elements.append(element)
    }
    
    public mutating func peek() -> T? {
        return elements.last
    }
    
    public mutating func pop() -> T? {
        return elements.popLast()
    }
    
}

/*:
 Basically we created wrapper around standard Array type. However we need to carefully take a look at the two important pieces of the implenentation:
 - T type which is a generic placeholder
 - Custom initializer that accepts iterator element of Sequence protocol - this is simply a complementary initializer that allows client-developer to pass other Stack structs, Arra or any other type that conforms to Sequnce protocol to use it at initialization phase. Convenience and compatability with standard library - nothing sophisticated.
 

 The following extension adds support for debugging capabilites for both regular "print" and "debugPrint" statements
 */

extension Stack: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return elements.description
    }
    
    public var debugDescription: String {
        return elements.description
    }
}

/*:
 Adds support for new behaviour when Stack can be initialized by an array literal e.g. [1,2,3,4] for appropriate cases. Again, this is for convenince and compatability with the standard library and other data structures.
 */
extension Stack: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: T...) {
        self.init()

        elements.forEach { element in
            self.elements.append(element)
        }
    }
}

/*:
 Adds support for Sequence protocol. The Swift's runtime will call the makeIterator() method to initialize the for...in loop. All we need to do is to return some soft of iterator instance that conforms to IteratorProtocol. Iterator protocol allows us to return an iterator based on the type of elements out target type contains - in this particular case it is Stack.
 */
extension Stack: Sequence {
    
    public func makeIterator() -> AnyIterator<T> {
        let idexedIterator = IndexingIterator(_elements: self.elements.lazy.reversed())
        return AnyIterator(idexedIterator)
    }
}


/*:
 Now lets create a sample Stack from an array literal and play around with the implementation:
 */


var stack: Stack = [1,2,3,4,5,6,7,8,1]

stack.forEach { element in
    debugPrint("element: ", element)
}

// Explicitly cast to Any to silence compiler warning.
let lastElement = stack.pop() as Any
debugPrint("last removed element: ", lastElement)

stack.push(element: 10)
debugPrint("pushed 10: ", stack)

//: [Next](@next)

