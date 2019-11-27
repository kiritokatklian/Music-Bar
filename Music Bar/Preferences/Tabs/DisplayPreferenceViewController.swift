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
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
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
}
