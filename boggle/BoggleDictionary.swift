//
//  GameDictionary.swift
//  boggle
//
//  Created by Bin Bo on 7/25/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import Foundation

class BoggleDictionary {
    
    static let instance = BoggleDictionary()
    
    var words = Set<String>()
    
    init() {
        // Load the words from dictionary data file
        let path = NSBundle.mainBundle().pathForResource("dictionary", ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { // 1
            text.characters.split {$0 == "\n"}.map { String($0) }.map{self.words.insert($0)}
            dispatch_async(dispatch_get_main_queue()) {
                // disable loading
            }
        }
    }
    
    func contains(word: String) -> Bool {
        return words.contains(word)
    }
    
}