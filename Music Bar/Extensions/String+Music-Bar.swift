//
//  String+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension String {
	/**
		The list of available cycle directions.
	*/
	enum CycleDirection: Int {
		// MARK: - Cases
		/// Indicates that the cycle goes from right to left.
		case startToEnd = 0
		/// Indicates that the cycle goes from left to right.
		case endToStart
	}

	var URLSafeString: String {
		return self.replacingOccurrences(of: " ", with: "+")
			.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}

	/**
		Cycles the characters around in the string in the given direction.

		- Parameter direction: The direction in which to cycle the given string's characters. Default value is `startToEnd`.
	*/
	mutating func cycleAround(in direction: CycleDirection = .startToEnd) {
		switch direction {
		case .startToEnd:
			insert(removeFirst(), at: endIndex)
		case .endToStart:
			insert(removeLast(), at: startIndex)
		}
	}
}

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
