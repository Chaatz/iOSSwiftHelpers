//
//  CharacterExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 2/10/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

extension Character {
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
