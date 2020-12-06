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
	@IBOutlet weak var showMenuBarIconButton: NSButton!
	
	@IBOutlet weak var artistAndTitleButton: NSButton!
	@IBOutlet weak var artistOnlyButton: NSButton!
	@IBOutlet weak var titleOnlyButton: NSButton!
	@IBOutlet weak var hideTrackButton: NSButton!

	@IBOutlet weak var noScrollingButton: NSButton!
	@IBOutlet weak var alwaysScrollingButton: NSButton!
	@IBOutlet weak var onHoverScrollingButton: NSButton!
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Select the correct artwork quality
		switch UserPreferences.artworkQuality {
		case .low:
			artworkQualityLowButton.state = .on
		case .normal:
			artworkQualityNormalButton.state = .on
		case .high:
			artworkQualityHighButton.state = .on
		}
		
		// Select the correct track formatting
		switch UserPreferences.trackFormatting {
		case .artistAndTitle:
			artistAndTitleButton.state = .on
		case .artistOnly:
			artistOnlyButton.state = .on
		case .titleOnly:
			titleOnlyButton.state = .on
		case .hidden:
			hideTrackButton.state = .on
		}

		// Select the correct scrolling behavior
		configureScrollingBehaviorButtons()
		
		// Update useGapButton to be correct state
		useGapButton.state = UserPreferences.showGap ? .on : .off
		
		// Update showMenuBarIconButton to be correct state
		showMenuBarIconButton.state = UserPreferences.showMenuBarIcon ? .on : .off
		
		// Update the preference availability on initialization
		updatePreferenceAvailability()
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
	
	@IBAction func showMenuBarIconButtonPressed(_ sender: Any) {
		UserPreferences.showMenuBarIcon = (showMenuBarIconButton.state == .on)
		
		updatePreferenceAvailability()
		MenuBarManager.shared.updateButton()
	}
	
	@IBAction func titleFormattingRadioChecked(_ sender: Any) {
		if let radio = sender as? NSButton {
			switch radio.tag {
				case 1:
					UserPreferences.trackFormatting = .artistOnly
				case 2:
					UserPreferences.trackFormatting = .titleOnly
				case 3:
					UserPreferences.trackFormatting = .hidden
				default:
					UserPreferences.trackFormatting = .artistAndTitle
			}
			
			updatePreferenceAvailability()
			MenuBarManager.shared.updateButton()
		}
	}

	@IBAction func titleScrollingRadioChecked(_ sender: Any) {
		if let radio = sender as? NSButton {
			switch radio.tag {
			case 1:
				UserPreferences.scrollingBehavior = .none
			case 2:
				UserPreferences.scrollingBehavior = .always
			case 3:
				UserPreferences.scrollingBehavior = .onHover
			default:
				UserPreferences.scrollingBehavior = .none
			}

			MenuBarManager.shared.updateButton()
		}
	}
	
	// MARK: - Functions
	// Updates the availability of preferences according to the current state
	func updatePreferenceAvailability() {
		// Ensure that in no case the track and icon can be hidden at the same time
		showMenuBarIconButton.isEnabled = !(UserPreferences.trackFormatting == .hidden)
		hideTrackButton.isEnabled = (UserPreferences.showMenuBarIcon)

		// Ensure that if track information is hidden, scrolling behavior is disabled.
		noScrollingButton.isEnabled = !(UserPreferences.trackFormatting == .hidden)
		alwaysScrollingButton.isEnabled = !(UserPreferences.trackFormatting == .hidden)
		onHoverScrollingButton.isEnabled = !(UserPreferences.trackFormatting == .hidden)

		if (UserPreferences.trackFormatting == .hidden) {
			noScrollingButton.state = .on
		} else {
			configureScrollingBehaviorButtons()
		}
	}

	/// Configures the scrolling behavior buttons according to the user's preferences.
	func configureScrollingBehaviorButtons() {
		// Select the correct scrolling behavior
		switch UserPreferences.scrollingBehavior {
		case .none:
			noScrollingButton.state = .on
		case .always:
			alwaysScrollingButton.state = .on
		case .onHover:
			onHoverScrollingButton.state = .on
		}
	}
}
