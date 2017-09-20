//
//  GameFunctions.swift
//  ColorGame
//
//  Created by Stephan Lerner on 20/09/2017.
//  Copyright © 2017 Stephan Lerner. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func moveVertically (up: Bool) {
        if up {
            let moveAction = SKAction.moveBy(x: 0, y: 3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        } else {
            let moveAction = SKAction.moveBy(x: 0, y: -3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            player?.run(repeatAction)
        }
    }
    
    func moveToNextTrack() {
        player?.removeAllActions()
        guard let nextTrack = tracksArray?[currentTrack + 1].position else {return}
        movingToTrack = true
        
        if let player = self.player {
            let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y) , duration: 0.2)
            player.run(moveAction, completion: {
                self.movingToTrack = false
            })
            currentTrack += 1
            self.run(moveSound)
        }
    }
    
    func spawnEnemies () {
        for i in 1...7 {
            let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
            if let newEnemy = createEnemy(type: randomEnemyType, forTrack: i) {
                self.addChild(newEnemy)
            }
        }
        
        self.enumerateChildNodes(withName: "ENEMY") { (node: SKNode, nil) in
            if node.position.y < -150 || node.position.y > self.size.height + 150 {
                node.removeFromParent()
            }
        }
    }
}
