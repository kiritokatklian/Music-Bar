//
//  Int+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 26/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension Int {
    var durationString: String {
        var minutes = Double(self / 60)
        minutes.round(.down)
        let seconds = Double(self) - minutes * 60
        
        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
    }
}
