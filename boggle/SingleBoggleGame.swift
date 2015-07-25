//
//  SingleBoggleGame.swift
//  boggle
//
//  Created by Bin Bo on 7/25/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import Foundation

class SingleBoggleGame: BaseBoggleGame {
    
    var task: dispatch_cancelable_closure?
    
    init(dimen: Int) {
        super.init()
        self.dimen = dimen
    }
    
    override func start() {
        super.start()
    }
    
    override func resume() {
        super.resume()
        if !stopped {
            tick()
        }
    }
    
    override func pause() {
        super.pause()
        if !stopped {
            cancel_delay(task)
        }
    }
    
    override func stop() {
        super.stop()
    }
    
    func tick() {
        task = delay(1) {
            self.tick()
            self.delegate?.gameDidTick(--self.time)
        }
    }
}