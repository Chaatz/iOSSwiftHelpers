//
//  UIResponderExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 12/28/16.
//  Copyright © 2016 Chaatz. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    
    fileprivate weak static var _currentFirstResponder: UIResponder? = nil
    
    public class func currentFirstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(
            #selector(UIResponder.findFirstResponder(_:)),
            to: nil,
            from: nil,
            for: nil)
        return UIResponder._currentFirstResponder
    }
    
    internal func findFirstResponder(_ sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
    
}
