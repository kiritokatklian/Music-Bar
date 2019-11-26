//
//  Data+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 26/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension Data {
    /// UTF-8 decodes the data to a string.
    var stringValue: String {
        var encodedString = String(data: self, encoding: .utf8) ?? ""
        
        encodedString = encodedString.replacingOccurrences(of: "\0", with: "")
        
        return encodedString
    }
}
