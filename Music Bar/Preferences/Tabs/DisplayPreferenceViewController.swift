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
	@IBOutlet weak var artworkQualityHighButton: NSButton!
	@IBOutlet weak var artworkQualityNormalButton: NSButton!
	@IBOutlet weak var artworkQualityLowButton: NSButton!
	
	@IBOutlet weak var useGapButton: NSButton!
	
	@IBOutlet weak var artistAndTitleButton: NSButton!
	@IBOutlet weak var artistOnlyButton: NSButton!
	@IBOutlet weak var titleOnlyButton: NSButton!
	@IBOutlet weak var iconOnlyButton: NSButton!
	
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
		
		// Select the correct track formatting
		switch(UserPreferences.trackFormatting) {
			case .artistAndTitle:
				artistAndTitleButton.state = .on
			case .artistOnly:
				artistOnlyButton.state = .on
			case .titleOnly:
				titleOnlyButton.state = .on
			case .iconOnly:
				iconOnlyButton.state = .on
		}
		
		// Update useGapButton to be correct state
		useGapButton.state = UserPreferences.showGap ? .on : .off
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

	@IBAction func automaticDarkLightModeButtonPressed(_ sender: Any) {
		UserPreferences.appearance = .auto
		NSApp.appearance = nil
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
	
	@IBAction func useGapButtonPressed(_ sender: Any) {
		UserPreferences.showGap = (useGapButton.state == .on)
		
		MenuBarManager.shared.generateHiddenWindow()
	}
	
	@IBAction func titleFormattingRadioChecked(_ sender: Any) {
		if let radio = sender as? NSButton {
			switch radio.tag {
				case 1:
					UserPreferences.trackFormatting = .artistAndTitle
				case 2:
					UserPreferences.trackFormatting = .artistOnly
				case 4:
					UserPreferences.trackFormatting = .iconOnly
				default:
					UserPreferences.trackFormatting = .titleOnly
			}
			
			MenuBarManager.shared.updateButtonTitle()
		}
	}
	
}
