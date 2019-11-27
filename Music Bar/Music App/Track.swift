//
//  Track.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

class Track: CustomStringConvertible, Equatable {
	// MARK: - Properties
    let name: String
    let artist: String
    let duration: Int
    
    // Formats the track artist and track name
    var displayText: String {
        return "\(artist) - \(name)"
    }
	
	// Search term to use with Apple API
	var searchTerm: String {
		return "\(name) \(artist)".URLSafeString
	}
    
    var description: String { return "\(artist) - \(name) [\(duration.durationString)]" }
    
	// MARK: - Initializers
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
	
	// MARK: - Functions
	/// Checks whether two tracks are the same song.
	static func == (lhs: Track, rhs: Track) -> Bool {
		return lhs.displayText == rhs.displayText
    }
}
