//
//  StringExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/10/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

extension String {
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func nsRange(fromRange range: Range<Index>) -> NSRange {
        let from = range.lowerBound
        let to = range.upperBound
        
        let location = characters.distance(from: startIndex, to: from)
        let length = characters.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    
    func canComicFont() -> Bool {
        for character in characters {
            if character.unicodeScalarCodePoint() > 256 {
                return false
            }
            if character == "\n" {
                return false
            }
        }
        return true
    }
    
    func containsOnlyEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9,// Special Characters
            0x1D000...0x1F77F,          // Emoticons
            0x2100...0x27BF,            // Misc symbols and Dingbats
            0xFE00...0xFE0F,            // Variation Selectors
            0x1F900...0x1F9FF:          // Supplemental Symbols and Pictographs
                break
            default:
                return false
            }
        }
        return true
    }
    
    func isURLString() -> Bool {
        guard let _ = URL(string: self) else { return false }
        //if !UIApplication.sharedApplication().canOpenURL(url) { return false }
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self.lowercased())
    }
}
