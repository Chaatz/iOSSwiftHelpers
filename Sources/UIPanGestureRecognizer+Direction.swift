//
//  UIPanGestureRecognizer+Direction.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/9/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import Foundation
import UIKit

public enum Direction: Int {
    case up
    case down
    case left
    case right
    
    public var isX: Bool { return self == .left || self == .right }
    public var isY: Bool { return !isX }
}

public extension UIPanGestureRecognizer {
    
    public var direction: Direction? {
        let panVelocity = velocity(in: view)
        let vertical = fabs(panVelocity.y) > fabs(panVelocity.x)
        switch (vertical, panVelocity.x, panVelocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
}
