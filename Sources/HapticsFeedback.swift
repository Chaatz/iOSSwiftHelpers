//
//  HapticsFeedback.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/16/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

final class HapticsFeedback {
    
    class func generatedImpactFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
}
