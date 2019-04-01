//
//  VC_Matchbox25_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 11/12/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_Matchbox25_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_MATCHBOX25_TIME = "com.score_matchbox25_time.puzzlesfromsurvivor"    //Best Time - Matchbox 25
    let LEADERBOARD_ID_MATCHBOX25_MOVES = "com.score_matchbox25_moves.puzzlesfromsurvivor"  //Fewest Moves - Matchbox 25    
    
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    var gameViewWidth: CGFloat = 0.0
    var blockWidth: CGFloat = 0.0
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.01
    
    @IBOutlet weak var View_Top: UIView!
    @IBOutlet weak var View_Bottom_0: UIView!
    @IBOutlet weak var View_Bottom_1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewGame()
        
        authenticateLocalPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.gameViewWidth = self.gameView.frame.size.height
        self.blockWidth = gameViewWidth / 6        
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
        
        View_Top.isHidden = true
        View_Bottom_0.isHidden = true
        View_Bottom_1.isHidden = true
        
        top = ""
        col_0 = ["25", "22", "20", "8", "11"]
        col_1 = ["12", "23", "13", "15", "3"]
        col_2 = ["6", "17", "21", "7", "16"]
        col_3 = ["4", "18", "14", "9", "10"]
        col_4 = ["1", "19", "2", "5", "24"]
        bottom_0 = ""
        bottom_1 = ""
        updateSquares()
    }
    
    var top = ""
    var col_0 = ["25", "22", "20", "8", "11"]
    var col_1 = ["12", "23", "13", "15", "3"]
    var col_2 = ["6", "17", "21", "7", "16"]
    var col_3 = ["4", "18", "14", "9", "10"]
    var col_4 = ["1", "19", "2", "5", "24"]
    var bottom_0 = ""
    var bottom_1 = ""
    
    func updateSquares() {
        Label_0.text = "\(top)"
        
        Label_1.text = "\(col_0[0])"
        Label_2.text = "\(col_1[0])"
        Label_3.text = "\(col_2[0])"
        Label_4.text = "\(col_3[0])"
        Label_5.text = "\(col_4[0])"
        
        Label_6.text = "\(col_0[1])"
        Label_7.text = "\(col_1[1])"
        Label_8.text = "\(col_2[1])"
        Label_9.text = "\(col_3[1])"
        Label_10.text = "\(col_4[1])"
        
        Label_11.text = "\(col_0[2])"
        Label_12.text = "\(col_1[2])"
        Label_13.text = "\(col_2[2])"
        Label_14.text = "\(col_3[2])"
        Label_15.text = "\(col_4[2])"
        
        Label_16.text = "\(col_0[3])"
        Label_17.text = "\(col_1[3])"
        Label_18.text = "\(col_2[3])"
        Label_19.text = "\(col_3[3])"
        Label_20.text = "\(col_4[3])"
        
        Label_21.text = "\(col_0[4])"
        Label_22.text = "\(col_1[4])"
        Label_23.text = "\(col_2[4])"
        Label_24.text = "\(col_3[4])"
        Label_25.text = "\(col_4[4])"

        Label_26.text = "\(bottom_0)"
        Label_27.text = "\(bottom_1)"
        
        if Label_0.text == "" {
            View_Top.isHidden = true
        }else {
            View_Top.isHidden = false            
        }
        
        if Label_26.text == "" {
            View_Bottom_0.isHidden = true
        }else {
            View_Bottom_0.isHidden = false
        }
        
        if Label_27.text == "" {
            View_Bottom_1.isHidden = true
        }else {
            View_Bottom_1.isHidden = false
        }
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
    
    func CheckSolution() {
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        
        if top == "" &&
            "1" == col_0[0] && "2" == col_1[0] && "3" == col_2[0] && "4" == col_3[0] && "5" == col_4[0] &&
            "6" == col_0[1] && "7" == col_1[1] && "8" == col_2[1] && "9" == col_3[1] && "10" == col_4[1] &&
            "11" == col_0[2] && "12" == col_1[2] && "13" == col_2[2] && "14" == col_3[2] && "15" == col_4[2] &&
            "16" == col_0[3] && "17" == col_1[3] && "18" == col_2[3] && "19" == col_3[3] && "20" == col_4[3] &&
            "21" == col_0[4] && "22" == col_1[4] && "23" == col_2[4] && "24" == col_3[4] && "25" == col_4[4] &&
            bottom_0 == "" && bottom_1 == "" {
        
            print("yup")
            
            timerStarted = false
            timer.invalidate()
            
            appDelegate.puzzlesCompleted += 1
            appDelegate.pcc_Matchbox25 += 1
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
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_MATCHBOX25_TIME)
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
        self.submitScoreToGC(score: Int(self.timerCount * 100), leaderBoardID: self.LEADERBOARD_ID_MATCHBOX25_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_MATCHBOX25_MOVES)
    }
    
    @IBOutlet weak var Label_0: UILabel!
    @IBOutlet weak var Label_1: UILabel!
    @IBOutlet weak var Label_2: UILabel!
    @IBOutlet weak var Label_3: UILabel!
    @IBOutlet weak var Label_4: UILabel!
    @IBOutlet weak var Label_5: UILabel!
    @IBOutlet weak var Label_6: UILabel!
    @IBOutlet weak var Label_7: UILabel!
    @IBOutlet weak var Label_8: UILabel!
    @IBOutlet weak var Label_9: UILabel!
    @IBOutlet weak var Label_10: UILabel!
    @IBOutlet weak var Label_11: UILabel!
    @IBOutlet weak var Label_12: UILabel!
    @IBOutlet weak var Label_13: UILabel!
    @IBOutlet weak var Label_14: UILabel!
    @IBOutlet weak var Label_15: UILabel!
    @IBOutlet weak var Label_16: UILabel!
    @IBOutlet weak var Label_17: UILabel!
    @IBOutlet weak var Label_18: UILabel!
    @IBOutlet weak var Label_19: UILabel!
    @IBOutlet weak var Label_20: UILabel!
    @IBOutlet weak var Label_21: UILabel!
    @IBOutlet weak var Label_22: UILabel!
    @IBOutlet weak var Label_23: UILabel!
    @IBOutlet weak var Label_24: UILabel!
    @IBOutlet weak var Label_25: UILabel!
    @IBOutlet weak var Label_26: UILabel!
    @IBOutlet weak var Label_27: UILabel!
    
    @IBAction func Button_Col_0(_ sender: Any) {
        slide(col: 0)
    }
    @IBAction func Button_Col_1(_ sender: Any) {
        slide(col: 1)
    }
    @IBAction func Button_Col_2(_ sender: Any) {
        slide(col: 2)
    }
    @IBAction func Button_Col_3(_ sender: Any) {
        slide(col: 3)
    }
    @IBAction func Button_Col_4(_ sender: Any) {
        slide(col: 4)
    }
    @IBAction func Button_Swap1(_ sender: Any) {
        swapTopAndBottom(bottom: 0)
    }
    @IBAction func Button_Swap2(_ sender: Any) {
        swapTopAndBottom(bottom: 0)
    }
    @IBAction func Button_Swap3(_ sender: Any) {
        swapTopAndBottom(bottom: 1)
    }
    func swapTopAndBottom(bottom: Int) {
        if bottom == 0 {
            let temp = bottom_0
            bottom_0 = top
            top = temp
        }else if bottom == 1 {
            let temp = bottom_1
            bottom_1 = top
            top = temp
        }
        updateSquares()
    }
    
    
    func slide(col: Int) {
        let temp_0 = bottom_0
        //let temp_1 = bottom_1
        var foundEmpty = false
        var tempArray = ["", "", "", "", ""]
        
        switch col {
        case 0:
            tempArray = col_0
        case 1:
            tempArray = col_1
        case 2:
            tempArray = col_2
        case 3:
            tempArray = col_3
        case 4:
            tempArray = col_4
        default:
            print("oops")
        }
        
        var i = 4
        while foundEmpty == false && i >= 0 && top != "" {
            if tempArray[i] == "" {
                tempArray[i] = top
                top = ""
                foundEmpty = true
            }
            i -= 1
        }
        if foundEmpty == false {
            i = 4
            bottom_0 = bottom_1
            bottom_1 = tempArray[4]
            for _ in 0..<4 {
                tempArray[i] = tempArray[i - 1]
                i -= 1
            }
            tempArray[0] = top
        }
        
        switch col {
        case 0:
            col_0 = tempArray
        case 1:
            col_1 = tempArray
        case 2:
            col_2 = tempArray
        case 3:
            col_3 = tempArray
        case 4:
            col_4 = tempArray
        default:
            print("oops")
        }
        
        if foundEmpty == false {
            top = temp_0
        }
        
        updateSquares()
        moveCount += 1
        
        CheckSolution()
    }
}
