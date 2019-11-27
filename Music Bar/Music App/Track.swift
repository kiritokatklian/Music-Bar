//
//  Track.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

class Track: CustomStringConvertible {
    let name: String
    let artist: String
    let duration: Int
    
    // Formats the track artist and track name
    var displayText: String {
        return "\(artist) - \(name)"
    }
    
    var description: String { return "\(artist) - \(name) [\(duration.durationString)]" }
    
    init(name: String, artist: String, duration: Int) {
        self.name = name
        self.artist = artist
        self.duration = duration
    }
    
    // Initialize track from a list
    convenience init?(fromList list: [Int: String]) {
        if let durationData = list[8],
            let nameData = list[3],
            let artistData = list[9]
        {
            let duration = Int(Double(durationData) ?? 0)
            
            self.init(name: nameData, artist: artistData, duration: duration)
            return
        }
        
        return nil
    }
}
