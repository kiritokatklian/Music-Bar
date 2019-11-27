//
//  NSAlert+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NSAlert {
	/// Shows the alerts as a sheet modal in the given window.
	func show(in window: NSWindow) {
		beginSheetModal(for: window) { _ in
			// ...
		}
	}
}
