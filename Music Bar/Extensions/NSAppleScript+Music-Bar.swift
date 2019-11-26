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
            playpause
        end tell
        """
        
        case GetCurrentPlayerState = """
        tell application "Music"
            set playerstate to (get player state) as text
        end tell
        """
        
        case GetCurrentTrackProperties = """
        tell application "Music"
            get properties of current track
        end tell
        """
        
        case GetCurrentPlayerPosition = """
        tell application "Music"
            get player position
        end tell
        """
        
        static func SetCurrentPlayerPosition(_ position: Int) -> String {
            return """
            tell application "Music"
                set player position to \(position)
                play
            end tell
            """
        }
        
        case BackTrack = """
        tell application "Music"
            back track
        end tell
        """
        
        case NextTrack = """
        tell application "Music"
            next track
        end tell
        """
    }
}
