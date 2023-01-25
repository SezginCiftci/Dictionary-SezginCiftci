//
//  Optional+Extension.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 25.01.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self == "" || self == nil || self == " "
    }
}
