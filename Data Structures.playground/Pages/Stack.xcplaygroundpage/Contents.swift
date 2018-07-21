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

/*:
 Great! Everything works as expected. Now time to move on and implement visualization using SpriteKit framework. Thankfully our Stack is generic which means that we can easily create some custom SKSpriteNode classes and visualize the data structure.
 */

import SpriteKit
import PlaygroundSupport

class StackElementNode: SKSpriteNode {
    
    init() {
        let size = CGSize(width: 50, height: 150)
        
        let randomHue = CGFloat(arc4random_uniform(255))
        let randomSaturation = CGFloat(arc4random_uniform(255))
        let randomBrightness = CGFloat(arc4random_uniform(255))
        let color = SKColor(hue: randomHue, saturation: randomSaturation, brightness: randomBrightness, alpha: 1.0)
            
        super.init(texture: SKTexture(imageNamed: "book spine"), color: color, size: size)
        zRotation = 90 * CGFloat.pi / 180.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(#function + " required initizlier for NSCode has not been implemented")
    }
}



class StackScene: SKScene {
    
    var stackElements: Stack<StackElementNode>!
    
    override func didMove(to view: SKView) {
        stackElements = createRandomStackElementNodeArray(for: 5)
        appearenceAnimation()
        
        popButton()
        pushButton()
    }
    
    func popButton() {
        let popButton = SKSpriteNode(color: .white, size: CGSize(width: 120, height: 50))
        popButton.position = CGPoint(x: 150, y: 700)
        popButton.name = "pop"
        
        let popLabel = SKLabelNode(text: "Pop")
        popLabel.fontColor = SKColor.gray
        popLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        popButton.addChild(popLabel)
        addChild(popButton)
    }
    
    func pushButton() {
        let pushButton = SKSpriteNode(color: .white, size: CGSize(width: 120, height: 50))
        pushButton.position = CGPoint(x: 450, y: 700)
        pushButton.name = "push"
        
        let pushLabel = SKLabelNode(text: "Push")
        pushLabel.fontColor = SKColor.gray
        pushLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        pushButton.addChild(pushLabel)
        addChild(pushButton)
    }
    
    func appearenceAnimation() {
        
        // Animate creation of the stack of books
        
        let appearAction = SKAction.unhide()
        let moveUp = SKAction.move(to: CGPoint(x: 300, y: 500), duration: 1.0)
        
        for (index, book) in stackElements.reversed().enumerated() {
            book.position = CGPoint.init(x: 100, y: 400)
            book.isHidden = true
            addChild(book)
            
            let moveDown = SKAction.move(to: CGPoint(x: 300, y: CGFloat(50 * CGFloat(index + 1))), duration: 1.5)
            let waitAction = SKAction.wait(forDuration: TimeInterval(index * 2))
            let sequence = SKAction.sequence([waitAction, appearAction, moveUp, moveDown])
            book.run(sequence)
        }
    }
    
    func createRandomStackElementNodeArray(for numberOfElements: Int) -> Stack<StackElementNode> {
        var nodes: Stack<StackElementNode> = Stack()
        
        for _ in 0..<numberOfElements {
            let node = StackElementNode()
            nodes.push(element: node)
        }
        return nodes
    }
    
    // MARK: - Overrides
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selfLocation = touches.first?.location(in: self) else {
            return
        }
        let nodes = self.nodes(at: selfLocation)
        
        for node in nodes  {
            if node.name == "pop" {
                // pop action
                let element = stackElements.pop()
                let moveUpAction = SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 2.0)
                let fadeOut = SKAction.fadeOut(withDuration: 1.0)
                let removeAction = SKAction.removeFromParent()
                let actionSequence = SKAction.sequence([moveUpAction, fadeOut, removeAction])
                element?.run(actionSequence)
            } else if node.name == "push" {
                
                let node = StackElementNode()
                node.position = CGPoint.init(x: 100, y: 400)
                node.isHidden = true
                addChild(node)
                stackElements.push(element: node)
                
                let appearAction = SKAction.unhide()
                let moveUp = SKAction.move(to: CGPoint(x: 300, y: 500), duration: 1.0)
                let moveDown = SKAction.move(to: CGPoint(x: 300, y: CGFloat(50 * CGFloat(stackElements.count))), duration: 2.0)
                let waitAction = SKAction.wait(forDuration: TimeInterval(2))
                let sequence = SKAction.sequence([waitAction, appearAction, moveUp, moveDown])
                node.run(sequence)
            }
            
        }
    }
    
}

let skScene = StackScene(size: CGSize(width: 600, height: 800))
skScene.backgroundColor = .black


let skView = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 800))
skView.presentScene(skScene)
PlaygroundPage.current.liveView = skView

//: [Next](@next)

