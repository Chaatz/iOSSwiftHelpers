//
//  NSRange+ToRange.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import Foundation

extension NSRange {
    func toRange(_ string: String) -> Range<String.Index> {
        let startIndex = string.characters.index(string.startIndex, offsetBy: location)
        let endIndex = string.characters.index(startIndex, offsetBy: length)
        return startIndex..<endIndex
    }
}
