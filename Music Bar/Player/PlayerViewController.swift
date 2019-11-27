//
//  ViewController.swift
//  Music Bar
//
//  Created by Musa Semou on 24/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa
import ScriptingBridge

class PlayerViewController: NSViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var albumImage: NSImageView!
	@IBOutlet weak var playPauseButton: NSButton!
	@IBOutlet weak var playbackSlider: NSSlider!
	@IBOutlet var controlsOverlay: NSView!
	@IBOutlet weak var currentPlayerPositionTextField: NSTextField!
	@IBOutlet weak var totalDurationTextField: NSTextField!
	
	// MARK: - Properties
	static let defaultAlbumCover: NSImage = NSImage(imageLiteralResourceName: "default-album-cover")
	var musicAppChangeObservers: [NSObjectProtocol] = []
	
	// MARK: - View
	override func viewWillAppear() {
		super.viewWillAppear()
		
		// Update initial view data
		if let track = MusicApp.shared.currentTrack {
			updateView(with: track)
		}
		
		updatePlayerStatus(playing: MusicApp.shared.isPlaying)
		updateAlbumImage(withImage: MusicApp.shared.artwork)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addMouseTrackingArea()
		addMusicAppChangeObservers()
	}
	
	override func viewDidDisappear() {
		removeMusicAppChangeObservers()
	}
	
	// MARK: - IBActions
	@IBAction func backButtonPressed(_ sender: Any) {
		MusicApp.shared.backTrack()
	}
	
	@IBAction func nextButtonPressed(_ sender: Any) {
		MusicApp.shared.nextTrack()
	}
	
	@IBAction func playbackSliderMoved(_ sender: Any) {
		let newTimestamp = playbackSlider.intValue
		
		MusicApp.shared.setPlayerPosition(Int(newTimestamp))
	}
	
	@IBAction func pausePlayButtonPressed(_ sender: Any) {
		MusicApp.shared.pausePlay()
	}
	
	@IBAction func openPreferencesButtonPressed(_ sender: Any) {
		// Instantiate the window, if not already done
		if AppDelegate.preferencesWindow == nil {
			let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
			AppDelegate.preferencesWindow = mainStoryboard.instantiateController(withIdentifier: "PreferencesWindowController") as? PreferencesWindowController
		}
		
		// Show the window
		if let window = AppDelegate.preferencesWindow {
			window.showWindow(self)
			window.window?.center()
		}
		
		// Focus on preferences window
		NSApp.activate(ignoringOtherApps: true)
	}
	
	// MARK: - Functions
	fileprivate func addMouseTrackingArea() {
		let trackingArea = NSTrackingArea(rect: self.view.accessibilityFrame(), options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		self.view.addTrackingArea(trackingArea)
	}
	
	fileprivate func addMusicAppChangeObservers() {
		// Add TrackDataDidChange observer
		musicAppChangeObservers.append(
			NotificationCenter.default.addObserver(forName: .TrackDataDidChange, object: nil, queue: .main) { _ in
				if let track = MusicApp.shared.currentTrack {
					self.updateView(with: track)
				}
			}
		)
		
		// Add PlayerStateDidChange observer
		musicAppChangeObservers.append(
			NotificationCenter.default.addObserver(forName: .PlayerStateDidChange, object: nil, queue: .main) { _ in
				self.updatePlayerStatus(playing: MusicApp.shared.isPlaying)
			}
		)
		
		// Add PlayerPositionDidChange observer
		musicAppChangeObservers.append(
			NotificationCenter.default.addObserver(forName: .PlayerPositionDidChange, object: nil, queue: .main) { _ in
				self.playbackSlider.intValue = Int32(MusicApp.shared.currentPlayerPosition)
				self.currentPlayerPositionTextField.stringValue = MusicApp.shared.currentPlayerPosition.durationString
			}
		)
		
		// Add PlayerPositionDidChange observer
		musicAppChangeObservers.append(
			NotificationCenter.default.addObserver(forName: .ArtworkDidChange, object: nil, queue: .main) { _ in
				self.updateAlbumImage(withImage: MusicApp.shared.artwork)
			}
		)
	}
	
	fileprivate func removeMusicAppChangeObservers() {
		for observer in musicAppChangeObservers {
			NotificationCenter.default.removeObserver(observer)
		}
	}
	
	override func mouseEntered(with event: NSEvent) {
		controlsOverlay.isHidden = false
	}
	
	override func mouseExited(with event: NSEvent) {
		controlsOverlay.isHidden = true
	}
	
	// Updates the view according to the information in the given track.
	func updateView(with track: Track) {
		totalDurationTextField.stringValue = track.duration.durationString
		playbackSlider.maxValue = Double(track.duration)
	}
	
	// Updates the album image with a new image
	func updateAlbumImage(withImage image: NSImage?) {
		if let artwork = image {
			self.albumImage.image = artwork
		}
		else {
			self.albumImage.image = PlayerViewController.defaultAlbumCover
		}
	}
	
	// Updates the player status according to whether or not music is playing.
	func updatePlayerStatus(playing: Bool) {
		if playing {
			playPauseButton.title = "􀊆"
		}
		else {
			playPauseButton.title = "􀊄"
		}
	}
}
