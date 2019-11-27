//
//  NSAppleScript+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension NSAppleScript {
    static func run(code: String, completionHandler: (Bool, NSAppleEventDescriptor?, NSDictionary?) -> Void) {
        var error: NSDictionary?
        let script = NSAppleScript(source: code)
        let output = script?.executeAndReturnError(&error)
            
        if let ou = output {
            completionHandler(true, ou, nil)
        }
        else {
            completionHandler(false, nil, error)
        }
    }
}

extension NSAppleScript {
    enum snippets: String {
        case PausePlay = """
        tell application "Music"
            if it is running then
                playpause
            end if
        end tell
        """
        
        case GetCurrentPlayerState = """
        tell application "Music"
            if it is running then
                set playerstate to (get player state) as text
            end if
        end tell
        """
        
        case GetCurrentTrackProperties = """
        tell application "Music"
            if it is running then
                get properties of current track
            end if
        end tell
        """
        
        case GetCurrentPlayerPosition = """
        tell application "Music"
            if it is running then
                get player position
            end if
        end tell
        """
        
        static func SetCurrentPlayerPosition(_ position: Int) -> String {
            return """
            tell application "Music"
                if it is running then
                    set player position to \(position)
                    play
                end if
            end tell
            """
        }
        
        case BackTrack = """
        tell application "Music"
            if it is running then
                back track
            end if
        end tell
        """
        
        case NextTrack = """
        tell application "Music"
            if it is running then
                next track
            end if
        end tell
        """
        
        case GetCurrentArtwork = """
        tell application "Music"
            if it is running then
                get artwork 1 of current track
            end if
        end tell
        """
    }
}
