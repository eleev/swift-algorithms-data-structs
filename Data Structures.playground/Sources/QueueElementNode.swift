import SpriteKit

public class QueueElementNode: SKSpriteNode {
    
    static let animals = [
        "bear", "buffalo", "chick", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"
    ]
    
    public init() {
        let cap = QueueElementNode.animals.count - 1
        let randomAnimalIndex = Int(arc4random_uniform(UInt32(cap)))
        let textureName = QueueElementNode.animals[randomAnimalIndex]
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
        xScale = 0.5
        yScale = 0.5
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError(#function + " required initizlier for NSCode has not been implemented")
    }
}


