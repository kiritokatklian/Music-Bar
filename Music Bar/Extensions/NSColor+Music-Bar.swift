//
//  NSColor+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 15/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NSColor {
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor

        // Convert to the RGB colorspace
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }

        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
