//
//  PreferencesViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 26/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation
import AppKit

class PreferencesViewController: NSViewController {
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set size
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Update window title
        self.parent?.view.window?.title = "\(self.title!) — Music Bar"
    }
}
