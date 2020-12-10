//
//  FeedbackPreferenceViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 10/12/2020.
//  Copyright © 2020 Musa Semou. All rights reserved.
//

import AppKit

class FeedbackPreferenceViewController: PreferencesViewController {
	// MARK: - Properties
	let gitHubRepoURL = URL(string: "https://github.com/musa11971/Music-Bar")!
	let twitterURL = URL(string: "https://twitter.com/musa11971")!
	
	// MARK: - IBActions
	@IBAction func gitHubButtonPressed(_ sender: Any) {
		NSWorkspace.shared.open(gitHubRepoURL)
	}
	
	@IBAction func twitterButtonPressed(_ sender: Any) {
		NSWorkspace.shared.open(twitterURL)
	}
	
}
