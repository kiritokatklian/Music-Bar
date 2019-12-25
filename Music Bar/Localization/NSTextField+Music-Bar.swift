//
//  NSTextField+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 25/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NSTextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
			stringValue = key!.localized
        }
    }
}
