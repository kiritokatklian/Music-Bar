//
//  UserPreferences.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

class UserPreferences {
	// MARK: - Enums
	private enum Keys: String {
		case appearance
		case artworkQuality
		case startAppAtLogin
		case showGap
		case trackFormatting
		case showMenuBarIcon
	}
	
	enum AppearanceMode: String {
		case light, dark, auto
	}
	
	enum ArtworkQualityMode: String {
		case low, normal, high
	}
	
	enum TrackFormattingMode: String {
		case artistAndTitle, artistOnly, titleOnly, hidden
	}
	
	// MARK: - Class vars
	class var appearance: AppearanceMode {
        get {
			return self.AppearanceMode.init(rawValue:
				self.readString(fromKey: self.Keys.appearance.rawValue) ?? ""
			) ?? self.AppearanceMode.auto
        }
        set {
			self.write(value: newValue.rawValue, toKey: self.Keys.appearance.rawValue)
        }
    }
	
	class var artworkQuality: ArtworkQualityMode {
        get {
			return self.ArtworkQualityMode.init(rawValue:
				self.readString(fromKey: self.Keys.artworkQuality.rawValue) ?? ""
				) ?? self.ArtworkQualityMode.normal
        }
        set {
			self.write(value: newValue.rawValue, toKey: self.Keys.artworkQuality.rawValue)
        }
    }
	
	class var startAppAtLogin: Bool {
        get {
			return self.readBool(fromKey: self.Keys.startAppAtLogin.rawValue) ?? true
        }
        set {
			self.write(value: newValue, toKey: self.Keys.startAppAtLogin.rawValue)
        }
    }
	
	class var showGap: Bool {
        get {
			return self.readBool(fromKey: self.Keys.showGap.rawValue) ?? true
        }
        set {
			self.write(value: newValue, toKey: self.Keys.showGap.rawValue)
        }
    }
	
	class var trackFormatting: TrackFormattingMode {
        get {
			return self.TrackFormattingMode.init(rawValue:
				self.readString(fromKey: self.Keys.trackFormatting.rawValue) ?? ""
				) ?? self.TrackFormattingMode.artistAndTitle
        }
        set {
			self.write(value: newValue.rawValue, toKey: self.Keys.trackFormatting
				.rawValue)
        }
    }
	
	class var showMenuBarIcon: Bool {
        get {
			return self.readBool(fromKey: self.Keys.showMenuBarIcon.rawValue) ?? false
        }
        set {
			self.write(value: newValue, toKey: self.Keys.showMenuBarIcon.rawValue)
        }
    }
	
	// MARK: - Functions
	private static func write(value: Any?, toKey key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}
	
	private static func readString(fromKey key: String) -> String? {
		if !self.has(key: key) {
			return nil
		}
		
		return UserDefaults.standard.string(forKey: key)
	}
	
	private static func readBool(fromKey key: String) -> Bool? {
		if !self.has(key: key) {
			return nil
		}
		
		return UserDefaults.standard.bool(forKey: key)
	}
	
	private static func has(key: String) -> Bool {
		return UserDefaults.standard.object(forKey: key) != nil
	}
}
