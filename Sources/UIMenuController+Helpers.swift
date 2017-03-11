//
//  UIMenuController+Helpers.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UIMenuController {
    static func presentMenuController(_ forView: UIView, inView: UIView, menuItem: [UIMenuItem]?) {
        let rect = forView.convert(forView.bounds, to: inView)
        UIMenuController.shared.setTargetRect(rect, in: inView)
        UIMenuController.shared.menuItems = menuItem
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    static func dismissMenuController() {
        if UIMenuController.shared.isMenuVisible {
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }
    }
}
