//
//  CardDisplayScene.swift
//  PsychologicalTestExample
//
//  Created by 박지수 on 05/06/2019.
//  Copyright © 2019 박지수. All rights reserved.
//

import SpriteKit

class CardDisplayScene: SKScene {
    static var cardScale: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        let width = self.view?.bounds.width
        
        let titleLabel = SKLabelNode(
            fontNamed: "AppleSDGothicNeo-Medium")
        titleLabel.name = "titleText"
        titleLabel.text = "당신의 애인을 볼 때 생각나는 것은?"
        titleLabel.fontSize = 30
        titleLabel.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.maxY-titleLabel.frame.height)
        self.addChild(titleLabel)
        
        let fireCard = Card(cardName: "fire")
        let waterCard = Card(cardName: "water")
        let riverCard = Card(cardName: "river")
        let mountainCard = Card(cardName: "mountain")
        
        CardDisplayScene.cardScale =
        0.2 * width! / fireCard.size.width
        
        fireCard.xScale = CardDisplayScene.cardScale
        fireCard.yScale = CardDisplayScene.cardScale
        waterCard.xScale = CardDisplayScene.cardScale
        waterCard.yScale = CardDisplayScene.cardScale
        riverCard.xScale = CardDisplayScene.cardScale
        riverCard.yScale = CardDisplayScene.cardScale
        mountainCard.xScale = CardDisplayScene.cardScale
        mountainCard.yScale = CardDisplayScene.cardScale
        
        let MidX = self.frame.midX
        let MidY = self.frame.midY
        fireCard.position = CGPoint(x: MidX / 4, y: MidY)
        waterCard.position = CGPoint(x: MidX * 3 / 4, y: MidY)
        riverCard.position = CGPoint(x: MidX * 5 / 4, y: MidY)
        mountainCard.position = CGPoint(x: MidX * 7 / 4, y: MidY)
        
        self.addChild(fireCard)
        self.addChild(waterCard)
        self.addChild(riverCard)
        self.addChild(mountainCard)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if let cardNode = atPoint(location) as? Card {
                let liftUp = SKAction.scale(
                    to: CardDisplayScene.cardScale * 1.3, duration: 0.2)
                cardNode.run(liftUp)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if let cardNode = atPoint(location) as? Card {
                let dropDown = SKAction.scale(
                    to: CardDisplayScene.cardScale, duration: 0.2)
                cardNode.run(dropDown)
            }
        }
    }
}
