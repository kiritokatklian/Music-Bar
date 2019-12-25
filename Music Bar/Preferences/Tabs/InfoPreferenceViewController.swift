//
//  InfoPreferenceViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa
import Sparkle

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
			let versionString = NSLocalizedString("info_version", comment: "Version number")
			versionTextField.stringValue = versionString.replacingOccurrences(of: "{v}", with: version)
			
			#if DEBUG
			versionTextField.stringValue += " debug"
			#endif
		}
	}
	
	// MARK: - IBActions
	@IBAction func quitButtonPressed(_ sender: Any) {
		quitApplicationButton.title = NSLocalizedString("goodbye_wave", comment: "")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			NSApp.terminate(self)
		}
	}
	
	@IBAction func checkUpdatesButtonPressed(_ sender: Any) {
		SUUpdater.shared()?.checkForUpdates(self)
	}
}
