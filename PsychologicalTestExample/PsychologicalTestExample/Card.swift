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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    init(cardName: String) {
        let texture = SKTexture.init(imageNamed: cardName)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
}
