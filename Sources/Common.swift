//
//  Common.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/10/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import Foundation
import UIKit

func debug_print(_ line: String) {
    if _isDebugAssertConfiguration() {
        print(line)
    }
}

func printTimeLog(_ log: AnyObject?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    print(formatter.string(from: Date()), terminator: "")
    if log == nil {
        print("nil")
    }
    else {
        print(log!)
    }
}

func pretty_function(_ file: String = #file, function: String = #function, line: Int = #line) {
    debug_print("file:\(file.debugDescription) function:\(function) line:\(line)")
}

// sync thread safe, equal to @sychronized(<T>)
func synchronized<T>(_ lock: AnyObject, closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    return try closure()
}

// Struct Wrapper for NSNotification
class StructWrapper<T> {
    var wrappedValue: T
    init(aStruct: T) {
        wrappedValue = aStruct
    }
}
