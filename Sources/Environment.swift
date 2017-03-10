//
//  Environment.swift
//  https://gist.github.com/mvarie/63455babc2d0480858da
//
//  ### Detects whether we're running in a Simulator, TestFlight Beta or App Store build ###
//
//  Based on https://github.com/bitstadium/HockeySDK-iOS/blob/develop/Classes/BITHockeyHelper.m
//  Inspired by http://stackoverflow.com/questions/18282326/how-can-i-detect-if-the-currently-running-app-was-installed-from-the-app-store
//  Created by marcantonio on 04/11/15.
//

import Foundation

class Environment {
    
    // MARK: Public
    
    static func isRunningInTestFlightEnvironment() -> Bool {
        if Environment.isSimulator() {
            return false
        } else {
            if Environment.isAppStoreReceiptSandbox() && !Environment.hasEmbeddedMobileProvision() {
                return true
            } else {
                return false
            }
        }
    }
    
    static func isRunningInAppStoreEnvironment() -> Bool {
        if Environment.isSimulator(){
            return false
        } else {
            if Environment.isAppStoreReceiptSandbox() || Environment.hasEmbeddedMobileProvision() {
                return false
            } else {
                return true
            }
        }
    }

    // MARK: Private

    private static func hasEmbeddedMobileProvision() -> Bool {
        if let _ = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") {
            return true
        }
        return false
    }
    
    private static func isAppStoreReceiptSandbox() -> Bool {
        if Environment.isSimulator() {
            return false
        } else {
            if let appStoreReceiptLastComponent = Bundle.main.appStoreReceiptURL?.lastPathComponent,
                appStoreReceiptLastComponent == "sandboxReceipt" {
                    return true
            }
            return false
        }
    }
    
    private static func isSimulator() -> Bool {
        #if arch(i386) || arch(x86_64)
            return true
            #else
            return false
        #endif
    }
    
}
