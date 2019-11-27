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
	enum Keys: String {
		case appearance
	}
	
	enum AppearanceMode: String {
		case light, dark, auto
	}
	
	// MARK: - Class vars
	class var appearance: AppearanceMode {
        get {
			return self.AppearanceMode.init(rawValue:
				UserDefaults.standard.string(forKey: self.Keys.appearance.rawValue) ?? ""
			) ?? self.AppearanceMode.auto
        }
        set {
			UserDefaults.standard.set(newValue.rawValue, forKey: self.Keys.appearance.rawValue)
        }
    }
}
