//
//  VC_ColorAndShape_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 11/8/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_ColorAndShape_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_COLOR_AND_SHAPE_TIME = "com.score_color_and_shape_time.puzzlesfromsurvivor2"    //Best Time - Color and Shape
    let LEADERBOARD_ID_COLOR_AND_SHAPE_MOVES = "com.score_color_and_shape_moves.puzzlesfromsurvivor2"  //Fewest Moves - Color and Shape
    
    @IBOutlet weak var View_Scratch_0: UIView!
    @IBOutlet weak var View_Scratch_1: UIView!
    @IBOutlet weak var View_Scratch_2: UIView!
    @IBOutlet weak var View_Scratch_3: UIView!
    @IBOutlet weak var View_Scratch_4: UIView!
    @IBOutlet weak var View_Scratch_5: UIView!
    
    @IBOutlet weak var View_Solve_0: UIView!
    @IBOutlet weak var View_Solve_1: UIView!
    @IBOutlet weak var View_Solve_2: UIView!    
    @IBOutlet weak var View_Solve_3: UIView!
    @IBOutlet weak var View_Solve_4: UIView!
    @IBOutlet weak var View_Solve_5: UIView!
    
    @IBOutlet weak var View_Holder: UIView!
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.01

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.View_Solve_3.transform = CGAffineTransform(rotationAngle: (90 * .pi) / 180.0)
        self.View_Solve_4.transform = CGAffineTransform(rotationAngle: (90 * .pi) / 180.0)
        self.View_Solve_5.transform = CGAffineTransform(rotationAngle: (90 * .pi) / 180.0)

        NewGame()
        
        authenticateLocalPlayer()
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
        NewGame()
    }
    
    func NewGame() {
        ranodomizeBlocks()
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.2f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        timerStarted = true
        
        let colorArray = [UIColor.red, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.white, UIColor.purple, UIColor.black, UIColor.brown, UIColor.orange]
        let colorShuffled = colorArray.shuffled()
        
        let blockArray = [[colorShuffled[0], colorShuffled[1], colorShuffled[0]],
                          [colorShuffled[2], colorShuffled[3], colorShuffled[3]],
                          [colorShuffled[0], colorShuffled[3], colorShuffled[1]],
                          [colorShuffled[0], colorShuffled[2], colorShuffled[0]],
                          [colorShuffled[1], colorShuffled[2], colorShuffled[0]],
                          [colorShuffled[2], colorShuffled[3], colorShuffled[1]]]
        var shuffled = blockArray.shuffled()
        
        var i = 0
        for _ in shuffled {
            if arc4random_uniform(2) == 0 ? true : false {
                let temp = shuffled[i][0]
                shuffled[i][0] = shuffled[i][2]
                shuffled[i][2] = temp
            }
            i += 1
        }
        Button_s0_L.backgroundColor = shuffled[0][0]
        Button_s0_M.backgroundColor = shuffled[0][1]
        Button_s0_R.backgroundColor = shuffled[0][2]
        Button_S1L.backgroundColor = shuffled[1][0]
        Button_S1M.backgroundColor = shuffled[1][1]
        Button_S1R.backgroundColor = shuffled[1][2]
        Button_s2L.backgroundColor = shuffled[2][0]
        Button_s2m.backgroundColor = shuffled[2][1]
        Button_s2r.backgroundColor = shuffled[2][2]
        Button_s3l.backgroundColor = shuffled[3][0]
        Button_s3m.backgroundColor = shuffled[3][1]
        Button_s3r.backgroundColor = shuffled[3][2]
        Button_s4l.backgroundColor = shuffled[4][0]
        Button_s4m.backgroundColor = shuffled[4][1]
        Button_s4r.backgroundColor = shuffled[4][2]
        Button_s5l.backgroundColor = shuffled[5][0]
        Button_s5m.backgroundColor = shuffled[5][1]
        Button_s5r.backgroundColor = shuffled[5][2]
        
        Button_s0_L.isHidden = false
        Button_s0_M.isHidden = false
        Button_s0_R.isHidden = false
        Button_S1L.isHidden = false
        Button_S1M.isHidden = false
        Button_S1R.isHidden = false
        Button_s2L.isHidden = false
        Button_s2m.isHidden = false
        Button_s2r.isHidden = false
        Button_s3l.isHidden = false
        Button_s3m.isHidden = false
        Button_s3r.isHidden = false
        Button_s4l.isHidden = false
        Button_s4m.isHidden = false
        Button_s4r.isHidden = false
        Button_s5l.isHidden = false
        Button_s5m.isHidden = false
        Button_s5r.isHidden = false
        
        Button_0l.isHidden = true
        Button_0m.isHidden = true
        Button_0r.isHidden = true
        Button_1l.isHidden = true
        Button_1m.isHidden = true
        Button_1r.isHidden = true
        Button_2l.isHidden = true
        Button_2m.isHidden = true
        Button_2r.isHidden = true
        Button_3l.isHidden = true
        Button_3m.isHidden = true
        Button_3r.isHidden = true
        Button_4l.isHidden = true
        Button_4m.isHidden = true
        Button_4r.isHidden = true
        Button_5l.isHidden = true
        Button_5m.isHidden = true
        Button_5r.isHidden = true
        
        Button_hl.isHidden = true
        Button_hm.isHidden = true
        Button_hr.isHidden = true
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.2f", timerCount)
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkForSolved() -> Bool {
        return false
    }
    
    func ranodomizeBlocks () {
        
    }
    
    enum Block {
        case Scratch0
        case Scratch1
        case Scratch2
        case Scratch3
        case Scratch4
        case Scratch5
        
        case Solve0
        case Solve1
        case Solve2
        case Solve3
        case Solve4
        case Solve5
        
        case Holder
    }
    
    func CheckSolution() {
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        if Button_0l.isHidden || Button_0m.isHidden || Button_0r.isHidden ||
            Button_1l.isHidden || Button_1m.isHidden || Button_1r.isHidden ||
            Button_2l.isHidden || Button_2m.isHidden || Button_2r.isHidden ||
            Button_3l.isHidden || Button_3m.isHidden || Button_3r.isHidden ||
            Button_4l.isHidden || Button_4m.isHidden || Button_4r.isHidden ||
            Button_5l.isHidden || Button_5m.isHidden || Button_5r.isHidden {
            print("nope, empty")
        }else if Button_0l.backgroundColor == Button_3l.backgroundColor &&
            Button_0m.backgroundColor == Button_4l.backgroundColor &&
            Button_0r.backgroundColor == Button_5l.backgroundColor &&
            Button_1l.backgroundColor == Button_3m.backgroundColor &&
            Button_1m.backgroundColor == Button_4m.backgroundColor &&
            Button_1r.backgroundColor == Button_5m.backgroundColor &&
            Button_2l.backgroundColor == Button_3r.backgroundColor &&
            Button_2m.backgroundColor == Button_4r.backgroundColor &&
            Button_2r.backgroundColor == Button_5r.backgroundColor {
            print("yup")
            
            timerStarted = false
            timer.invalidate()
            
            appDelegate.puzzlesCompleted += 1
            appDelegate.pcc_ColorAndShape += 1
            Defaults().save_Defaults(updateStreak: true)
            let timeString = String(format: "%.2f", timerCount)
            let alertController = UIAlertController(title: "You Win", message: "Good job!\nYou completed the puzzle!\n\nMoves: \(moveCount)\nSeconds: \(timeString)", preferredStyle: .alert)
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
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_COLOR_AND_SHAPE_TIME)
            }
            alertController.addAction(okAction)
            alertController.addAction(submitScoreAction)
            alertController.addAction(submitScoreAndGoAction)
            self.present(alertController, animated: true, completion: nil)
        }else {
            print("nope")
        }
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 100), leaderBoardID: self.LEADERBOARD_ID_COLOR_AND_SHAPE_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_COLOR_AND_SHAPE_MOVES)
        
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_ColorAndShape), leaderBoardID: appDelegate.LEADERBOARD_pcc_ColorAndShape)
    }
    
    func moveBlockToHolder(block: Block) -> Bool{
        if Button_hl.isHidden && Button_hm.isHidden && Button_hr.isHidden { //is the hidden block empty
            switch block {
            case .Scratch0:
                if !Button_s0_L.isHidden && !Button_s0_M.isHidden && !Button_s0_R.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_s0_L.backgroundColor!, mid: Button_s0_M.backgroundColor!, right: Button_s0_R.backgroundColor!)
                    return true
                }
            case .Scratch1:
                if !Button_S1L.isHidden && !Button_S1M.isHidden && !Button_S1R.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_S1L.backgroundColor!, mid: Button_S1M.backgroundColor!, right: Button_S1R.backgroundColor!)
                    return true
                }
            case .Scratch2:
                if !Button_s2L.isHidden && !Button_s2m.isHidden && !Button_s2r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_s2L.backgroundColor!, mid: Button_s2m.backgroundColor!, right: Button_s2r.backgroundColor!)
                    return true
                }
            case .Scratch3:
                if !Button_s3l.isHidden && !Button_s3m.isHidden && !Button_s3r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_s3l.backgroundColor!, mid: Button_s3m.backgroundColor!, right: Button_s3r.backgroundColor!)
                    return true
                }
            case .Scratch4:
                if !Button_s4l.isHidden && !Button_s4m.isHidden && !Button_s4r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_s4l.backgroundColor!, mid: Button_s4m.backgroundColor!, right: Button_s4r.backgroundColor!)
                    return true
                }
            case .Scratch5:
                if !Button_s5l.isHidden && !Button_s5m.isHidden && !Button_s5r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_s5l.backgroundColor!, mid: Button_s5m.backgroundColor!, right: Button_s5r.backgroundColor!)
                    return true
                }
                
            case .Solve0:
                if !Button_0l.isHidden && !Button_0m.isHidden && !Button_0r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_0l.backgroundColor!, mid: Button_0m.backgroundColor!, right: Button_0r.backgroundColor!)
                    return true
                }
            case .Solve1:
                if !Button_1l.isHidden && !Button_1m.isHidden && !Button_1r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_1l.backgroundColor!, mid: Button_1m.backgroundColor!, right: Button_1r.backgroundColor!)
                    return true
                }
            case .Solve2:
                if !Button_2l.isHidden && !Button_2m.isHidden && !Button_2r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_2l.backgroundColor!, mid: Button_2m.backgroundColor!, right: Button_2r.backgroundColor!)
                    return true
                }
            case .Solve3:
                if !Button_3l.isHidden && !Button_3m.isHidden && !Button_3r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_3l.backgroundColor!, mid: Button_3m.backgroundColor!, right: Button_3r.backgroundColor!)
                    return true
                }
            case .Solve4:
                if !Button_4l.isHidden && !Button_4m.isHidden && !Button_4r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_4l.backgroundColor!, mid: Button_4m.backgroundColor!, right: Button_4r.backgroundColor!)
                    return true
                }
            case .Solve5:
                if !Button_5l.isHidden && !Button_5m.isHidden && !Button_5r.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_5l.backgroundColor!, mid: Button_5m.backgroundColor!, right: Button_5r.backgroundColor!)
                    return true
                }
                
            case .Holder:
                if !Button_hl.isHidden && !Button_hm.isHidden && !Button_hr.isHidden {   //Only move if it's not hidden
                    showHolderBlock(block: block, left: Button_hl.backgroundColor!, mid: Button_hm.backgroundColor!, right: Button_hr.backgroundColor!)
                    return true
                }
            }
        }else {
            return false    //holder block is being used
        }
        
        return false
    }
    
    func moveHolderToBlock(block: Block) -> Bool{
        if !Button_hl.isHidden && !Button_hm.isHidden && !Button_hr.isHidden { //is there a block in the holder spot
            switch block {
            case .Scratch0:
                if Button_s0_L.isHidden && Button_s0_M.isHidden && Button_s0_R.isHidden {   //Only move if it is hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Scratch1:
                if Button_S1L.isHidden && Button_S1M.isHidden && Button_S1R.isHidden {   //Only move if it is hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Scratch2:
                if Button_s2L.isHidden && Button_s2m.isHidden && Button_s2r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Scratch3:
                if Button_s3l.isHidden && Button_s3m.isHidden && Button_s3r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Scratch4:
                if Button_s4l.isHidden && Button_s4m.isHidden && Button_s4r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Scratch5:
                if Button_s5l.isHidden && Button_s5m.isHidden && Button_s5r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
                
            case .Solve0:
                if Button_0l.isHidden && Button_0m.isHidden && Button_0r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Solve1:
                if Button_1l.isHidden && Button_1m.isHidden && Button_1r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Solve2:
                if Button_2l.isHidden && Button_2m.isHidden && Button_2r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Solve3:
                if Button_3l.isHidden && Button_3m.isHidden && Button_3r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Solve4:
                if Button_4l.isHidden && Button_4m.isHidden && Button_4r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            case .Solve5:
                if Button_5l.isHidden && Button_5m.isHidden && Button_5r.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
                
            case .Holder:
                if Button_hl.isHidden && Button_hm.isHidden && Button_hr.isHidden {   //Only move if it's not hidden
                    removeHolderBlock(block: block)
                    return true
                }
            }
        }else {
            return false    //holder block is being used
        }
        
        return false
    }
    
    func showHolderBlock(block: Block, left: UIColor, mid: UIColor, right: UIColor) {
        Button_hl.isHidden = false
        Button_hm.isHidden = false
        Button_hr.isHidden = false
        Button_hl.backgroundColor = left
        Button_hm.backgroundColor = mid
        Button_hr.backgroundColor = right
        
        switch block {
        case .Scratch0:
            Button_s0_L.isHidden = true
            Button_s0_M.isHidden = true
            Button_s0_R.isHidden = true
        case .Scratch1:
            Button_S1L.isHidden = true
            Button_S1M.isHidden = true
            Button_S1R.isHidden = true
        case .Scratch2:
            Button_s2L.isHidden = true
            Button_s2m.isHidden = true
            Button_s2r.isHidden = true
        case .Scratch3:
            Button_s3l.isHidden = true
            Button_s3m.isHidden = true
            Button_s3r.isHidden = true
        case .Scratch4:
            Button_s4l.isHidden = true
            Button_s4m.isHidden = true
            Button_s4r.isHidden = true
        case .Scratch5:
            Button_s5l.isHidden = true
            Button_s5m.isHidden = true
            Button_s5r.isHidden = true
            
        case .Solve0:
            Button_0l.isHidden = true
            Button_0m.isHidden = true
            Button_0r.isHidden = true
        case .Solve1:
            Button_1l.isHidden = true
            Button_1m.isHidden = true
            Button_1r.isHidden = true
        case .Solve2:
            Button_2l.isHidden = true
            Button_2m.isHidden = true
            Button_2r.isHidden = true
        case .Solve3:
            Button_3l.isHidden = true
            Button_3m.isHidden = true
            Button_3r.isHidden = true
        case .Solve4:
            Button_4l.isHidden = true
            Button_4m.isHidden = true
            Button_4r.isHidden = true
        case .Solve5:
            Button_5l.isHidden = true
            Button_5m.isHidden = true
            Button_5r.isHidden = true
            
        case .Holder:
            Button_hl.isHidden = true
            Button_hm.isHidden = true
            Button_hr.isHidden = true
        }
        
        CheckSolution()
    }
    
    func removeHolderBlock(block: Block) {
        Button_hl.isHidden = true
        Button_hm.isHidden = true
        Button_hr.isHidden = true
        
        switch block {
        case .Scratch0:
            Button_s0_L.isHidden = false
            Button_s0_M.isHidden = false
            Button_s0_R.isHidden = false
            Button_s0_L.backgroundColor = Button_hl.backgroundColor
            Button_s0_M.backgroundColor = Button_hm.backgroundColor
            Button_s0_R.backgroundColor = Button_hr.backgroundColor
        case .Scratch1:
            Button_S1L.isHidden = false
            Button_S1M.isHidden = false
            Button_S1R.isHidden = false
            Button_S1L.backgroundColor = Button_hl.backgroundColor
            Button_S1M.backgroundColor = Button_hm.backgroundColor
            Button_S1R.backgroundColor = Button_hr.backgroundColor
        case .Scratch2:
            Button_s2L.isHidden = false
            Button_s2m.isHidden = false
            Button_s2r.isHidden = false
            Button_s2L.backgroundColor = Button_hl.backgroundColor
            Button_s2m.backgroundColor = Button_hm.backgroundColor
            Button_s2r.backgroundColor = Button_hr.backgroundColor
        case .Scratch3:
            Button_s3l.isHidden = false
            Button_s3m.isHidden = false
            Button_s3r.isHidden = false
            Button_s3l.backgroundColor = Button_hl.backgroundColor
            Button_s3m.backgroundColor = Button_hm.backgroundColor
            Button_s3r.backgroundColor = Button_hr.backgroundColor
        case .Scratch4:
            Button_s4l.isHidden = false
            Button_s4m.isHidden = false
            Button_s4r.isHidden = false
            Button_s4l.backgroundColor = Button_hl.backgroundColor
            Button_s4m.backgroundColor = Button_hm.backgroundColor
            Button_s4r.backgroundColor = Button_hr.backgroundColor
        case .Scratch5:
            Button_s5l.isHidden = false
            Button_s5m.isHidden = false
            Button_s5r.isHidden = false
            Button_s5l.backgroundColor = Button_hl.backgroundColor
            Button_s5m.backgroundColor = Button_hm.backgroundColor
            Button_s5r.backgroundColor = Button_hr.backgroundColor
            
        case .Solve0:
            Button_0l.isHidden = false
            Button_0m.isHidden = false
            Button_0r.isHidden = false
            Button_0l.backgroundColor = Button_hl.backgroundColor
            Button_0m.backgroundColor = Button_hm.backgroundColor
            Button_0r.backgroundColor = Button_hr.backgroundColor
        case .Solve1:
            Button_1l.isHidden = false
            Button_1m.isHidden = false
            Button_1r.isHidden = false
            Button_1l.backgroundColor = Button_hl.backgroundColor
            Button_1m.backgroundColor = Button_hm.backgroundColor
            Button_1r.backgroundColor = Button_hr.backgroundColor
        case .Solve2:
            Button_2l.isHidden = false
            Button_2m.isHidden = false
            Button_2r.isHidden = false
            Button_2l.backgroundColor = Button_hl.backgroundColor
            Button_2m.backgroundColor = Button_hm.backgroundColor
            Button_2r.backgroundColor = Button_hr.backgroundColor
        case .Solve3:
            Button_3l.isHidden = false
            Button_3m.isHidden = false
            Button_3r.isHidden = false
            Button_3l.backgroundColor = Button_hl.backgroundColor
            Button_3m.backgroundColor = Button_hm.backgroundColor
            Button_3r.backgroundColor = Button_hr.backgroundColor
        case .Solve4:
            Button_4l.isHidden = false
            Button_4m.isHidden = false
            Button_4r.isHidden = false
            Button_4l.backgroundColor = Button_hl.backgroundColor
            Button_4m.backgroundColor = Button_hm.backgroundColor
            Button_4r.backgroundColor = Button_hr.backgroundColor
        case .Solve5:
            Button_5l.isHidden = false
            Button_5m.isHidden = false
            Button_5r.isHidden = false
            Button_5l.backgroundColor = Button_hl.backgroundColor
            Button_5m.backgroundColor = Button_hm.backgroundColor
            Button_5r.backgroundColor = Button_hr.backgroundColor
            
        case .Holder:
            Button_hl.isHidden = false
            Button_hm.isHidden = false
            Button_hr.isHidden = false
            Button_hl.backgroundColor = Button_hl.backgroundColor
            Button_hm.backgroundColor = Button_hm.backgroundColor
            Button_hr.backgroundColor = Button_hr.backgroundColor
        }
        
        CheckSolution()
    }
    
    @IBOutlet weak var Button_s0: UIButton!
    @IBAction func Button_s0(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch0)
    }
    @IBOutlet weak var Button_s0_L: UIButton!
    @IBAction func Button_s0_L(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch0)
    }
    @IBOutlet weak var Button_s0_M: UIButton!
    @IBAction func Button_s0_M(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch0)
    }
    @IBOutlet weak var Button_s0_R: UIButton!
    @IBAction func Button_s0_R(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch0)
    }
    
    @IBOutlet weak var Button_s1: UIButton!
    @IBAction func Button_s1(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch1)
    }
    @IBOutlet weak var Button_S1L: UIButton!
    @IBAction func Button_s1L(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch1)
    }
    @IBOutlet weak var Button_S1M: UIButton!
    @IBAction func Button_s1M(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch1)
    }
    @IBOutlet weak var Button_S1R: UIButton!
    @IBAction func Button_S1R(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch1)
    }
    
    @IBOutlet weak var Button_s2: UIButton!
    @IBAction func Button_s2(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch2)
    }
    @IBOutlet weak var Button_s2L: UIButton!
    @IBAction func Button_S2L(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch2)
    }
    @IBOutlet weak var Button_s2m: UIButton!
    @IBAction func Button_s2m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch2)
    }
    @IBOutlet weak var Button_s2r: UIButton!
    @IBAction func Button_s2r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch2)
    }
    
    @IBOutlet weak var Button_s3: UIButton!
    @IBAction func Button_s3(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch3)
    }
    @IBOutlet weak var Button_s3l: UIButton!
    @IBAction func Button_s3l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch3)
    }
    @IBOutlet weak var Button_s3m: UIButton!
    @IBAction func Button_s3m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch3)
    }
    @IBOutlet weak var Button_s3r: UIButton!
    @IBAction func Button_s3r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch3)
    }
    
    @IBOutlet weak var Button_s4: UIButton!
    @IBAction func Button_s4(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch4)
    }
    @IBOutlet weak var Button_s4l: UIButton!
    @IBAction func Button_s4l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch4)
    }
    @IBOutlet weak var Button_s4m: UIButton!
    @IBAction func Button_s4m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch4)
    }
    @IBOutlet weak var Button_s4r: UIButton!
    @IBAction func Button_s4r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch4)
    }
    
    @IBOutlet weak var Button_s5: UIButton!
    @IBAction func Button_s5(_ sender: Any) {
        _ = moveHolderToBlock(block: .Scratch5)
    }
    @IBOutlet weak var Button_s5l: UIButton!
    @IBAction func Button_s5l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch5)
    }
    @IBOutlet weak var Button_s5m: UIButton!
    @IBAction func Button_s5m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch5)
    }
    @IBOutlet weak var Button_s5r: UIButton!
    @IBAction func Button_s5r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Scratch5)
    }
    
    
    @IBOutlet weak var Button_0: UIButton!
    @IBAction func Button_0(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve0)
    }
    @IBOutlet weak var Button_0l: UIButton!
    @IBAction func Button_0l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve0)
    }
    @IBOutlet weak var Button_0m: UIButton!
    @IBAction func Button_0m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve0)
    }
    @IBOutlet weak var Button_0r: UIButton!
    @IBAction func Button_0r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve0)
    }
    
    @IBOutlet weak var Button_1: UIButton!
    @IBAction func Button_1(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve1)
    }
    @IBOutlet weak var Button_1l: UIButton!
    @IBAction func Button_1l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve1)
    }
    @IBOutlet weak var Button_1m: UIButton!
    @IBAction func Button_1m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve1)
    }
    @IBOutlet weak var Button_1r: UIButton!
    @IBAction func Button_1r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve1)
    }
    
    @IBOutlet weak var Button_2: UIButton!
    @IBAction func Button_2(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve2)
    }
    @IBOutlet weak var Button_2l: UIButton!
    @IBAction func Button_2l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve2)
    }
    @IBOutlet weak var Button_2m: UIButton!
    @IBAction func Button_2m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve2)
    }
    @IBOutlet weak var Button_2r: UIButton!
    @IBAction func Button_2r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve2)
    }
    
    @IBOutlet weak var Button_3: UIButton!
    @IBAction func Button_3(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve3)
    }
    @IBOutlet weak var Button_3l: UIButton!
    @IBAction func Button_3l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve3)
    }
    @IBOutlet weak var Button_3m: UIButton!
    @IBAction func Button_3m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve3)
    }
    @IBOutlet weak var Button_3r: UIButton!
    @IBAction func Button_3r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve3)
    }
    
    @IBOutlet weak var Button_4: UIButton!
    @IBAction func Button_4(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve4)
    }
    @IBOutlet weak var Button_4l: UIButton!
    @IBAction func Button_4l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve4)
    }
    @IBOutlet weak var Button_4m: UIButton!
    @IBAction func Button_4m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve4)
    }
    @IBOutlet weak var Button_4r: UIButton!
    @IBAction func Button_4r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve4)
    }
    
    @IBOutlet weak var Button_5: UIButton!
    @IBAction func Button_5(_ sender: Any) {
        _ = moveHolderToBlock(block: .Solve5)
    }
    @IBOutlet weak var Button_5l: UIButton!
    @IBAction func Button_5l(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve5)
    }
    @IBOutlet weak var Button_5m: UIButton!
    @IBAction func Button_5m(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve5)
    }
    @IBOutlet weak var Button_5r: UIButton!
    @IBAction func Button_5r(_ sender: Any) {
        _ = moveBlockToHolder(block: .Solve5)
    }
    
    @IBOutlet weak var Button_h: UIButton!
    @IBAction func Button_h(_ sender: Any) {
    }
    @IBOutlet weak var Button_hl: UIButton!
    @IBAction func Button_hl(_ sender: Any) {
        
    }
    @IBOutlet weak var Button_hm: UIButton!
    @IBAction func Button_hm(_ sender: Any) {
        
    }
    @IBOutlet weak var Button_hr: UIButton!
    @IBAction func Button_hr(_ sender: Any) {
       
    }
    
    @IBAction func Button_Rotate_0(_ sender: Any) {
        let temp = Button_0l.backgroundColor
        Button_0l.backgroundColor = Button_0r.backgroundColor
        Button_0r.backgroundColor = temp
        CheckSolution()
    }
    @IBAction func Button_Rotate_1(_ sender: Any) {
        let temp = Button_1l.backgroundColor
        Button_1l.backgroundColor = Button_1r.backgroundColor
        Button_1r.backgroundColor = temp
        CheckSolution()
    }
    @IBAction func Button_Rotate_2(_ sender: Any) {
        let temp = Button_2l.backgroundColor
        Button_2l.backgroundColor = Button_2r.backgroundColor
        Button_2r.backgroundColor = temp
        CheckSolution()
    }
    @IBAction func Button_Rotate_3(_ sender: Any) {
        let temp = Button_3l.backgroundColor
        Button_3l.backgroundColor = Button_3r.backgroundColor
        Button_3r.backgroundColor = temp
        CheckSolution()
    }
    @IBAction func Button_Rotate_4(_ sender: Any) {
        let temp = Button_4l.backgroundColor
        Button_4l.backgroundColor = Button_4r.backgroundColor
        Button_4r.backgroundColor = temp
        CheckSolution()
    }
    @IBAction func Button_Rotate_5(_ sender: Any) {
        let temp = Button_5l.backgroundColor
        Button_5l.backgroundColor = Button_5r.backgroundColor
        Button_5r.backgroundColor = temp
        CheckSolution()
    }
    
}
