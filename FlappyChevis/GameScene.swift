//
//  GameScene.swift
//  FlappyChevis
//
//  Created by Piera Marchesini on 10/08/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var chevisNode : SKSpriteNode?
    
    static let MASK_CANOCONTACT:UInt32 = 0x1 << 0
    static let MASK_CHEVISCONTACT:UInt32 = 0x1 << 1
    
    var isAlive = true
    
    
    override func didMove(to view: SKView) {
        
        //Set background
//        let backgroundNode = SKSpriteNode(texture: SKTexture(imageNamed: "background"), color: .white, size: self.size)
//        backgroundNode.position = CGPoint(x: backgroundNode.size.width/2, y: backgroundNode.size.height/2)
//        self.addChild(backgroundNode)
        
        self.physicsWorld.contactDelegate = self
        
        chevisNode = SKSpriteNode(texture: SKTexture(imageNamed: "chevis1"), color: .red, size: CGSize(width: self.size.width*0.1, height: self.size.width*0.1))
        chevisNode?.position = CGPoint(x: self.size.width*0.30, y: self.size.height*0.5)
        self.addChild(chevisNode!)
        
        chevisNode?.physicsBody = SKPhysicsBody(rectangleOf: (chevisNode?.size)!)
        chevisNode?.physicsBody?.affectedByGravity = false
        chevisNode?.physicsBody?.categoryBitMask = GameScene.MASK_CHEVISCONTACT
        chevisNode?.physicsBody?.contactTestBitMask = GameScene.MASK_CANOCONTACT
        isAlive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAlive {
            chevisNode?.physicsBody?.affectedByGravity = true
            
            chevisNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            chevisNode?.physicsBody?.applyForce(CGVector(dx: 0, dy: 2517))
            
            chevisNode?.run(SKAction.animate(with: [SKTexture(imageNamed: "chevis1"), SKTexture(imageNamed: "chevis2"), SKTexture(imageNamed: "chevis1")], timePerFrame: 0.5))
        }
        
    }
    
    func createCano(with height: CGFloat) {
        let opening = self.size.height*0.3
        let canoNode = SKSpriteNode(texture: SKTexture(imageNamed: "cano"), color: .white, size: CGSize(width: (chevisNode?.size.width)!*2, height: self.size.height))
        canoNode.physicsBody = SKPhysicsBody(rectangleOf: canoNode.size)
        canoNode.physicsBody?.affectedByGravity = false
        canoNode.physicsBody?.categoryBitMask = GameScene.MASK_CANOCONTACT
        canoNode.physicsBody?.contactTestBitMask = GameScene.MASK_CHEVISCONTACT
        let canoReverseNode = SKSpriteNode(texture: SKTexture(imageNamed: "cano"), color: .white, size: CGSize(width: (chevisNode?.size.width)!*2, height: self.size.height))
        canoReverseNode.zRotation = CGFloat.pi
        canoReverseNode.physicsBody = SKPhysicsBody(rectangleOf: canoNode.size)
        canoReverseNode.physicsBody?.affectedByGravity = false
        canoReverseNode.physicsBody?.categoryBitMask = GameScene.MASK_CANOCONTACT
        canoReverseNode.physicsBody?.contactTestBitMask = GameScene.MASK_CHEVISCONTACT
        
        let superNode = SKNode()
        
        superNode.addChild(canoNode)
        superNode.addChild(canoReverseNode)
        
        canoNode.position = CGPoint(x: 0, y: -canoNode.size.height/2-opening/2)
        canoReverseNode.position = CGPoint(x: 0, y: canoReverseNode.size.height/2+opening/2)
        
        self.addChild(superNode)
        superNode.position = CGPoint(x: self.size.width+canoNode.size.width, y: height)
        
        superNode.run(SKAction.sequence([SKAction.move(by: CGVector(dx: -self.size.width*2, dy: 0), duration: 5), SKAction.run {
            superNode.removeFromParent()
            }]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        chevisNode?.physicsBody?.applyForce(CGVector(dx: 0, dy: -100))
        isAlive = false
        print("Contatou")
        
    }
    
    var previousTime: Double = 0
    let timerCano = 2.5
    var currentTimeCano = 2.5
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        let deltaTime = currentTime - previousTime
        currentTimeCano -= deltaTime
        if currentTimeCano <= 0 {
            createCano(with: CGFloat(arc4random_uniform(UInt32(self.size.height))))
            currentTimeCano = timerCano
        }
        
        previousTime = currentTime
    }
}
