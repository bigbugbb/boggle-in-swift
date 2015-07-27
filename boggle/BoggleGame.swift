//
//  Game.swift
//  boggle
//
//  Created by Bin Bo on 7/21/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

/*
    the number of occurrence for each letter is below:
    a: 326395	8.1552% *
    b: 73910	1.84669%
    c: 169177	4.227%
    d: 129257	3.22957%
    e: 437303	10.9263% *
    f: 46188	1.15404%
    g: 98557	2.46251%
    h: 104164	2.60261%
    i: 355476	8.8818% *
    j: 6416		0.160308%
    k: 33829	0.84524%
    l: 215219	5.37739% *
    m: 119469	2.98501%
    n: 285562	7.13496% *
    o: 280921	7.019% *
    p: 127706	3.19082%
    q: 6784		0.169503%
    r: 280998	7.02092% *
    s: 326647	8.16149% *
    t: 262874	6.56808% *
    u: 146434	3.65875%
    v: 37786	0.944108%
    w: 27811	0.694876%
    x: 11837	0.295755%
    y: 74044	1.85004%
    z: 17531	0.438024%
    the sum of all occurrences is 4002295
*/

import Foundation

protocol GameProtocol {
    func start()
    func resume()
    func pause()
    func stop()
    func select(i: Int)
}

class BaseBoggleGame: GameProtocol {
    
    var board: [CChar]!
    var selections = [Int]()
    
    var dimen = 4
    var time  = 120
    var score = 0
    
    var stopped = true
    
    var foundWords = [String]()
    let dict = BoggleDictionary.instance
    
    var delegate: GameDelegate?
    
    let frequency = [
        326395, 73910, 169177, 129257, 437303, 46188, 98557, 104164, 355476, 6416, 33829, 215219, 119469,
        285562, 280921, 127706, 6784, 280998, 326647, 262874, 146434, 37786, 27811, 11837, 74044, 17531
    ]
    let sumOfChars = 4002295
    
    func start() {
        shuffle()
        time  = 120
        score = 0
        stopped = false
    }
    
    func resume() {
    }
    
    func pause() {        
    }
    
    func stop() {
        stopped = true
        selections.removeAll(keepCapacity: true)
        foundWords.removeAll(keepCapacity: true)
    }
    
    func shuffle() {
        func makeLetter() -> Int8 {
            var l = 0
            var r = 0
            let t = Int((Float(arc4random()) / Float(UINT32_MAX)) * Float(sumOfChars))
            
            for var i = 0; i < 26; ++i {
                r += frequency[i]
                if l < t && t < r {
                    return Int8(i)
                }
                l += frequency[i]
            }
            return 4 // add more probability on 'E'
        }
        
        board = [CChar](count: dimen * dimen, repeatedValue:65)
        for (index, value) in enumerate(board) {
            board[index] = value + makeLetter()
        }
    }
    
    func select(i: Int) {
        if contains(selections, i) {
            if count(selections) == 1 {
                selections.removeLast()
            } else {
                if selections.last == i {
                    // get all selected charaters and build them into a word,
                    // and try to look up the word in the dictionary.
                    // if the word is found, we are happy, otherwise play the error sound
                    let word = wordFromSelections().lowercaseString
                    if dict.contains(word) && !contains(foundWords, word) {
                        updateScoreForWord(word)
                        foundWords.append(word)
                        selections.removeAll(keepCapacity: true)
                        delegate?.gameDidPick(word, isValid: true)
                    } else {
                        delegate?.gameDidPick(word, isValid: false)
                    }
                } else {
                    // remove all selections after this one
                    while selections.last != i {
                        selections.removeLast()
                    }
                }
            }
        } else {
            if validateSelection(i) {
                selections.append(i)
            } else {
                if count(selections) == 1 {
                    selections.removeLast()
                    selections.append(i)
                }
            }
        }
        println(selections)
    }
   
    internal func wordFromSelections() -> String {
        var word = [CChar]()
        for sel in selections {
            word.append(board[sel])
        }
        return NSString(bytes: word, length: word.count, encoding: NSASCIIStringEncoding)! as String
    }
    
    internal func validateSelection(i: Int) -> Bool {
        if let last = selections.last {
            let x  = last % dimen
            let y  = last / dimen
            let sx = i % dimen
            let sy = i / dimen
            
            switch (sx, sy) {
            case (x - 1, y - 1):
                return true
            case (x, y - 1):
                return true
            case (x + 1, y - 1):
                return true
            case (x - 1, y):
                return true
            case (x + 1, y):
                return true
            case (x - 1, y + 1):
                return true
            case (x, y + 1):
                return true
            case (x + 1, y + 1):
                return true
            default:
                return false
            }
        } else {
            return true
        }
    }
    
    internal func updateScoreForWord(word: String) {
        score += Int(pow(Double(2), Double(count(word) - 1)))
    }
    
}
