//
//  InfoPreferenceViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa

class InfoPreferenceViewController: PreferencesViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var quitApplicationButton: NSButton!
	@IBOutlet weak var checkUpdatesButton: NSButton!
	@IBOutlet weak var versionTextField: NSTextField!
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Load app version
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			versionTextField.stringValue = "Version \(version)"
		}
	}
	
	// MARK: - IBActions
	@IBAction func quitButtonPressed(_ sender: Any) {
		quitApplicationButton.title = "Goodbye 👋"
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			NSApp.terminate(self)
		}
	}
	
	@IBAction func checkUpdatesButtonPressed(_ sender: Any) {
		// Disable the button
		checkUpdatesButton.isEnabled = false
		
		// Save the original button title
		let previousTitle = checkUpdatesButton.title
		
		// Set the new title to indicate updates are being check
		checkUpdatesButton.title = "Checking..."
		
		// TODO: Implement update checking.
		// The  code below is temporary
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			// Restore title and enable button
			self.checkUpdatesButton.title = previousTitle
			self.checkUpdatesButton.isEnabled = true
			
			// Show alert
			let alert = NSAlert()
			alert.messageText = "Finished checking for updates"
			alert.informativeText = "You are up to date with the latest version of Music Bar!"
			alert.alertStyle = .informational
			alert.addButton(withTitle: "Close")
			alert.show(in: self.view.window!)
		}
	}
}
