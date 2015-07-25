//
//  GameManager.swift
//  boggle
//
//  Created by Bin Bo on 7/25/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import Foundation

class GameManager {
    
    static let instance = GameManager()
    
    var activeGame: BaseBoggleGame?
    
    func createSingleGame(dimen: Int) -> SingleBoggleGame {
        let game = SingleBoggleGame(dimen: dimen)
        activeGame = game
        return game
    }
    
    func createMultiGame(dimen: Int) -> MultiBoggleGame {
        let game = MultiBoggleGame(dimen: dimen)
        activeGame = game
        return game
    }
    
}
