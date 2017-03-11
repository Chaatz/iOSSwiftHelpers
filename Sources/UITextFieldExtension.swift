//
//  UITextFieldExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UITextField {
    
    func truncate(_ maxLength: Int) -> Int {
        
        guard let text = self.text else {
            return 0
        }
        
        if text.hasPrefix(" ") || text.hasPrefix("\n") {
            self.text = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        guard let trimmedText = self.text else {
            return 0
        }
        
        var markedTextLength = 0
        
        if let markedTextRange = markedTextRange {
            markedTextLength = offset(from: markedTextRange.start, to: markedTextRange.end)
        }
        
        var count = 0
        for character in trimmedText.characters {
            // Skip Emoji Modifier Fitzpatrick Type 1-6
            if (character.unicodeScalarCodePoint() >= 127995 && character.unicodeScalarCodePoint() <= 127999) {
                continue
            }
            // Workaround for flags
            let characterString = String(character)
            let strEndIndex = "\(characterString.endIndex)"
            if let charCount = Int(strEndIndex), charCount >= 4 {
                let flagCount = charCount / 4
                count += flagCount
            } else {
                count += 1
            }
        }
        
        let length = count - markedTextLength
        
        if length > maxLength {
            var finalText = ""
            count = 0
            for character in trimmedText.characters {
                let characterString = String(character)
                
                // Skip Emoji Modifier Fitzpatrick Type 1-6
                if (character.unicodeScalarCodePoint() >= 127995 && character.unicodeScalarCodePoint() <= 127999) {
                    finalText += characterString
                    continue
                }
                
                if count >= maxLength {
                    break
                }
                
                finalText += characterString
                let strEndIndex = "\(characterString.endIndex)"
                if let charCount = Int(strEndIndex), charCount >= 4 {
                    let flagCount = charCount / 4
                    count += flagCount
                } else {
                    count += 1
                }
            }
            self.text = finalText
            return maxLength
        }
        else {
            return length
        }
    }
    
    func filterToLetters() -> Bool {
        
        guard let text = self.text else { return false }
        
        let nonAlphabetChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
        
        let filtered = String(text.characters.filter( { nonAlphabetChars.contains($0) } ))
        
        self.text = filtered
        return true
    }
}
