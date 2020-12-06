//
//  NSStatusBarButton+Music-Bar.swift
//  Music Bar
//
//  Created by Khoren Katklian on 06/12/2020.
//  Copyright © 2020 Musa Semou. All rights reserved.
//

import AppKit

extension NSStatusBarButton {
	// MARK: - Properties
	/// The original title of the button.
	static private var _originalTitle: [String: String] = [String: String]()
	/// The timer object of the scrollable title.
	static private var _scrollTimer: [String: Timer] = [String: Timer]()
	/// Indicates whether the title is scrollable.
	static private var _titleIsScrollable: [String: Bool] = [String: Bool]()

	/// The original title of the button.
	private var originalTitle: String {
		get {
			return NSStatusBarButton._originalTitle[self.description] ?? self.title
		}
		set {
			NSStatusBarButton._originalTitle[self.description] = newValue
		}
	}
	/// The timer object of the scrollable title.
	private var scrollTimer: Timer? {
		get {
			return NSStatusBarButton._scrollTimer[self.description]
		}
		set {
			NSStatusBarButton._scrollTimer[self.description] = newValue
		}
	}
	/// Indicates whether the title is scrollable.
	var titleIsScrollable: Bool {
		get {
			return NSStatusBarButton._titleIsScrollable[self.description] ?? false
		}
		set {
			NSStatusBarButton._titleIsScrollable[self.description] = newValue
		}
	}

	// MARK: - Functions
	/**
		Configures the title for scrolling.

		This method sets `titleIsScrollable` to `true` and adds a region for tracking mouse and cursor events to enable/disable the scrolling effect.
	*/
	func configureScrollableTitleOnHover() {
		self.titleIsScrollable = true
		self.originalTitle = self.title

		let trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		self.addTrackingArea(trackingArea)
	}

	/// Invalidates and removes the scroll timer.
	private func clearScrollTimer() {
		self.scrollTimer?.invalidate()
		self.scrollTimer = nil
	}

	open override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)

		// If title is empty then avoid the scrolling behavior, otherwise the title will show the heavy horizontal line only.
		if !self.title.isEmpty && self.titleIsScrollable {
			self.title = self.originalTitle
			self.title += " ━ " // Separator to deffrentiate the end of the title from the start
			self.clearScrollTimer() // Extra insurance to avoide timers from stacking
			self.scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { timer in
				self.title.cycleAround() // Cycle title from right to left
			})
		}
	}

	open override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)

		self.clearScrollTimer() // Always remove in case the title needs to be empty
		if !self.title.isEmpty && self.titleIsScrollable {
			self.title = self.originalTitle // Reset title
		}
	}
}
