//
//  String+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension String {
	var URLSafeString: String {
		return self.replacingOccurrences(of: " ", with: "+")
			.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
}
