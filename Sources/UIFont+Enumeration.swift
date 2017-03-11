//
//  UIFont+Enumeration.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UIFont {
    static func enumerateFonts() {
        for fontFamily in UIFont.familyNames {
            print("Font family name = \(fontFamily as String)");
            
            for fontName in UIFont.fontNames(forFamilyName: fontFamily as String) {
                
                print("- Font name = \(fontName)");
                
            }
            
            print("\n");
        }
    }
}
