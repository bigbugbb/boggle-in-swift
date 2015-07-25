//
//  GameDelegate.swift
//  boggle
//
//  Created by Bin Bo on 7/25/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func gameDidPick(word: String, valid: Bool)
    func gameDidTick(time: Int)
}