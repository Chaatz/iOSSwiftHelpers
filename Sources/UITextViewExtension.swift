//
//  UITextViewExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UITextView {
    
    func switchOffTextContainerColorBlending() {
        for subview in subviews {
            subview.backgroundColor = backgroundColor
        }
    }
    
    func truncate(_ maxLength: Int) -> Int {
        
        if text.hasPrefix(" ") || text.hasPrefix("\n") {
            text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        var markedTextLength = 0
        
        if let markedTextRange = markedTextRange {
            markedTextLength = offset(from: markedTextRange.start, to: markedTextRange.end)
        }
        
        let length = text.characters.count - markedTextLength
        if length > maxLength {
            let index = text.index(text.startIndex, offsetBy: maxLength)
            text = text.substring(to: index)
            return text.characters.count
        }
        else {
            return length
        }
    }
}
