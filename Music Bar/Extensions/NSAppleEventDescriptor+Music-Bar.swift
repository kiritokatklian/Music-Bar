//
//  NSAppleEventDescriptor+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension NSAppleEventDescriptor {
    // Returns a dictionary of all the items in the Event Descriptor
    func listItems() -> [Int: String] {
        guard numberOfItems > 0 else {
            return [:]
        }

        var items = [Int: String]()

        for i in 1...numberOfItems {
            items[i] = atIndex(i)?.stringValue ?? ""
        }

        return items
    }
}

extension NSAppleEventDescriptor {
    var cleanDescription: String {
        let preparedString = self.description
            .replacingOccurrences(of: "<NSAppleEventDescriptor: ", with: "")
            .replacingOccurrences(of: ">", with: "")
        
        return preparedString
    }
}
