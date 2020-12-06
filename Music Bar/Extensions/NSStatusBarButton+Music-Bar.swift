//
//  NSStatusBarButton+Music-Bar.swift
//  Music Bar
//
//  Created by Khoren Katklian on 06/12/2020.
//  Copyright © 2020 Musa Semou. All rights reserved.
//

import AppKit

extension NSStatusBarButton {
	// MARK: - Enums
	/**
		List of available scrolling behavior types.
	*/
	enum ScrollingBehavior: Int {
		/// Indicates the text should not scroll.
		case none = 0
		/// Indicates the text always scrolls.
		case always
		/// Indicates the text scrolls only on hover.
		case onHover
	}
}

extension NSStatusBarButton {
	// MARK: - Properties
	/// The original title of the button.
	static private var _originalTitle: [String: String] = [String: String]()
	/// The timer object of the scrollable title.
	static private var _scrollTimer: [String: Timer] = [String: Timer]()
	/// Indicates whether the title is scrollable.
	static private var _titleIsScrollable: [String: Bool] = [String: Bool]()
	/// The tracking area for the mouse hover.
	static private var _trackingArea: [String: NSTrackingArea] = [String: NSTrackingArea]()

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
	/// The tracking area for the mouse hover.
	var trackingArea: NSTrackingArea? {
		get {
			return NSStatusBarButton._trackingArea[self.description]
		}
		set {
			NSStatusBarButton._trackingArea[self.description] = newValue
		}
	}

	// MARK: - Functions
	/**
		Configures the title for scrolling.

		This method sets `titleIsScrollable` to `true` and adds a region for tracking mouse and cursor events to enable/disable the scrolling effect.
	*/
	func configureScrollableTitle(_ scrollingBehavior: ScrollingBehavior) {
		self.titleIsScrollable = true
		self.originalTitle = self.title

		switch scrollingBehavior {
		case .none:
			self.stopScrolling(scrollingBehavior)
		case .always:
			self.stopScrolling(scrollingBehavior)
			self.startScrolling()
		case .onHover:
			self.stopScrolling(scrollingBehavior)
			configureHoverArea()
		}
	}

	/// Configures the hover area for the button.
	private func configureHoverArea() {
		if let trackingArea = self.trackingArea {
			self.removeTrackingArea(trackingArea)
		}
		self.trackingArea = NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		if let trackingArea = self.trackingArea {
			self.addTrackingArea(trackingArea)
		}
	}

	/// Starts the scrolling behavior.
	private func startScrolling() {
		// If title is empty then avoid the scrolling behavior, otherwise the title will show the heavy horizontal line only.
		if !self.title.isEmpty && self.titleIsScrollable {
			if self.originalTitle != self.title {
				 self.originalTitle = self.title
			}
			self.title += " ━ " // Separator to deffrentiate the end of the title from the start
			self.clearScrollTimer() // Extra insurance to avoide timers from stacking
			self.scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { timer in
				self.title.cycleAround() // Cycle title from right to left
			})
		}
	}

	/// Stops the scrolling behavior and resets the title.
	private func stopScrolling(_ scrollingBehavior: ScrollingBehavior) {
		switch scrollingBehavior {
		case .none, .always:
			if let trackingArea = self.trackingArea {
				self.removeTrackingArea(trackingArea)
			}
		case .onHover: break
		}
		self.clearScrollTimer() // Always remove in case the title needs to be empty
		if !self.title.isEmpty && self.titleIsScrollable {
			self.title = self.originalTitle // Reset title
		}
	}

	/// Invalidates and removes the scroll timer.
	private func clearScrollTimer() {
		self.scrollTimer?.invalidate()
		self.scrollTimer = nil
	}

	open override func mouseEntered(with event: NSEvent) {
		super.mouseEntered(with: event)
		self.startScrolling()
	}

	open override func mouseExited(with event: NSEvent) {
		super.mouseExited(with: event)
		self.stopScrolling(.onHover)
	}
}
