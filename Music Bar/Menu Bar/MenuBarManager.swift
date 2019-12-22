//
//  MenuBarManager.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class MenuBarManager {
	// MARK: - Properties
	static let shared = MenuBarManager()
	static let defaultButtonTitle = "Music Bar"
	
	var hiddenWindow: NSWindow = NSWindow()
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	var trackDataDidChangeObserver: NSObjectProtocol?
	
	// MARK: - Initializers
	private init() {}
	
	// MARK: - Functions
	func initializeManager() {
		// Initialize hidden window
		generateHiddenWindow()
		
		// Initialize status item button
		if let button = statusItem.button {
			button.title = MenuBarManager.defaultButtonTitle
			button.target = self
			button.action = #selector(statusItemClicked)
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
			button.imagePosition = .imageLeft
		}
		
		// Add TrackDataDidChange observer
		trackDataDidChangeObserver = NotificationCenter.observe(name: .TrackDataDidChange) {
			self.updateButton()
		}
	}
	
	func deinitializeManager() {
		// Remove TrackDataDidChange observer
		if let observer = trackDataDidChangeObserver {
			NotificationCenter.default.removeObserver(observer)
		}
	}
	
	// Updates the status item's button according to the current track
	func updateButton() {
		if let button = statusItem.button {
			if let track = MusicApp.shared.currentTrack {
				
				// Format the track accordingly
				switch UserPreferences.trackFormatting {
					case .artistOnly:
						button.title = track.artist
					case .titleOnly:
						button.title = track.name
					case .hidden:
						button.title = ""
					default:
						button.title = "\(track.artist) - \(track.name)"
				}
				
				// Display the menu bar icon if enabled
				if UserPreferences.showMenuBarIcon {
					button.image = #imageLiteral(resourceName: "Symbols/menu-bar-icon")
					
					// Add a 1-space padding to the title
					if button.title.count >= 1 {
						button.title = " \(button.title)"
					}
				}
				else {
					button.image = nil
				}
				
				return
			}
			
			button.title = MenuBarManager.defaultButtonTitle
		}
	}
	
	// Opens the popover when the status item is clicked
	@objc func statusItemClicked() {
		// Retrieve the VC
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		guard let vc = storyboard.instantiateController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
			fatalError("VC not found")
		}
		
		// Get the coordinates for the hidden window
		guard let button = statusItem.button else { return }
		
		let buttonRect = button.convert(statusItem.button!.bounds, to: nil)
		let screenRect = button.window!.convertToScreen(buttonRect)
		
		let posX = screenRect.origin.x + (screenRect.width / 2) - 10
		let posY = screenRect.origin.y
		
		hiddenWindow.setFrameOrigin(NSPoint(x: posX, y: posY))
		hiddenWindow.makeKeyAndOrderFront(self)
		
		// Create popover and set properties
		let popover = NSPopover()
		popover.contentViewController = vc
		popover.behavior = .transient
		
		// Show the popover
		popover.show(relativeTo: hiddenWindow.contentView!.frame, of: hiddenWindow.contentView!, preferredEdge: NSRectEdge.minY)
		
		// Set the app to be active
		// This is crucial in order to achieve the "unfocus" behavior when a user interacts with another application
		NSApp.activate(ignoringOtherApps: true)
	}
	
	// Generates the hidden window that the popover will be attached to
	func generateHiddenWindow() {
		let height = CGFloat(UserPreferences.showGap ? 5 : 1)
		
		hiddenWindow = NSWindow(contentRect: NSMakeRect(0, 0, 15, height), styleMask: .borderless, backing: .buffered, defer: false)
		hiddenWindow.backgroundColor = .red
		hiddenWindow.alphaValue = 0
	}
}
