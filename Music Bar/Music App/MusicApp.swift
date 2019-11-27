//
//  MusicApp.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

class MusicApp {
    static let shared = MusicApp()
    
    var isPlaying: Bool = false
    var currentPlayerPosition: Int = 0
    var currentTrack: Track?
    
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
                currentTrack = Track(fromList: output!.listItems())
                AppDelegate.statusItem.button?.title = currentTrack!.displayText
                
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
        
        // Update artwork
        NSAppleScript.run(code: NSAppleScript.snippets.GetCurrentArtwork.rawValue) { (success, output, errors) in
            if success {
                print("artwork")
                print(output!.data)
            }
        }
    }
}
