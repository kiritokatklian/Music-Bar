//
//  AppDelegate.swift
//  Music Bar
//
//  Created by Musa Semou on 24/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    static var preferencesWindow: PreferencesWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.statusItem.button?.title = "Music Bar"
        AppDelegate.statusItem.button?.target = self
        AppDelegate.statusItem.button?.action = #selector(statusItemClicked)
        AppDelegate.statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        MusicAppObserver.shared.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        MusicAppObserver.shared.stop()
    }

    @objc func statusItemClicked() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("VC not found")
        }
        
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: AppDelegate.statusItem.button!.bounds, of: AppDelegate.statusItem.button!, preferredEdge: .maxY)    }
}

