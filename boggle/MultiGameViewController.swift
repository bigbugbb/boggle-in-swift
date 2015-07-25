//
//  MultiGameViewController.swift
//  boggle
//
//  Created by Bin Bo on 7/25/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import UIKit

class MultiGameViewController: UIViewController, GameDelegate {
    
    @IBOutlet weak var exitButton: UIButton!
    
    var game: MultiBoggleGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        game = GameManager.instance.createMultiGame(4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitGame() {
        game.stop()
        dismissViewControllerAnimated(true, completion: { () -> Void in
            GameManager.instance.activeGame = nil
        })
    }
    
    func gameDidPick(word: String, valid: Bool) {
        
    }
    
    func gameDidTick(time: Int) {
        if time <= 0 {
            game.stop()
        }
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        game = GameManager.instance.createMultiGame(4)
//    }
}
