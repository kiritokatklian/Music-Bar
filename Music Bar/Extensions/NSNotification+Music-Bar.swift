//
//  NSNotification+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 26/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

extension NSNotification.Name {
    static var TrackDataDidChange: NSNotification.Name {
        return NSNotification.Name(#function)
    }
    
    static var PlayerStateDidChange: NSNotification.Name {
        return NSNotification.Name(#function)
    }
    
    static var PlayerPositionDidChange: NSNotification.Name {
        return NSNotification.Name(#function)
    }
}
