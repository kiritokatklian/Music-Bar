//
//  NSSlider+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa

extension NSSlider {
	// Returns the value of the slider relative to another integer
	func valueRelative(to: Int) -> Int {
		return Int(Double(to) / Double(self.maxValue) * Double(self.intValue))
	}
}
