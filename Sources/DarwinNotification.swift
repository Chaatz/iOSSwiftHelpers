//
//  DarwinNotification.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/16/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import Foundation

// MARK: - Darwin Notifications Setup
public func registerForDarwinNotifications(notificationName: CFNotificationName) {
    /*
    func CFNotificationCenterAddObserver(_ center: CFNotificationCenter!,
                                         _ observer: UnsafeRawPointer!,
                                         _ callBack: CoreFoundation.CFNotificationCallback!,
                                         _ name: CFString!,
                                         _ object: UnsafeRawPointer!,
                                         _ suspensionBehavior: CFNotificationSuspensionBehavior)
    */
    // CFNotificationCallback: (CFNotificationCenter?, UnsafeMutableRawPointer?, CFNotificationName?, UnsafeRawPointer?, CFDictionary?)
    
    let callback: CFNotificationCallback = { center, observer, name, object, userInfo in
        
        guard let notificationName = name else { return }
        //debug_print("darwin callback")
        //debug_print("darwin notification name: \(notificationName)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName.notificationString()),
                                            object: nil,
                                            userInfo: nil)
        }
    }
    let notificationCallback: CFNotificationCallback = callback
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    nil,
                                    notificationCallback,
                                    notificationName.rawValue,
                                    nil,
                                    CFNotificationSuspensionBehavior.deliverImmediately)
}

public func unregisterForDarwinNotifications(notificationName: CFNotificationName) {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                       nil,
                                       notificationName,
                                       nil)
}

public func sendDarwinNotification(notificationName: CFNotificationName) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                         notificationName,
                                         nil,
                                         nil,
                                         true)
}


