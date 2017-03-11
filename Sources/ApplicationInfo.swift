//
//  ApplicationInfo.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import Foundation

struct ApplicationInfo {
    static func applicationVersion() -> String? {
        if let dict = Bundle.main.infoDictionary {
            return dict["CFBundleShortVersionString"] as? String
        }
        return nil
    }
    
    static func applicationBuildVersion() -> Int? {
        if let dict = Bundle.main.infoDictionary, let version = dict["CFBundleVersion"] as? String {
            return Int(version)
        }
        return nil
    }
}
