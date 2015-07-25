//
//  ViewController.swift
//  boggle
//
//  Created by Bin Bo on 7/21/15.
//  Copyright (c) 2015 Bin Bo. All rights reserved.
//

import UIKit

class SingleGameViewController: UIViewController, UITableViewDataSource, GameDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var wordsView: UITableView!
    @IBOutlet weak var wordBoard: WordBoard!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!

    var game: SingleBoggleGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        game = GameManager.instance.createSingleGame(4)
        game.delegate = self
        
        wordBoard.layer.borderColor   = UIColor.grayColor().CGColor
        wordBoard.layer.borderWidth   = 0.5
        wordBoard.layer.contentsScale = UIScreen.mainScreen().scale;
        wordBoard.layer.shadowColor   = UIColor.blackColor().CGColor;
        wordBoard.layer.shadowOffset  = CGSizeZero;
        wordBoard.layer.shadowRadius  = 5.0;
        wordBoard.layer.shadowOpacity = 0.5;
        // wordBoard.layer.cornerRadius = 10.0 // need a second view: http://stackoverflow.com/questions/25591389/uiview-with-shadow-rounded-corners-and-custom-drawrect
        wordBoard.layer.masksToBounds = true;
        wordBoard.clipsToBounds = false;
        
        startGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame() {
        game.start()
        game.resume()
        wordBoard.userInteractionEnabled = true
    }
    
    func stopGame() {
        game.pause()
        game.stop()
        wordBoard.userInteractionEnabled = false
    }
    
    func refreshDisplay() {
        timeView.text  = String(game.time)
        scoreView.text = String(game.score)
        wordsView.reloadData()
        wordBoard.setNeedsDisplay()
    }
    
    @IBAction func exitGame() {
        game.pause()
        
        if game.stopped {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                GameManager.instance.activeGame = nil
            })
        } else {
            var alert = UIAlertController(title: "Exit Game", message: "Are you sure to exit the current game?", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                println("Click of default button")
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    GameManager.instance.activeGame = nil
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                println("Click of cancel button")
                self.game.resume()
            }))
        }
    }
    
    @IBAction func restartGame() {
        self.game.pause()
        
        if game.stopped {
            self.startGame()
            self.refreshDisplay()
        } else {
            var alert = UIAlertController(title: "Restart Game", message: "Are you sure to drop this play?", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                println("Click of default button")
                self.stopGame()
                self.startGame()
                self.refreshDisplay()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                println("Click of cancel button")
                self.game.resume()
            }))
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.foundWords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.text = game.foundWords.reverse()[indexPath.row]
        return cell
    }
    
    func gameDidPick(word: String, valid: Bool) {
        if valid {
            wordsView.reloadData()
            scoreView.text = String(game.score)
        }
    }
    
    func gameDidTick(time: Int) {
        timeView.text = String(time)
        if time <= 0 {
            stopGame()
            
            var alert = UIAlertController(title: "Time is up!", message: "You've got \(game.score) score!\nWould you like to play again?", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                println("Click of default button")
                self.startGame()
                self.refreshDisplay()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
                println("Click of cancel button")
            }))
        }
    }
}

