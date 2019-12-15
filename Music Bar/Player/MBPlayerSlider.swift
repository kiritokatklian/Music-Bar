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
	fileprivate var isFlipped: Bool = false
	fileprivate var currentKnobRect: NSRect = NSRect()
	fileprivate var currentBarRect: NSRect = NSRect()
	
	/// Returns the color that should be used for the "filled" portion of the slider.
	fileprivate var filledBarColor: NSColor {
		if let artworkColor = MusicApp.shared.artworkColor {
			return artworkColor
		}
		
		return NSColor.controlAccentColor
	}
	
	/// Returns the color that should be used for the "empty" portion of the slider.
	fileprivate var emptyBarColor: NSColor {
		return filledBarColor.shadow(withLevel: 0.5)!
	}
	
	/// Returns the NSRect that is displayed before the slider knob.
	fileprivate var beforeKnobRect: NSRect {
		var beforeBar = currentBarRect
		beforeBar.size.width = currentKnobRect.origin.x
		
		// Fill the bar with the correct color
		filledBarColor.setFill()
		beforeBar.fill()
		
		return beforeBar
	}
	
	/// Returns the NSRect that is displayed after the slider knob.
	fileprivate var afterKnobRect: NSRect {
		var afterBar = currentKnobRect
		
		// Determine the offset for the x-origin
		let xOffset = currentKnobRect.size.width - 3
		
		// Set the width and height of the bar
		afterBar.size.width = (currentBarRect.size.width - afterBar.origin.x)
		afterBar.size.height = currentBarRect.size.height
		
		afterBar.origin.x += xOffset
		afterBar.origin.y = currentBarRect.origin.y
		
		// Fill the bar with the correct color
		emptyBarColor.setFill()
		afterBar.fill()
		
		return afterBar
	}
	
	// MARK: - Functions
	override func drawBar(inside aRect: NSRect, flipped: Bool) {
		// Assign the full rect so that it can be used in the computed properties
		currentBarRect = aRect
		isFlipped = flipped
		
		// Draw before knob rect only if the slider value is not the minimum value
		// We need to check for this, otherwise a small part of the rect may be visible next to the knob
		if(self.minValue != self.doubleValue) {
			NSDrawThreePartImage(beforeKnobRect, NSImage(), NSImage(), NSImage(), false, NSCompositingOperation.sourceOver, 1.0, flipped)
		}
		
		// Draw after knob rect only if the slider value is not the maximum value
		// Same reason as above
		if(self.maxValue != self.doubleValue) {
			NSDrawThreePartImage(afterKnobRect, NSImage(), NSImage(), NSImage(), false, NSCompositingOperation.sourceOver, 1.0, flipped)
		}
	}
	
	override func drawKnob(_ knobRect: NSRect) {
        super.drawKnob(knobRect)
		
        currentKnobRect = knobRect;
        drawBar(inside: currentBarRect, flipped: isFlipped)
    }
}
