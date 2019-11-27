//
//  MusicApp.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation
import AppKit

class MusicApp {
    static let shared = MusicApp()
    
    // MARK: - Properties
    var isRunning: Bool {
        if let app = NSRunningApplication.get(withBundleIdentifier: "com.apple.Music") {
            return app.isRunning
        }
        
        return false
    }
    var isPlaying: Bool = false
    var currentPlayerPosition: Int = 0
    var currentTrack: Track?
	var artwork: NSImage?
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Functions
    // Go to the previous track or the beginning of the current track
    func backTrack() {
        NSAppleScript.run(code: NSAppleScript.snippets.BackTrack.rawValue, completionHandler: {_,_,_ in })
    }
    
    // Go to the next track
    func nextTrack() {
        NSAppleScript.run(code: NSAppleScript.snippets.NextTrack.rawValue, completionHandler: {_,_,_ in })
    }

    // Pause or play the current track
    func pausePlay() {
        NSAppleScript.run(code: NSAppleScript.snippets.PausePlay.rawValue, completionHandler: {_,_,_ in })
    }
    
    // Set the player position to a timestamp (seconds)
    func setPlayerPosition(_ position: Int) {
        NSAppleScript.run(code: NSAppleScript.snippets.SetCurrentPlayerPosition(position), completionHandler: {_,_,_ in })
    }
    
    // Uses AppleScript to update data
    func updateData() {
        if isRunning {
            // Update player status
            NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentPlayerState.rawValue) { (success, output, errors) in
                if success {
                    self.isPlaying = (output!.data.stringValue == "playing")
                    
                    // Post notification
                    NotificationCenter.default.post(name: .PlayerStateDidChange, object: nil, userInfo: nil)
                }
            }
            
            // Update current track
            NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentTrackProperties.rawValue) { (success, output, errors) in
                if success {
					// Get the new track
					let newTrack = Track(fromList: output!.listItems())
					
					// Check if the new track is different than the previous one
					if newTrack != currentTrack, let newTrack = newTrack {
						// Update artwork when a new track is detected
						updateArtwork(forTrack: newTrack)
					}
					
                    // Set the current track
					currentTrack = newTrack
                    
                    // Post notification
                    NotificationCenter.default.post(name: .TrackDataDidChange, object: nil, userInfo: nil)
                }
            }
            
            // Update player position
            NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentPlayerPosition.rawValue) { (success, output, errors) in
                if success {
                    var newPosition = Double(output!.cleanDescription) ?? 0
                    newPosition.round(.down)

                    self.currentPlayerPosition = Int(newPosition)

                    // Post notification
                    NotificationCenter.default.post(name: .PlayerPositionDidChange, object: nil, userInfo: nil)
                }
            }
        }
    }
	
	// Retrieves the artwork of the current track from Apple
	fileprivate func updateArtwork(forTrack track: Track) {
		let task = URLSession.fetchJSON(fromURL: URL(string: "https://itunes.apple.com/search?term=\(track.searchTerm)&entity=song&limit=1")!) { (data, json, error) in
			if error != nil {
				print("Could not get artwork")
				return
			}

			if let json = json as? [String: Any] {
				if let results = json["results"] as? [[String: Any]] {
					if results.count >= 1, let imgURL = results[0]["artworkUrl100"] as? String {
						self.artwork = NSImage(byReferencing: URL(string: imgURL.replacingOccurrences(of: "100x100", with: "500x500"))!)
					}
					else {
						self.artwork = nil
					}
					
					NotificationCenter.default.post(name: .ArtworkDidChange, object: nil, userInfo: nil)
				}
			}
		}
		
		task.resume()
	}
}
