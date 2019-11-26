//
//  MusicAppObserver.swift
//  Music Bar
//
//  Created by Musa Semou on 25/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

class MusicAppObserver {
    static let shared = MusicAppObserver()
    
    private init() {}
    
    var timer: Timer?
    
    func start() {
        if timer != nil {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            MusicApp.shared.updateData()
        })
    }
    
    func stop() {
        if let timer = timer {
            timer.invalidate()
        }
    }
}
