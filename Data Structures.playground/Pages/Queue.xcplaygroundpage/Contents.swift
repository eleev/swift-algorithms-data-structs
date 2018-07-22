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
        self.init()
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
    
    // MARK: - Private methods
    
    private  func checkIndex(index: Int) throws {
        if index < 0 || index > count {
            throw QueueError.indexOutOfRange
        }
    }
    
}

// MARK: - Custom error enum type declaration

enum QueueError: Error {
    case indexOutOfRange
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

// MARK: - Sequnce protocol conformance

extension Queue: Sequence {

    public func makeIterator() -> AnyIterator<T> {
        let indexedIterator = IndexingIterator(_elements: data.lazy)
        return AnyIterator(indexedIterator)
    }
    
    public func generate() -> AnyIterator<T> {
        let indexingIteratoer = IndexingIterator(_elements: data.lazy)
        return AnyIterator(indexingIteratoer)
        
    }
}

// MARK: - MutableCollection protocol conformance

extension Queue: MutableCollection {
    
    // MARK: - Core protocol conformance
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return count - 1
    }
    
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
    
    // MARK: - Subscript implementation
    
    public subscript(index: Int) -> T {
        get {
            checkHandledIndex(index: index)
            return data[index]
        }
        set {
            checkHandledIndex(index: index)
            data[index] = newValue
        }
    }
    
    // MARK: - Utility method
    
    private func checkHandledIndex(index: Int) {
        do {
            try checkIndex(index: index)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}


//: The next step is to implement interactive scene for the data structure:

import SpriteKit
import PlaygroundSupport

class QueueScene: SKScene {
    
    var queueElements: Queue<QueueElementNode>! {
        didSet {
            if queueElements != nil {
                numberOfElements.text = "\(queueElements.count) animals"
            }
        }
    }
    lazy var numberOfElements: SKLabelNode = {
        let label = SKLabelNode(text: "0 animals")
        label.position = CGPoint(x: 500, y: 300)
        label.color = .gray
        label.fontSize = 28
        label.verticalAlignmentMode = .center
        return label
    }()
    
    override func didMove(to view: SKView) {
        queueElements = createRandomQeueueElementNodeArray(for: 4)
        appearenceAnimation()
        
        dequeueButton()
        enqueueButton()
        label()
        description()
        
        addChild(numberOfElements)
    }
    
    func label() {
        let nameLabel = SKLabelNode(text: "Queue")
        nameLabel.position = CGPoint(x: 300, y: 760)
        nameLabel.color = .gray
        nameLabel.fontSize = 64
        nameLabel.verticalAlignmentMode = .center
        addChild(nameLabel)
    }
    
    func description() {
        let nameLabel = SKLabelNode(text: "Limit is 7 animals")
        nameLabel.position = CGPoint(x: 300, y: 700)
        nameLabel.color = .darkGray
        nameLabel.fontSize = 24
        nameLabel.verticalAlignmentMode = .center
        addChild(nameLabel)
    }
    
    func dequeueButton() {
        let popButton = SKSpriteNode(color: .white, size: CGSize(width: 120, height: 50))
        popButton.position = CGPoint(x: 100, y: 700)
        popButton.name = "pop"
        
        let popLabel = SKLabelNode(text: "Dequeue")
        popLabel.fontColor = SKColor.darkGray
        popLabel.fontSize = 24
        
        popLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        popButton.addChild(popLabel)
        addChild(popButton)
    }
    
    func enqueueButton() {
        let pushButton = SKSpriteNode(color: .white, size: CGSize(width: 120, height: 50))
        pushButton.position = CGPoint(x: 500, y: 700)
        pushButton.name = "push"
        
        let pushLabel = SKLabelNode(text: "Enqueue")
        pushLabel.fontColor = SKColor.darkGray
        pushLabel.fontSize = 24
        pushLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        pushButton.addChild(pushLabel)
        addChild(pushButton)
    }
    
    func appearenceAnimation() {
        
        // Animate creation of the stack of books
        
        let appearAction = SKAction.unhide()
        
        for (index, book) in queueElements.enumerated() {
            book.position = CGPoint.init(x: 300, y: 500)
            book.isHidden = true
            addChild(book)
            
            let moveDown = SKAction.move(to: CGPoint(x: 300, y: CGFloat(80 * CGFloat(index + 1))), duration: 1.5)
            let waitAction = SKAction.wait(forDuration: TimeInterval(index * 2))
            let sequence = SKAction.sequence([waitAction, appearAction, moveDown])
            book.run(sequence)
        }
    }
    
    func createRandomQeueueElementNodeArray(for numberOfElements: Int) -> Queue<QueueElementNode> {
        var nodes: Queue<QueueElementNode> = Queue()
        
        for _ in 0..<numberOfElements {
            let node = QueueElementNode()
            nodes.enqueue(element: node)
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
                let element = queueElements.dequeue()
                let moveUpAction = SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 0.5)
                let removeAction = SKAction.removeFromParent()
                let moveQueueDown = SKAction.run {
                    let moveDownAction = SKAction.move(by: CGVector(dx: 0, dy: -80), duration: 0.5)
                    self.queueElements.forEach({ (node) in
                        node.run(moveDownAction)
                    })
                }
                let actionSequence = SKAction.sequence([moveUpAction, removeAction, moveQueueDown])
                element?.run(actionSequence)
            } else if node.name == "push", queueElements.count < 7  {
                let node = QueueElementNode()
                node.position = CGPoint.init(x: 300, y: 600)
                node.isHidden = true
                addChild(node)
                queueElements.enqueue(element: node)
                
                let appearAction = SKAction.unhide()
                let moveDown = SKAction.move(to: CGPoint(x: 300, y: CGFloat(80 * CGFloat(queueElements.count))), duration: 1.5)
                let waitAction = SKAction.wait(forDuration: TimeInterval(1))
                let sequence = SKAction.sequence([waitAction, appearAction, moveDown])
                node.run(sequence)
            }
            
        }
    }
    
}

let skScene = QueueScene(size: CGSize(width: 600, height: 800))
skScene.backgroundColor = .black


let skView = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 800))
skView.presentScene(skScene)
PlaygroundPage.current.liveView = skView


//: [Next](@next)
