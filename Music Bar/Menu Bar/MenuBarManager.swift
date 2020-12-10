//
//  MenuBarManager.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class MenuBarManager: NSObject {
	// MARK: - Properties
	static let shared = MenuBarManager()
	
	var popover: NSPopover?
	var hiddenWindow: NSWindow = NSWindow()
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	var trackDataDidChangeObserver: NSObjectProtocol?
    var trackIsPlayingChangeObserver: NSObjectProtocol?
	var trackUserDefaultsChangeObserver: NSObjectProtocol?
	var currentScrollingBehavior: UserPreferences.ScrollingBehavior?
	var currentTrackFormatting: UserPreferences.TrackFormattingMode?
	var currentTrack: Track?
	
	// MARK: - Initializers
	private override init() {}
	
	// MARK: - Functions
	func initializeManager() {
		// Initialize hidden window
		generateHiddenWindow()
		
		// Initialize status item button
		if let button = statusItem.button {
			button.target = self
			button.action = #selector(statusItemClicked)
			button.sendAction(on: [.leftMouseUp, .rightMouseUp])
			button.imagePosition = .imageLeft
			
			// Update the button once to initialize
			updateButton()
		}
		
		// Add TrackDataDidChange observer
		trackDataDidChangeObserver = NotificationCenter.observe(name: .TrackDataDidChange) {
			self.updateButton()
		}
        
        // Add TrackIsPlayingChange observer
        trackIsPlayingChangeObserver = NotificationCenter.observe(name:
        .PlayerStateDidChange) {
            self.updateButton(true)
        }

		// Observe changes in UserPreferences
		UserDefaults.standard.addObserver(self, forKeyPath: UserPreferences.Keys.scrollingBehavior.rawValue, options: .new, context: nil)
		UserDefaults.standard.addObserver(self, forKeyPath: UserPreferences.Keys.trackFormatting.rawValue, options: .new, context: nil)
		UserDefaults.standard.addObserver(self, forKeyPath: UserPreferences.Keys.showMenuBarIcon.rawValue, options: .new, context: nil)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == UserPreferences.Keys.scrollingBehavior.rawValue ||
			keyPath == UserPreferences.Keys.trackFormatting.rawValue ||
			keyPath == UserPreferences.Keys.showMenuBarIcon.rawValue {
			updateButton(true)
		}
	}
	
	func deinitializeManager() {
		// Remove TrackDataDidChange observer
		if let observer = trackDataDidChangeObserver {
			NotificationCenter.default.removeObserver(observer)
		}
	}
	
	/**
		Updates the status item's button according to the current track.

		If music is paused it will return the default button. If an update is requested without a track change then the update is ignored.

		To force an update irregardless of whether the track changed, you may pass `true` as parameter.

		- Parameter forceUpdate: Forces the update irregardless of the track change.
	*/
	func updateButton(_ forceUpdate: Bool = false) {
		if let button = statusItem.button {
            if MusicApp.shared.isPlaying {
                if let track = MusicApp.shared.currentTrack {
					// Only reconfigure the button if the track changes
					if currentTrack?.name != track.name || forceUpdate {
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

						// Configure scrolling behavior if enabled
						if currentScrollingBehavior != UserPreferences.scrollingBehavior || currentTrack?.name != button.title {
							currentScrollingBehavior = UserPreferences.scrollingBehavior
							switch currentScrollingBehavior {
							case .none?:
								button.configureScrollableTitle(.none)
							case .always:
								button.configureScrollableTitle(.always)
							case .onHover:
								button.configureScrollableTitle(.onHover)
							default: break
							}
						}

						// Keep track of track changes
						currentTrack = track
					}
					return
                }
            }
			
			// Default button
			button.image = #imageLiteral(resourceName: "Symbols/menu-bar-icon")
			button.title = ""
		}
	}
	
	// Opens the popover when the status item is clicked
	@objc func statusItemClicked() {
		// Create the popover if not already created
		if popover == nil {
			popover = NSPopover()
			popover!.behavior = .transient
		}
		guard let popover = popover else { return }
		
		// Set the view controller
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		guard let vc = storyboard.instantiateController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
			fatalError("VC not found")
		}
		popover.contentViewController = vc
		
		if !popover.isShown {
			// Get the coordinates for the hidden window
			guard let button = statusItem.button else { return }
			
			let buttonRect = button.convert(statusItem.button!.bounds, to: nil)
			let screenRect = button.window!.convertToScreen(buttonRect)
			
			let posX = screenRect.origin.x + (screenRect.width / 2) - 10
			let posY = screenRect.origin.y
			
			hiddenWindow.setFrameOrigin(NSPoint(x: posX, y: posY))
			hiddenWindow.makeKeyAndOrderFront(self)
			
			// Show the popover
			popover.show(relativeTo: hiddenWindow.contentView!.frame, of: hiddenWindow.contentView!, preferredEdge: NSRectEdge.minY)
			
			// Set the app to be active
			// This is crucial in order to achieve the "unfocus" behavior when a user interacts with another application
			NSApp.activate(ignoringOtherApps: true)
		}
		else {
			popover.performClose(self)
		}
	}
	
	// Generates the hidden window that the popover will be attached to
	func generateHiddenWindow() {
		let height = CGFloat(UserPreferences.showGap ? 5 : 1)
		
		hiddenWindow = NSWindow(contentRect: NSMakeRect(0, 0, 15, height), styleMask: .borderless, backing: .buffered, defer: false)
		hiddenWindow.backgroundColor = .red
		hiddenWindow.alphaValue = 0
		hiddenWindow.collectionBehavior = .canJoinAllSpaces
		hiddenWindow.level = .floating
	}
}
