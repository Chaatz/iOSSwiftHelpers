//
//  NotificationCenter+OptionalRemove.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/10/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

extension NotificationCenter {
    func removeOptionalObserver(_ observer: AnyObject?) {
        if let obj = observer {
            NotificationCenter.default.removeObserver(obj)
        }
    }
}
