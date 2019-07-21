//
//  Card.swift
//  PsychologicalTestExample
//
//  Created by 박지수 on 05/06/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    var front: SKTexture
    var back: SKTexture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    init(cardName: String) {
        self.front = SKTexture(imageNamed: cardName)
        self.back = SKTexture(imageNamed: cardName+"_back")
        super.init(texture: self.front, color: UIColor.white, size: self.front.size())
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let liftUp = SKAction.scale(
            to: CardDisplayScene.cardScale * 1.2, duration: 0.2)
        run(liftUp)
        
        let rotateCCW = SKAction.rotate(
            toAngle: CGFloat(-M_1_PI / 10), duration: 0.1)
        let rotateCW = SKAction.rotate(
            toAngle: CGFloat(M_1_PI / 10), duration: 0.1)
        let rotate = SKAction.sequence([rotateCCW, rotateCW])
        let rotateRepeat = SKAction.repeatForever(rotate)
        run(rotateRepeat, withKey: "rotate")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dropDown = SKAction.scale(
            to: CardDisplayScene.cardScale, duration: 0.2)
        run(dropDown)
        
        removeAction(forKey: "rotate")
        let rotate = SKAction.rotate(toAngle: 0, duration: 0)
        run(rotate)
        
        self.texture = self.back
        
        let fold = SKAction.scaleX(to: 0.0, duration: 0.4)
        let unfold = SKAction.scaleX(to: CardDisplayScene.cardScale, duration: 0.4)
        
        run(fold, completion: {
            self.texture = self.back
            self.run(unfold) 
        })
    }
}
