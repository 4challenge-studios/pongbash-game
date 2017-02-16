//
//  GoalDelegate.swift
//  pongball
//
//  Created by Vitor Muniz on 16/02/17.
//  Copyright © 2017 matheusmcardoso. All rights reserved.
//

import Foundation
protocol GoalDelegate {
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode)
}

extension GoalDelegate {
    func goal(_ goal: GoalNode, didReceiveBall ball: BallNode){}
}
