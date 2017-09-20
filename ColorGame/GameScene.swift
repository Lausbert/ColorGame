//
//  GameScene.swift
//  ColorGame
//
//  Created by Stephan Lerner on 11/09/2017.
//  Copyright © 2017 Stephan Lerner. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Collision Categories
    let playerCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    let targetCategory: UInt32 = 0x1 << 2
    
    // MARK: Nodes
    var player: SKSpriteNode?
    var target: SKSpriteNode?
    
    // MARK: Arrays
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    let trackVelocities = [180, 200, 250]
    var directionArray = [Bool]()
    var velocityArray = [Int]()
    
    // MARK: Rest
    
    var currentTrack = 0
    var movingToTrack = false
    let moveSound = SKAction.playSoundFileNamed("move.wav", waitForCompletion: false)
    
    // MARK: Entry Point
    
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
        createTarget()
        
        self.physicsWorld.contactDelegate = self
        
        if let numberOfTracks = tracksArray?.count {
            for _ in 0...numberOfTracks {
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                velocityArray.append(trackVelocities[randomNumberForVelocity])
                directionArray.append(GKRandomSource.sharedRandom().nextBool())
            }
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnEnemies()
            }, SKAction.wait(forDuration: 2)])))
    }
    
    // MARK: Touch Control
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            switch node?.name {
            case "right"?:
                moveToNextTrack()
            case "up"?:
                moveVertically(up: true)
            case "down"?:
                moveVertically(up: false)
            case .none:
                break
            case .some(_):
                break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !movingToTrack {
            player?.removeAllActions()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeAllActions()
    }
    
    // MARK: Contact Delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            print("Enemy hit")
        } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
            print("Target hit")
        }
    }
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
