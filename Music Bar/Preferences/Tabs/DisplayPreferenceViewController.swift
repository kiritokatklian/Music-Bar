//
//  DisplayPreferenceViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class DisplayPreferenceViewController: PreferencesViewController {
	
	// MARK: - IBOutlets
	@IBOutlet weak var lightModeButton: NSButton!
	@IBOutlet weak var darkModeButton: NSButton!
	
	@IBOutlet weak var artworkQualityHighButton: NSButton!
	@IBOutlet weak var artworkQualityNormalButton: NSButton!
	@IBOutlet weak var artworkQualityLowButton: NSButton!
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Select the correct artwork quality
		switch(UserPreferences.artworkQuality) {
			case .low:
				artworkQualityLowButton.state = .on
			case .normal:
				artworkQualityNormalButton.state = .on
			case .high:
				artworkQualityHighButton.state = .on
		}
	}

	// MARK: - IBActions
	@IBAction func lightModeButtonPressed(_ sender: Any) {
		UserPreferences.appearance = .light
		NSApp.appearance = NSAppearance(named: .aqua)
	}
	
	@IBAction func darkModeButtonPressed(_ sender: Any) {
		UserPreferences.appearance = .dark
		NSApp.appearance = NSAppearance(named: .darkAqua)
	}
	
	@IBAction func artworkQualityRadioChecked(_ sender: Any) {
		if let radio = sender as? NSButton {
			switch radio.tag {
				case 1:
					UserPreferences.artworkQuality = .high
				case 2:
					UserPreferences.artworkQuality = .normal
				default:
					UserPreferences.artworkQuality = .low
			}
		}
	}
	
}