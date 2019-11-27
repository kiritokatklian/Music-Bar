//
//  AppDelegate.swift
//  Music Bar
//
//  Created by Musa Semou on 24/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	static var preferencesWindow: PreferencesWindowController?
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		MusicAppObserver.shared.start()
		MenuBarManager.shared.initializeManager()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		MusicAppObserver.shared.stop()
	}
}

