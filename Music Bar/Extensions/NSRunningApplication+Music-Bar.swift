//
//  NSRunningApplication+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NSRunningApplication {
    /**
                Retrieves a running application by its bundle ID.
     */
    static func get(withBundleIdentifier bundleId: String) -> NSRunningApplication? {
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
        
        if apps.count >= 1 {
            return apps[0]
        }
        
        return nil
    }
}

extension NSRunningApplication {
    /// Whether or not the application is currently running.
    var isRunning: Bool {
        return !self.isTerminated
    }
}
