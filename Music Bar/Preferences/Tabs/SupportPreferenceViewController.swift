//
//  SupportPreferenceViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 22/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class SupportPreferenceViewController: PreferencesViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var musaButton: NSButton!
	
	// MARK: - Properties
	let donationURL = URL(string: "https://www.paypal.me/musa11971")!
	var kissing = false
	
	// MARK: - IBActions
	@IBAction func paypalButtonPressed(_ sender: Any) {
		NSWorkspace.shared.open(donationURL)
	}
	
	@IBAction func musaButtonPressed(_ sender: Any) {
		if kissing {
			return
		}
		
		kissing = true
		let previousImage = musaButton.image
		musaButton.image = NSImage(imageLiteralResourceName: "musa11971-memoji-kiss")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			if let image = previousImage {
				self.musaButton.image = image
			}
			
			self.kissing = false
		}
	}
}
