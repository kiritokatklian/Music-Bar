//
//  AppDelegate.swift
//  Music Bar
//
//  Created by Musa Semou on 24/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa
import LoginServiceKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	// MARK: - Properties
	static var preferencesWindow: PreferencesWindowController?
	
	// MARK: - Application
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// We run this method to ensure the application is added to startup items if necessary
		updateAppStartup()
		
		// Set dark/light mode accordingly
		switch UserPreferences.appearance {
			case .light:
				NSApp.appearance = NSAppearance(named: .aqua)
			case .dark:
				NSApp.appearance = NSAppearance(named: .darkAqua)
			default:
				break
		}
		
		// Start application services
		MusicAppObserver.shared.start()
		MenuBarManager.shared.initializeManager()
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		MusicAppObserver.shared.stop()
	}
	
	// MARK: - Functions
	private func updateAppStartup() {
		if UserPreferences.startAppAtLogin {
			if !LoginServiceKit.isExistLoginItems() {
				LoginServiceKit.addLoginItems()
			}
		}
	}
}

