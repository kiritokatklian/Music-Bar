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
	
	var isPlaying: Bool = false {
		didSet {
			if oldValue != isPlaying {
				NotificationCenter.post(name: .PlayerStateDidChange)
			}
		}
	}
	
    var currentPlayerPosition: Int = 0 {
		didSet {
			if oldValue != currentPlayerPosition {
				NotificationCenter.post(name: .PlayerPositionDidChange)
			}
		}
	}
	
	var currentTrack: Track? {
		didSet {
			// Check if the new track is different than the previous one
			if oldValue != currentTrack, let newTrack = currentTrack {
				// Update artwork when a new track is detected
				updateArtwork(forTrack: newTrack)
			}
			
			// Post notification
			NotificationCenter.post(name: .TrackDataDidChange)
		}
	}
	
	var artwork: NSImage? {
		didSet {
			NotificationCenter.post(name: .ArtworkDidChange)
			
			// Update average color
			if artwork == nil {
				artworkColor = nil
			}
			else {
				artworkColor = artwork?.averageColor
			}
		}
	}
	
	var artworkColor: NSColor?
	
	private var artworkAPITask: URLSessionTask?
	private var artworkDownloadTask: URLSessionTask?
    
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
                }
            }
            
            // Update current track
            NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentTrackProperties.rawValue) { (success, output, errors) in
                if success {
					// Get the new track
					let newTrack = Track(fromList: output!.listItems())
					
                    // Set the current track
					currentTrack = newTrack
                }
            }
            
            // Update player position
            NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentPlayerPosition.rawValue) { (success, output, errors) in
                if success {
                    var newPosition = Double(output!.cleanDescription) ?? 0
                    newPosition.round(.down)

                    self.currentPlayerPosition = Int(newPosition)
                }
            }
        }
    }
	
	// Retrieves the artwork of the current track from Apple
	fileprivate func updateArtwork(forTrack track: Track) {
		// Post ArtworkWillChange notification
		NotificationCenter.post(name: .ArtworkWillChange)
		
		// Reset artwork color
		self.artworkColor = nil
		
		// Destroy tasks, if any was already busy
		if let previousAPITask = artworkAPITask {
			previousAPITask.cancel()
		}
		
		if let previousDownloadTask = artworkDownloadTask {
			previousDownloadTask.cancel()
		}
		
		// Start fetching artwork
		artworkAPITask = URLSession.fetchJSON(fromURL: URL(string: "https://itunes.apple.com/search?term=\(track.searchTerm)&entity=song&limit=1")!) { (data, json, error) in
			if error != nil {
				print("Could not get artwork")
				return
			}

			if let json = json as? [String: Any] {
				if let results = json["results"] as? [[String: Any]] {
					if results.count >= 1, var imgURL = results[0]["artworkUrl100"] as? String {
						// Get the correct quality URL
						switch UserPreferences.artworkQuality {
							case .low:
								imgURL = imgURL.replacingOccurrences(of: "100x100", with: "200x200")
							case .normal:
								imgURL = imgURL.replacingOccurrences(of: "100x100", with: "300x300")
							case .high:
								imgURL = imgURL.replacingOccurrences(of: "100x100", with: "500x500")
						}
						
						// Create the URL
						let url = URL(string: imgURL)!
						
						// Download the artwork
						self.artworkDownloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
							
							if error != nil {
								self.artwork = nil
								return
							}

							DispatchQueue.main.async {
								// Set the artwork to the image
								self.artwork = NSImage(data: data!)
							}
						})
							
						self.artworkDownloadTask!.resume()
					}
					else {
						self.artwork = nil
					}
				}
			}
		}
		
		artworkAPITask!.resume()
	}
}
