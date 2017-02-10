//
//  SKNode+Extensions.swift
//  pongball
//
//  Created by Matheus Martins on 2/7/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    func texture() -> SKTexture? {
        return SKView().texture(from: self)
    }
    
    func texture(crop: CGRect) -> SKTexture? {
        return SKView().texture(from: self, crop: crop)
    }
}
