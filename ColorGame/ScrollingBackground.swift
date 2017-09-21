//
//  ScrollingBackground.swift
//  ColorGame
//
//  Created by Stephan Lerner on 21/09/2017.
//  Copyright © 2017 Stephan Lerner. All rights reserved.
//

import SpriteKit

class ScrollingBackground: SKSpriteNode {
    
    var scrollingSpeed: CGFloat = 0
    
    static func scrollingNodeWithImage (imageName image: String, containerWidth width: CGFloat) -> ScrollingBackground {
        let backgroundImg = UIImage(named: image)!
        
        let scrollNode = ScrollingBackground(color: UIColor.clear, size: CGSize(width: width, height: backgroundImg.size.height))
        scrollNode.scrollingSpeed = 1
        
        var totalWidthNeeded: CGFloat = 0
        
        while totalWidthNeeded < width + backgroundImg.size.width {
            let child = SKSpriteNode(imageNamed: image)
            child.anchorPoint = CGPoint.zero
            child.position = CGPoint(x: totalWidthNeeded, y: 0)
            scrollNode.addChild(child)
            totalWidthNeeded += child.size.width
        }
        
        return scrollNode
    }
    
    func update (currentTime: TimeInterval) {
        for child in self.children {
            child.position = CGPoint(x: child.position.x - self.scrollingSpeed, y: child.position.y)
            
            if child.position.x <= -child.frame.size.width {
                let delta = child.position.x + child.frame.size.width
                child.position = CGPoint(x: child.frame.size.width * CGFloat(self.children.count - 1) + delta, y: child.position.y)
            }
        }
    }
}
