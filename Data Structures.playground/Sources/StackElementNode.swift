import SpriteKit

public class StackElementNode: SKSpriteNode {
    
    public init() {
        let size = CGSize(width: 50, height: 150)
        
        let randomHue = CGFloat(arc4random_uniform(255))
        let randomSaturation = CGFloat(arc4random_uniform(255))
        let randomBrightness = CGFloat(arc4random_uniform(255))
        let color = SKColor(hue: randomHue, saturation: randomSaturation, brightness: randomBrightness, alpha: 1.0)
        
        super.init(texture: SKTexture(imageNamed: "book spine"), color: color, size: size)
        zRotation = 90 * CGFloat.pi / 180.0
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError(#function + " required initizlier for NSCode has not been implemented")
    }
}

