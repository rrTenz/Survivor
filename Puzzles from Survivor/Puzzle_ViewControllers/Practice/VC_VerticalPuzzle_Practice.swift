//
//  VC_VerticalPuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/11/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_VerticalPuzzle_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID_VERTPUZZLE_TIME = "com.score_vertpuzzle_time.puzzlesfromsurvivor"    //Best Time - Vertical Puzzle
    let LEADERBOARD_ID_VERTPUZZLE_MOVES = "com.score_vartpuzzle_moves.puzzlesfromsurvivor"  //Fewest Moves - Vertical Puzzle
    
    struct PuzzlePiece {
        var name = ""
        var isFlipped = false
        var index = -1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonArray_top = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17, t18, t19]
        ButtonArray_bot = [b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19]

        authenticateLocalPlayer()
        Label_YouWin.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NewGame()
    }
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.1
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
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
    
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    var Pieces_top: [PuzzlePiece] = []
    var Pieces_bot: [PuzzlePiece] = []
    var Piece_onDeck: PuzzlePiece = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
    func NewGame() {
        hasWon = false
        
        moveCount = -1
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        var i = 0
        Pieces_top.removeAll()
        while i < 20 {
            let piece = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
            Pieces_top.append(piece)
            i += 1
        }
        
        i = 0
        Pieces_bot.removeAll()
        while i < 20 {
            var numStr = ""
            if i < 10 {
                numStr = "0\(i)"
            }else {
                numStr = "\(i)"
            }
            let piece = PuzzlePiece(name: "p\(numStr)", isFlipped: Bool.random(), index: i)
            Pieces_bot.append(piece)
            i += 1
        }
        Pieces_bot.shuffle()
        
        Piece_onDeck = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
        
        updateUI()
    }
    
    func updateUI() {
        var i = 0
        for button in ButtonArray_top {
            var imgName = "\(Pieces_top[i].name)"
            var alpha: CGFloat = 1.0
            if Pieces_top[i].index >= 0 {
                if Pieces_top[i].isFlipped {
                    imgName = "\(Pieces_top[i].name)_f"
                }
            }else {
                imgName = "blank_green"
                alpha = 0.3
            }
            button.setImage(UIImage(named: imgName), for: .normal)
            button.alpha = alpha
            i += 1
        }
        
        i = 0
        for button in ButtonArray_bot {
            var imgName = "\(Pieces_bot[i].name)"
            if Pieces_bot[i].isFlipped {
                imgName = "\(Pieces_bot[i].name)_f"
            }
            button.setImage(UIImage(named: imgName), for: .normal)
            i += 1
        }
        
        var imgName = "\(Piece_onDeck.name)"
        if Piece_onDeck.isFlipped {
            imgName = "\(Piece_onDeck.name)_f"
        }
        onDeck.setImage(UIImage(named: imgName), for: .normal)
        
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        
        checkForWin()
    }
    
    var hasWon = false
    func checkForWin() {
        if hasWon {
            return
        }
        
        Label_YouWin.text = ""
        var topCount = 0
        for piece in Pieces_top {
            if piece.index >= 0 {
                topCount += 1
            }
        }
        
        if topCount >= 20 { //all of the pieces are up top
            var validCount = 0
            
            //Look for standard solution
            if ( (Pieces_top[0].index == 0 && !Pieces_top[0].isFlipped) || (Pieces_top[0].index == 19 && Pieces_top[0].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(0) value: \(Pieces_top[0].index) flipped: \(Pieces_top[0].isFlipped)")
            }
            if ( (Pieces_top[1].index == 1 && !Pieces_top[1].isFlipped) || (Pieces_top[1].index == 18 && Pieces_top[1].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(1) value: \(Pieces_top[1].index) flipped: \(Pieces_top[1].isFlipped)")
            }
            if ( (Pieces_top[2].index == 2 && !Pieces_top[2].isFlipped) || (Pieces_top[2].index == 17 && Pieces_top[2].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(2) value: \(Pieces_top[2].index) flipped: \(Pieces_top[2].isFlipped)")
            }
            if ( (Pieces_top[3].index == 3 && !Pieces_top[3].isFlipped) || (Pieces_top[3].index == 16 && Pieces_top[3].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(3) value: \(Pieces_top[3].index) flipped: \(Pieces_top[3].isFlipped)")
            }
            if ( (Pieces_top[4].index == 4 && !Pieces_top[4].isFlipped) || (Pieces_top[4].index == 15 && Pieces_top[4].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(4) value: \(Pieces_top[4].index) flipped: \(Pieces_top[4].isFlipped)")
            }
            if ( (Pieces_top[5].index == 5 && !Pieces_top[5].isFlipped) || (Pieces_top[5].index == 14 && Pieces_top[5].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(5) value: \(Pieces_top[5].index) flipped: \(Pieces_top[5].isFlipped)")
            }
            if ( (Pieces_top[6].index == 6 && !Pieces_top[6].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(6) value: \(Pieces_top[6].index) flipped: \(Pieces_top[6].isFlipped)")
            }
            if ( (Pieces_top[7].index == 7 && !Pieces_top[7].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(7) value: \(Pieces_top[7].index) flipped: \(Pieces_top[7].isFlipped)")
            }
            if ( (Pieces_top[8].index == 8 && !Pieces_top[8].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(8) value: \(Pieces_top[8].index) flipped: \(Pieces_top[8].isFlipped)")
            }
            if ( (Pieces_top[9].index == 9 && !Pieces_top[9].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(9) value: \(Pieces_top[9].index) flipped: \(Pieces_top[9].isFlipped)")
            }
            if ( (Pieces_top[10].index == 10 && !Pieces_top[10].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(10) value: \(Pieces_top[10].index) flipped: \(Pieces_top[10].isFlipped)")
            }
            if ( (Pieces_top[11].index == 11 && !Pieces_top[11].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(11) value: \(Pieces_top[11].index) flipped: \(Pieces_top[11].isFlipped)")
            }
            if ( (Pieces_top[12].index == 12 && !Pieces_top[12].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(12) value: \(Pieces_top[12].index) flipped: \(Pieces_top[12].isFlipped)")
            }
            if ( (Pieces_top[13].index == 13 && !Pieces_top[13].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(13) value: \(Pieces_top[13].index) flipped: \(Pieces_top[13].isFlipped)")
            }
            if ( (Pieces_top[14].index == 14 && !Pieces_top[14].isFlipped) || (Pieces_top[14].index == 5 && Pieces_top[14].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(14) value: \(Pieces_top[14].index) flipped: \(Pieces_top[14].isFlipped)")
            }
            if ( (Pieces_top[15].index == 15 && !Pieces_top[15].isFlipped) || (Pieces_top[15].index == 4 && Pieces_top[15].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(15) value: \(Pieces_top[15].index) flipped: \(Pieces_top[15].isFlipped)")
            }
            if ( (Pieces_top[16].index == 16 && !Pieces_top[16].isFlipped) || (Pieces_top[16].index == 3 && Pieces_top[16].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(16) value: \(Pieces_top[16].index) flipped: \(Pieces_top[16].isFlipped)")
            }
            if ( (Pieces_top[17].index == 17 && !Pieces_top[17].isFlipped) || (Pieces_top[17].index == 2 && Pieces_top[17].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(17) value: \(Pieces_top[17].index) flipped: \(Pieces_top[17].isFlipped)")
            }
            if ( (Pieces_top[18].index == 18 && !Pieces_top[18].isFlipped) || (Pieces_top[18].index == 1 && Pieces_top[18].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(18) value: \(Pieces_top[18].index) flipped: \(Pieces_top[18].isFlipped)")
            }
            if ( (Pieces_top[19].index == 19 && !Pieces_top[19].isFlipped) || (Pieces_top[19].index == 0 && Pieces_top[19].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(19) value: \(Pieces_top[19].index) flipped: \(Pieces_top[19].isFlipped)")
            }
            if validCount == 20 {
                hasWon = true
            }
            
            validCount = 0
            
            //Look for reverse solution
            if ( (Pieces_top[19].index == 0 && Pieces_top[19].isFlipped) || (Pieces_top[19].index == 19 && !Pieces_top[19].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(19) value: \(Pieces_top[19].index) flipped: \(Pieces_top[19].isFlipped)")
            }
            if ( (Pieces_top[18].index == 1 && Pieces_top[18].isFlipped) || (Pieces_top[18].index == 18 && !Pieces_top[18].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(18) value: \(Pieces_top[18].index) flipped: \(Pieces_top[18].isFlipped)")
            }
            if ( (Pieces_top[17].index == 2 && Pieces_top[17].isFlipped) || (Pieces_top[17].index == 17 && !Pieces_top[17].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(17) value: \(Pieces_top[17].index) flipped: \(Pieces_top[17].isFlipped)")
            }
            if ( (Pieces_top[16].index == 3 && Pieces_top[16].isFlipped) || (Pieces_top[16].index == 16 && !Pieces_top[16].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(16) value: \(Pieces_top[16].index) flipped: \(Pieces_top[16].isFlipped)")
            }
            if ( (Pieces_top[15].index == 4 && Pieces_top[15].isFlipped) || (Pieces_top[15].index == 15 && !Pieces_top[15].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(15) value: \(Pieces_top[15].index) flipped: \(Pieces_top[15].isFlipped)")
            }
            if ( (Pieces_top[14].index == 5 && Pieces_top[14].isFlipped) || (Pieces_top[14].index == 14 && !Pieces_top[14].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(14) value: \(Pieces_top[14].index) flipped: \(Pieces_top[14].isFlipped)")
            }
            if ( (Pieces_top[13].index == 6 && Pieces_top[13].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(13) value: \(Pieces_top[13].index) flipped: \(Pieces_top[13].isFlipped)")
            }
            if ( (Pieces_top[12].index == 7 && Pieces_top[12].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(12) value: \(Pieces_top[12].index) flipped: \(Pieces_top[12].isFlipped)")
            }
            if ( (Pieces_top[11].index == 8 && Pieces_top[11].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(11) value: \(Pieces_top[11].index) flipped: \(Pieces_top[11].isFlipped)")
            }
            if ( (Pieces_top[10].index == 9 && Pieces_top[10].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(10) value: \(Pieces_top[10].index) flipped: \(Pieces_top[10].isFlipped)")
            }
            if ( (Pieces_top[9].index == 10 && Pieces_top[9].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(9) value: \(Pieces_top[9].index) flipped: \(Pieces_top[9].isFlipped)")
            }
            if ( (Pieces_top[8].index == 11 && Pieces_top[8].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(8) value: \(Pieces_top[8].index) flipped: \(Pieces_top[8].isFlipped)")
            }
            if ( (Pieces_top[7].index == 12 && Pieces_top[7].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(7) value: \(Pieces_top[7].index) flipped: \(Pieces_top[7].isFlipped)")
            }
            if ( (Pieces_top[6].index == 13 && Pieces_top[6].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(6) value: \(Pieces_top[6].index) flipped: \(Pieces_top[6].isFlipped)")
            }
            if ( (Pieces_top[5].index == 14 && Pieces_top[5].isFlipped) || (Pieces_top[5].index == 5 && !Pieces_top[5].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(5) value: \(Pieces_top[5].index) flipped: \(Pieces_top[5].isFlipped)")
            }
            if ( (Pieces_top[4].index == 15 && Pieces_top[4].isFlipped) || (Pieces_top[4].index == 4 && !Pieces_top[4].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(4) value: \(Pieces_top[4].index) flipped: \(Pieces_top[4].isFlipped)")
            }
            if ( (Pieces_top[3].index == 16 && Pieces_top[3].isFlipped) || (Pieces_top[3].index == 3 && !Pieces_top[3].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(3) value: \(Pieces_top[3].index) flipped: \(Pieces_top[3].isFlipped)")
            }
            if ( (Pieces_top[2].index == 17 && Pieces_top[2].isFlipped) || (Pieces_top[2].index == 2 && !Pieces_top[2].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(2) value: \(Pieces_top[2].index) flipped: \(Pieces_top[2].isFlipped)")
            }
            if ( (Pieces_top[1].index == 18 && Pieces_top[1].isFlipped) || (Pieces_top[1].index == 1 && !Pieces_top[1].isFlipped) ) {
                validCount += 1
                print("Count: \(validCount) index: \(1) value: \(Pieces_top[1].index) flipped: \(Pieces_top[1].isFlipped)")
            }
            if ( (Pieces_top[0].index == 19 && Pieces_top[0].isFlipped) || (Pieces_top[0].index == 0 && !Pieces_top[0].isFlipped) ) {
                validCount += 1
//                print("Count: \(validCount) index: \(0) value: \(Pieces_top[0].index) flipped: \(Pieces_top[0].isFlipped)")
            }
            if validCount == 20 {
                hasWon = true
            }
        }
        
        if hasWon {
            Label_YouWin.text = "You Win!"
            
            timer.invalidate()
            let timeString = String(format: "%.1f", timerCount)
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
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_VERTPUZZLE_TIME)
            }
            alertController.addAction(okAction)
            alertController.addAction(submitScoreAction)
            alertController.addAction(submitScoreAndGoAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_VERTPUZZLE_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_VERTPUZZLE_MOVES)
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.1f", timerCount)
    }
    
    @IBOutlet weak var t0: UIButton!
    @IBOutlet weak var t1: UIButton!
    @IBOutlet weak var t2: UIButton!
    @IBOutlet weak var t3: UIButton!
    @IBOutlet weak var t4: UIButton!
    @IBOutlet weak var t5: UIButton!
    @IBOutlet weak var t6: UIButton!
    @IBOutlet weak var t7: UIButton!
    @IBOutlet weak var t8: UIButton!
    @IBOutlet weak var t9: UIButton!
    @IBOutlet weak var t10: UIButton!
    @IBOutlet weak var t11: UIButton!
    @IBOutlet weak var t12: UIButton!
    @IBOutlet weak var t13: UIButton!
    @IBOutlet weak var t14: UIButton!
    @IBOutlet weak var t15: UIButton!
    @IBOutlet weak var t16: UIButton!
    @IBOutlet weak var t17: UIButton!
    @IBOutlet weak var t18: UIButton!
    @IBOutlet weak var t19: UIButton!
    var ButtonArray_top: [UIButton] = []
    @IBAction func t0(_ sender: Any) {
        PressedTop(index: 0)
    }
    @IBAction func t1(_ sender: Any) {
        PressedTop(index: 1)
    }
    @IBAction func t2(_ sender: Any) {
        PressedTop(index: 2)
    }
    @IBAction func t3(_ sender: Any) {
        PressedTop(index: 3)
    }
    @IBAction func t4(_ sender: Any) {
        PressedTop(index: 4)
    }
    @IBAction func t5(_ sender: Any) {
        PressedTop(index: 5)
    }
    @IBAction func t6(_ sender: Any) {
        PressedTop(index: 6)
    }
    @IBAction func t7(_ sender: Any) {
        PressedTop(index: 7)
    }
    @IBAction func t8(_ sender: Any) {
        PressedTop(index: 8)
    }
    @IBAction func t9(_ sender: Any) {
        PressedTop(index: 9)
    }
    @IBAction func t10(_ sender: Any) {
        PressedTop(index: 10)
    }
    @IBAction func t11(_ sender: Any) {
        PressedTop(index: 11)
    }
    @IBAction func t12(_ sender: Any) {
        PressedTop(index: 12)
    }
    @IBAction func t13(_ sender: Any) {
        PressedTop(index: 13)
    }
    @IBAction func t14(_ sender: Any) {
        PressedTop(index: 14)
    }
    @IBAction func t15(_ sender: Any) {
        PressedTop(index: 15)
    }
    @IBAction func t16(_ sender: Any) {
        PressedTop(index: 16)
    }
    @IBAction func t17(_ sender: Any) {
        PressedTop(index: 17)
    }
    @IBAction func t18(_ sender: Any) {
        PressedTop(index: 18)
    }
    @IBAction func t19(_ sender: Any) {
        PressedTop(index: 19)
    }
    
    @IBOutlet weak var b0: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b13: UIButton!
    @IBOutlet weak var b14: UIButton!
    @IBOutlet weak var b15: UIButton!
    @IBOutlet weak var b16: UIButton!
    @IBOutlet weak var b17: UIButton!
    @IBOutlet weak var b18: UIButton!
    @IBOutlet weak var b19: UIButton!
    var ButtonArray_bot: [UIButton] = []
    @IBAction func b0(_ sender: Any) {
        PressedBot(index: 0)
    }
    @IBAction func b1(_ sender: Any) {
        PressedBot(index: 1)
    }
    @IBAction func b2(_ sender: Any) {
        PressedBot(index: 2)
    }
    @IBAction func b3(_ sender: Any) {
        PressedBot(index: 3)
    }
    @IBAction func b4(_ sender: Any) {
        PressedBot(index: 4)
    }
    @IBAction func b5(_ sender: Any) {
        PressedBot(index: 5)
    }
    @IBAction func b6(_ sender: Any) {
        PressedBot(index: 6)
    }
    @IBAction func b7(_ sender: Any) {
        PressedBot(index: 7)
    }
    @IBAction func b8(_ sender: Any) {
        PressedBot(index: 8)
    }
    @IBAction func b9(_ sender: Any) {
        PressedBot(index: 9)
    }
    @IBAction func b10(_ sender: Any) {
        PressedBot(index: 10)
    }
    @IBAction func b11(_ sender: Any) {
        PressedBot(index: 11)
    }
    @IBAction func b12(_ sender: Any) {
        PressedBot(index: 12)
    }
    @IBAction func b13(_ sender: Any) {
        PressedBot(index: 13)
    }
    @IBAction func b14(_ sender: Any) {
        PressedBot(index: 14)
    }
    @IBAction func b15(_ sender: Any) {
        PressedBot(index: 15)
    }
    @IBAction func b16(_ sender: Any) {
        PressedBot(index: 16)
    }
    @IBAction func b17(_ sender: Any) {
        PressedBot(index: 17)
    }
    @IBAction func b18(_ sender: Any) {
        PressedBot(index: 18)
    }
    @IBAction func b19(_ sender: Any) {
        PressedBot(index: 19)
    }
    
    @IBAction func f0(_ sender: Any) {
        flip(index: 0)
    }
    @IBAction func f1(_ sender: Any) {
        flip(index: 1)
    }
    @IBAction func f2(_ sender: Any) {
        flip(index: 2)
    }
    @IBAction func f3(_ sender: Any) {
        flip(index: 3)
    }
    @IBAction func f4(_ sender: Any) {
        flip(index: 4)
    }
    @IBAction func f5(_ sender: Any) {
        flip(index: 5)
    }
    @IBAction func f6(_ sender: Any) {
        flip(index: 6)
    }
    @IBAction func f7(_ sender: Any) {
        flip(index: 7)
    }
    @IBAction func f8(_ sender: Any) {
        flip(index: 8)
    }
    @IBAction func f9(_ sender: Any) {
        flip(index: 9)
    }
    @IBAction func f10(_ sender: Any) {
        flip(index: 10)
    }
    @IBAction func f11(_ sender: Any) {
        flip(index: 11)
    }
    @IBAction func f12(_ sender: Any) {
        flip(index: 12)
    }
    @IBAction func f13(_ sender: Any) {
        flip(index: 13)
    }
    @IBAction func f14(_ sender: Any) {
        flip(index: 14)
    }
    @IBAction func f15(_ sender: Any) {
        flip(index: 15)
    }
    @IBAction func f16(_ sender: Any) {
        flip(index: 16)
    }
    @IBAction func f17(_ sender: Any) {
        flip(index: 17)
    }
    @IBAction func f18(_ sender: Any) {
        flip(index: 18)
    }
    @IBAction func f19(_ sender: Any) {
        flip(index: 19)
    }
    
    func flip(index: Int) {
        Pieces_bot[index].isFlipped = !Pieces_bot[index].isFlipped
        updateUI()
    }
    
    func PressedTop(index: Int) {
        
        if Pieces_top[index].index >= 0 {   //If there is already a piece in this top spot, move the onDeck piece to the bottom, and the top piece to onDeck
            //Put onDeck piece back on bottom
            if Piece_onDeck.index >= 0 {
                var i = 0
                var found = false
                for button in Pieces_bot {
                    if button.index == -1 {
                        found = true
                        break
                    }
                    i += 1
                }
                if found {
                    Pieces_bot[i] = Piece_onDeck
                }
            }
            
            //Put top piece back into onDeck
            Piece_onDeck = Pieces_top[index]
            Pieces_top[index] = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
            
        }else {                             //Place the piece from onDeck to top
            Pieces_top[index] = Piece_onDeck
            Piece_onDeck = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
        }
        
        updateUI()
    }
    
    func PressedBot(index: Int) {
        
        let tempPiece = Piece_onDeck        //save onDeck piece
        
        Piece_onDeck = Pieces_bot[index]    //Move bottom piece to onDeck
        
        Pieces_bot[index] = tempPiece       //Move saved piece to bottom
        
        updateUI()
    }
    
    @IBOutlet weak var onDeck: UIButton!
    @IBAction func onDeck(_ sender: Any) {
        
        //Put onDeck piece back on bottom
        if Piece_onDeck.index >= 0 {
            var i = 0
            var found = false
            for button in Pieces_bot {
                if button.index == -1 {
                    found = true
                    break
                }
                i += 1
            }
            if found {
                Pieces_bot[i] = Piece_onDeck
            }
            Piece_onDeck = PuzzlePiece(name: "transparent", isFlipped: false, index: -1)
        }
        
        updateUI()
    }
    @IBAction func onDeck_flip(_ sender: Any) {
        Piece_onDeck.isFlipped = !Piece_onDeck.isFlipped
        updateUI()
    }
    
    
    
}
