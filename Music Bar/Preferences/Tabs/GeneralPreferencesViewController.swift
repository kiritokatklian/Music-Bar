//
//  GeneralPreferencesViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 29/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit
import LoginServiceKit

class GeneralPreferencesViewController: PreferencesViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var launchAppAtLoginButton: NSButton!
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		launchAppAtLoginButton.state = (UserPreferences.startAppAtLogin ? .on : .off)
	}
	
	// MARK: - IBActions
	@IBAction func launchAppAtLoginchanged(_ sender: Any) {
		if launchAppAtLoginButton.state == .on {
			UserPreferences.startAppAtLogin = true
			LoginServiceKit.addLoginItems()
		}
		else {
			UserPreferences.startAppAtLogin = false
			LoginServiceKit.removeLoginItems()
		}
	}
	
	
}
