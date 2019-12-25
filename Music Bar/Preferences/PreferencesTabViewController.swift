//
//  PreferencesTabViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 25/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class PreferencesTabViewController: NSTabViewController {
	@IBOutlet weak var infoTab: NSTabViewItem!
	@IBOutlet weak var generalTab: NSTabViewItem!
	@IBOutlet weak var displayTab: NSTabViewItem!
	@IBOutlet weak var supportTab: NSTabViewItem!
	
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		infoTab.label = NSLocalizedString("preference_tab_info", comment: "")
		generalTab.label = NSLocalizedString("preference_tab_general", comment: "")
		displayTab.label = NSLocalizedString("preference_tab_display", comment: "")
		supportTab.label = NSLocalizedString("preference_tab_support", comment: "")

	}
}
