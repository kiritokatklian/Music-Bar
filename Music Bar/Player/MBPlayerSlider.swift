//
//  MBPlayerSlider.swift
//  Music Bar
//
//  Created by Musa Semou on 13/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//
//  Special thanks to @muhammedbassio
//  .. used as a reference:
//  https://github.com/muhammadbassio/MABSlider
//

import AppKit

class MBPlayerSliderCell: NSSliderCell {
	// MARK: - Properties
	/// Returns the color that should be used for the "filled" portion of the slider.
	fileprivate var filledBarColor: NSColor {
		if let artworkColor = MusicApp.shared.artworkColor {
			return artworkColor
		}

		return NSColor.controlAccentColor
	}

	/// Returns the color that should be used for the "empty" portion of the slider.
	fileprivate var emptyBarColor: NSColor {
		return filledBarColor.shadow(withLevel: 0.5) ?? .lightGray
	}

	// MARK: - Functions
	override func drawBar(inside aRect: NSRect, flipped: Bool) {
		super.drawBar(inside: aRect, flipped: flipped)

		// Rounded bar radius
		let barRadius: CGFloat = aRect.height / 2

		// Knob position depending on control min/max value and current control value.
		let value: CGFloat = CGFloat((self.doubleValue  - self.minValue) / (self.maxValue - self.minValue))

		// Before knob rect width
		let finalWidth: CGFloat = value * ((self.controlView?.frame.size.width)! - 8)

		// Before knob rect
		var beforeKnobRect: NSRect = aRect
		beforeKnobRect.size.width = finalWidth

		// Draw before knob
		let beforeKnobBezierPath: NSBezierPath = NSBezierPath(roundedRect: aRect, xRadius: barRadius, yRadius: barRadius)
		emptyBarColor.setFill()
		beforeKnobBezierPath.fill()

		// Draw after knob
		let afterKnobBezierPath: NSBezierPath = NSBezierPath(roundedRect: beforeKnobRect, xRadius: barRadius, yRadius: barRadius)
		filledBarColor.setFill()
		afterKnobBezierPath.fill()
	}
}
