//
//  GeneralPreferencesViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 29/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class GeneralPreferencesViewController: PreferencesViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var launchAppAtLoginButton: NSButton!
	
	// MARK: - IBActions
	@IBAction func launchAppAtLoginchanged(_ sender: Any) {
		print("State \(launchAppAtLoginButton.state)")
	}
	
	
}
