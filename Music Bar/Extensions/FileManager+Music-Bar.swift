//
//  FileManager+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 05/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension FileManager {
	// MARK: - Enums
	enum LocalLocation {
		/// Equivalent to "~/Downloads"
		case downloadsFolder
		
		/// Equivalent to the app's package folder
		case appPackageFolder
	}
	
	// Returns a URL based on the given Location
	static func getLocalFileURL(from location: LocalLocation, withFilename filename: String) -> URL {
		switch(location) {
			case .downloadsFolder:
				return URL(string: "\(FileManager.default.homeDirectoryForCurrentUser.absoluteString)/Downloads/\(filename)")!
			case .appPackageFolder:
				return URL(fileURLWithPath: filename)
		}
	}
}
