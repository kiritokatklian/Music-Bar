//
//  NotificationCenter+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 30/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NotificationCenter {
	static func post(name: NSNotification.Name) {
		NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
	}
	
	static func observe(name: NSNotification.Name, _ completionHandler: @escaping () -> Void) -> NSObjectProtocol {
		return NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { _ in
			completionHandler()
		}
	}
}
