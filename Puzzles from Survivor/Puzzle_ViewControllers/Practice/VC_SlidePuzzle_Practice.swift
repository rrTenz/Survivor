//
//  VC_SlidePuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 8/31/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//
//  Got Help from https://www.youtube.com/watch?v=6RqEfG9_5R4
//

import UIKit
import GameKit

class VC_SlidePuzzle_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_SLIDE_TIME = "com.score_slide_time.puzzlesfromsurvivor"    //Best Time - Slide Puzzle
    let LEADERBOARD_ID_SLIDE_MOVES = "com.score_slide_moves.puzzlesfromsurvivor"  //Fewest Moves - Slide Puzzle

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    var allImgViews: [UIImageView] = []
    var allCenters: [CGPoint] = []
    var allIndexes: [Int] = []
    
    var gameViewWidth: CGFloat = 0.0
    var blockWidth: CGFloat = 0.0
    
    var timer = Timer()
    var timerCount = 0
    var moveCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameViewWidth = self.gameView.frame.size.height
        self.blockWidth = gameViewWidth / 6
        
        var xCen = blockWidth / 2
        var yCen = blockWidth / 2
        
        allImgViews = []
        var index = 1
        for _ in 0..<4 {
            for _ in 0..<4 {
                let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth))
                
                let currentCenter = CGPoint(x: xCen, y: yCen)
                allCenters.append(currentCenter)
                allIndexes.append(index - 1)
                myImageView.center = currentCenter
                
                if index < 10 {
                    myImageView.image = UIImage(named: "0\(index)")
                }else {
                    myImageView.image = UIImage(named: "\(index)")
                }
                index += 1
                allImgViews.append(myImageView)
                myImageView.isUserInteractionEnabled = true
                self.gameView.addSubview(myImageView)
                
                xCen += blockWidth
            }
            xCen = blockWidth / 2
            yCen += blockWidth
        }
        
        emptySpot = allCenters.last!
        allImgViews[15].removeFromSuperview()
        allImgViews.removeLast()
        
        ranodomizeBlocks()
        
        authenticateLocalPlayer()
        
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error ?? "Default Error")
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? "Default Error")
            }
        }
    }
    
    // MARK: - SUBMIT THE SCORE TO GAME CENTER
    func submitScoreToGC(score: Int, leaderBoardID: String) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderBoardID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - OPEN GAME CENTER LEADERBOARD
    func checkGCLeaderboard(leaderBoardID: String) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = leaderBoardID
        present(gcVC, animated: true, completion: nil)
    }
    
    var timerStarted = false
    @IBAction func Button_NewGame(_ sender: Any) {
        timerCount = 0
        timerLabel.text = "\(timerCount)"
        ranodomizeBlocks()
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
    }
    
    @IBOutlet weak var Button_Done_outlet: UIButton!
    @IBAction func Button_Done(_ sender: Any) {
        if timerStarted {
            if checkForSolved() == false {
                let alertController = UIAlertController(title: "No", message: "Something is wrong! Keep going!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else {
                timerStarted = false
                timer.invalidate()
                Button_Done_outlet.setTitle("Resume", for: .normal)
            }
        }else {
            timerStarted = true
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
            Button_Done_outlet.setTitle("Done Jeff", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    var emptySpot = CGPoint(x: 0, y: 0)
    func ranodomizeBlocks() {
        
/*  This is not always a solvable puzzle
        var allCenters_copy = allCenters
        var randLocInt: Int
        var randLoc: CGPoint
        
        for any in allImgViews {
            randLocInt = Int(arc4random() % UInt32(allCenters_copy.count))
            randLoc = allCenters_copy[randLocInt]
            
            any.center = randLoc
            allCenters_copy.remove(at: randLocInt)
        }
        emptySpot = allCenters_copy[0]  //the last spot is the empty one
 */
        for _ in 0...1000 {
            let randIndex = Int(arc4random() % UInt32(allImgViews.count))
            let myTouch = allImgViews[randIndex]
            
            tapCenter = myTouch.center
            
            left = CGPoint(x: tapCenter.x - blockWidth, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + blockWidth, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + blockWidth)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - blockWidth)
            
            if Int(emptySpot.x) == Int(left.x) && Int(emptySpot.y) == Int(left.y) {
                leftIsEmpty = true
            }else if Int(emptySpot.x) == Int(right.x) && Int(emptySpot.y) == Int(right.y) {
                rightIsEmpty = true
            }else if Int(emptySpot.x) == Int(top.x) && Int(emptySpot.y) == Int(top.y) {
                topIsEmpty = true
            }else if Int(emptySpot.x) == Int(bottom.x) && Int(emptySpot.y) == Int(bottom.y) {
                bottomIsEmpty = true
            }
            
            if leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty {
                updateIndexArray(first: tapCenter, second: emptySpot)
                allImgViews[randIndex].center = emptySpot
                emptySpot = tapCenter
                leftIsEmpty = false
                rightIsEmpty = false
                topIsEmpty = false
                bottomIsEmpty = false
            }
        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        Label_YouWin.isHidden = true
        timerStarted = true
    }
    
    @objc func inrementTimer() {
        timerCount += 1
        timerLabel.text = "\(timerCount)"
    }
    
    var tapCenter = CGPoint(x: 0, y: 0)
    var left = CGPoint(x: 0, y: 0)
    var right = CGPoint(x: 0, y: 0)
    var top = CGPoint(x: 0, y: 0)
    var bottom = CGPoint(x: 0, y: 0)
    var leftIsEmpty = false
    var rightIsEmpty = false
    var topIsEmpty = false
    var bottomIsEmpty = false
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch = touches.first
        
        if myTouch?.view != self.view {
            tapCenter = (myTouch?.view?.center)!
            
            left = CGPoint(x: tapCenter.x - blockWidth, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + blockWidth, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + blockWidth)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - blockWidth)
            
            if Int(emptySpot.x) == Int(left.x) && Int(emptySpot.y) == Int(left.y) {
                leftIsEmpty = true
            }else if Int(emptySpot.x) == Int(right.x) && Int(emptySpot.y) == Int(right.y) {
                rightIsEmpty = true
            }else if Int(emptySpot.x) == Int(top.x) && Int(emptySpot.y) == Int(top.y) {
                topIsEmpty = true
            }else if Int(emptySpot.x) == Int(bottom.x) && Int(emptySpot.y) == Int(bottom.y) {
                bottomIsEmpty = true
            }
            
            if leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty {
                updateIndexArray(first: tapCenter, second: emptySpot)
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                myTouch?.view?.center = emptySpot
                UIView.commitAnimations()
                emptySpot = tapCenter
                leftIsEmpty = false
                rightIsEmpty = false
                topIsEmpty = false
                bottomIsEmpty = false
                moveCount += 1
                Label_MoveCount.text = "\(moveCount)"
            }
        }
        
        _ = checkForSolved()
    }
    
    func updateIndexArray(first: CGPoint, second: CGPoint) {
        var indexFirst = 0
        var indexSecond = 0
        var index = 0
        
        for center in allCenters {
            if first == center {
                indexFirst = index
            }
            if second == center {
                indexSecond = index
            }
            index += 1
        }
        
        let tempIndex = allIndexes[indexFirst]
        allIndexes[indexFirst] = allIndexes[indexSecond]
        allIndexes[indexSecond] = tempIndex
        print(allIndexes)
    }
    
    func checkForSolved() -> Bool{
        var index = 0
        for i in allIndexes {
            if i != index {
                return false
            }
            index += 1
        }
        
        //If we get here, then the puzzle is solved
        
        let alertController = UIAlertController(title: "You Win", message: "Good job!\nYou completed the puzzle!\n\nMoves: \(moveCount)\nSeconds: \(timerCount)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let submitScoreAction = UIAlertAction(title: "Submit Score", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Submit Pressed")
            self.submitScore()
        }
        let submitScoreAndGoAction = UIAlertAction(title: "Submit / View Leaders", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Submit Pressed")
            
            self.submitScore()
            self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_SLIDE_TIME)
            
        }
        alertController.addAction(okAction)
        alertController.addAction(submitScoreAction)
        alertController.addAction(submitScoreAndGoAction)
        self.present(alertController, animated: true, completion: nil)
        
        timerStarted = false
        timer.invalidate()
        Button_Done_outlet.setTitle("Resume", for: .normal)
        
        return true
    }
    
    func submitScore() {
        self.submitScoreToGC(score: self.timerCount, leaderBoardID: self.LEADERBOARD_ID_SLIDE_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_SLIDE_MOVES)
    }
}
