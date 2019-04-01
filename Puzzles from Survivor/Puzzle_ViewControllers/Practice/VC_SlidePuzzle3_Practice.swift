//
//  VC_SlidePuzzle3_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/22/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_SlidePuzzle3_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID_SLIDEPUZZLE_3_TIME = "com.score_slidepuzzle3_time.puzzlesfromsurvivor"    //Best Time - 5 Piece Slide Puzzle
    let LEADERBOARD_ID_SLIDEPUZZLE_3_MOVES = "com.score_slidepuzzle3_moves.puzzlesfromsurvivor"  //Fewest Moves - 5 Piece Slide Puzzle

    var buttonMultiArray = [[UIButton]]()
    var occupiedMultiArray = [[Bool]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonArray0 = [b00, b01, b02]
        buttonArray1 = [b10, b11, b12]
        buttonArray2 = [b20, b21, b22]
        buttonArray3 = [b30, b31, b32]
        buttonArray4 = [b40, b41, b42]
        buttonArray = [b00, b01, b02, b10, b11, b12, b20, b21, b22, b30, b31, b32, b40, b41, b42]
        buttonMultiArray.removeAll()
        buttonMultiArray.append(buttonArray0)
        buttonMultiArray.append(buttonArray1)
        buttonMultiArray.append(buttonArray2)
        buttonMultiArray.append(buttonArray3)
        buttonMultiArray.append(buttonArray4)
        
        
        isOccupied_0 = [isOccupied_00, isOccupied_01, isOccupied_02, isOccupied_03]
        isOccupied_1 = [isOccupied_10, isOccupied_11, isOccupied_12, isOccupied_13]
        isOccupied_2 = [isOccupied_20, isOccupied_21, isOccupied_22, isOccupied_23]
        isOccupied_3 = [isOccupied_30, isOccupied_31, isOccupied_32, isOccupied_33]
        isOccupied_4 = [isOccupied_40, isOccupied_41, isOccupied_42, isOccupied_43]
        isOccupied_5 = [isOccupied_50, isOccupied_51, isOccupied_52, isOccupied_53]
        isOccupiedArray = [isOccupied_00, isOccupied_01, isOccupied_02, isOccupied_03, isOccupied_10, isOccupied_11, isOccupied_12, isOccupied_13, isOccupied_20, isOccupied_21, isOccupied_22, isOccupied_23, isOccupied_30, isOccupied_31, isOccupied_32, isOccupied_33, isOccupied_40, isOccupied_41, isOccupied_42, isOccupied_43, isOccupied_50, isOccupied_51, isOccupied_52, isOccupied_53]
        occupiedMultiArray.removeAll()
        occupiedMultiArray.append(isOccupied_0)
        occupiedMultiArray.append(isOccupied_1)
        occupiedMultiArray.append(isOccupied_2)
        occupiedMultiArray.append(isOccupied_3)
        occupiedMultiArray.append(isOccupied_4)
        occupiedMultiArray.append(isOccupied_5)
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(VC_SlidePuzzle3_Practice.do_Left))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(VC_SlidePuzzle3_Practice.do_Right))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        let up = UISwipeGestureRecognizer(target : self, action : #selector(VC_SlidePuzzle3_Practice.do_Up))
        up.direction = .up
        self.view.addGestureRecognizer(up)
        
        let down = UISwipeGestureRecognizer(target : self, action : #selector(VC_SlidePuzzle3_Practice.do_Down))
        down.direction = .down
        self.view.addGestureRecognizer(down)
        
        for button in buttonArray {
            button.isHidden = true
        }
        
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
    
    struct Location {
        var row = -1
        var col = -1
        var o_00 = -1
        var o_01 = -1
        var o_10 = -1
        var o_11 = -1
    }
    
    var topLeft_Loc = Location(row: 0, col: 0, o_00: 0, o_01: 1, o_10: 4, o_11: -1)
    var topRight_Loc = Location(row: 0, col: 2, o_00: 2, o_01: 3, o_10: -1, o_11: 7)
    var botLeft_Loc = Location(row: 2, col: 0, o_00: 8, o_01: -1, o_10: 12, o_11: 13)
    var botRight_Loc = Location(row: 2, col: 2, o_00: -1, o_01: 11, o_10: 14, o_11: 15)
    var middle_Loc = Location(row: 4, col: 1, o_00: 17, o_01: 18, o_10: 21, o_11: 22)
    
    
    func NewGame() {
        youWin = false
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        topLeft_Loc = Location(row: 0, col: 0, o_00: 0, o_01: 1, o_10: 4, o_11: -1)
        topRight_Loc = Location(row: 0, col: 2, o_00: 2, o_01: 3, o_10: -1, o_11: 7)
        botLeft_Loc = Location(row: 2, col: 0, o_00: 8, o_01: -1, o_10: 12, o_11: 13)
        botRight_Loc = Location(row: 2, col: 2, o_00: -1, o_01: 11, o_10: 14, o_11: 15)
        middle_Loc = Location(row: 4, col: 1, o_00: 17, o_01: 18, o_10: 21, o_11: 22)
        
        var i = 0
        for _ in isOccupiedArray {
            isOccupiedArray[i] = false
            i += 1
        }
        isOccupiedArray[0] = true
        isOccupiedArray[1] = true
        isOccupiedArray[2] = true
        isOccupiedArray[3] = true
        isOccupiedArray[4] = true
        isOccupiedArray[7] = true
        isOccupiedArray[8] = true
        isOccupiedArray[11] = true
        isOccupiedArray[12] = true
        isOccupiedArray[13] = true
        isOccupiedArray[14] = true
        isOccupiedArray[15] = true
        isOccupiedArray[17] = true
        isOccupiedArray[18] = true
        isOccupiedArray[21] = true
        isOccupiedArray[22] = true
        
        occupiedMultiArray[0][0] = true
        occupiedMultiArray[0][1] = true
        occupiedMultiArray[0][2] = true
        occupiedMultiArray[0][3] = true
        occupiedMultiArray[1][0] = true
        occupiedMultiArray[1][3] = true
        occupiedMultiArray[2][0] = true
        occupiedMultiArray[2][3] = true
        occupiedMultiArray[3][0] = true
        occupiedMultiArray[3][1] = true
        occupiedMultiArray[3][2] = true
        occupiedMultiArray[3][3] = true
        occupiedMultiArray[4][1] = true
        occupiedMultiArray[4][2] = true
        occupiedMultiArray[5][1] = true
        occupiedMultiArray[5][2] = true
        
        selectedButton_index = -1
        selectedRow = -1
        selectedCol = -1
        
        updateUI()
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.1f", timerCount)
    }
    
    func updateUI() {
        for button in buttonArray {
            button.isHidden = true
            
            if selectedButton_index == -1 {
                button.alpha = 1.0
            }else {
                button.alpha = 0.5
            }
        }
        
        buttonMultiArray[topLeft_Loc.row][topLeft_Loc.col].isHidden = false
        buttonMultiArray[topLeft_Loc.row][topLeft_Loc.col].setImage(UIImage(named: "sp3_topLeft"), for: .normal)
        buttonMultiArray[topRight_Loc.row][topRight_Loc.col].isHidden = false
        buttonMultiArray[topRight_Loc.row][topRight_Loc.col].setImage(UIImage(named: "sp3_topRight"), for: .normal)
        buttonMultiArray[botLeft_Loc.row][botLeft_Loc.col].isHidden = false
        buttonMultiArray[botLeft_Loc.row][botLeft_Loc.col].setImage(UIImage(named: "sp3_bottomLeft"), for: .normal)
        buttonMultiArray[botRight_Loc.row][botRight_Loc.col].isHidden = false
        buttonMultiArray[botRight_Loc.row][botRight_Loc.col].setImage(UIImage(named: "sp3_bottomRight"), for: .normal)
        buttonMultiArray[middle_Loc.row][middle_Loc.col].isHidden = false
        buttonMultiArray[middle_Loc.row][middle_Loc.col].setImage(UIImage(named: "sp3_middle"), for: .normal)
        
        if selectedRow >= 0 && selectedCol >= 0 {
            buttonMultiArray[selectedRow][selectedCol].alpha = 1.0
        }
        
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        
        checkForWin()
    }
    
    var youWin = false
    func checkForWin() {
        if youWin {
            return
        }
        
        if topLeft_Loc.row == 0 && topLeft_Loc.col == 0 &&
            topRight_Loc.row == 0 && topRight_Loc.col == 2 &&
            botLeft_Loc.row == 2 && botLeft_Loc.col == 0 &&
            botRight_Loc.row == 2 && botRight_Loc.col == 2 &&
            middle_Loc.row == 1 && middle_Loc.col == 1 {
            youWin = true
        }else if topLeft_Loc.row == 1 && topLeft_Loc.col == 0 &&
            topRight_Loc.row == 1 && topRight_Loc.col == 2 &&
            botLeft_Loc.row == 3 && botLeft_Loc.col == 0 &&
            botRight_Loc.row == 3 && botRight_Loc.col == 2 &&
            middle_Loc.row == 2 && middle_Loc.col == 1 {
            youWin = true
        }else if topLeft_Loc.row == 2 && topLeft_Loc.col == 0 &&
            topRight_Loc.row == 2 && topRight_Loc.col == 2 &&
            botLeft_Loc.row == 4 && botLeft_Loc.col == 0 &&
            botRight_Loc.row == 4 && botRight_Loc.col == 2 &&
            middle_Loc.row == 3 && middle_Loc.col == 1 {
            youWin = true
        }
        if youWin == false {
            return
        }
        
        selectedButton_index = -1
        moveCount -= 1
        updateUI()
        
        Label_YouWin.text = "You Win!"
        
        appDelegate.puzzlesCompleted += 1
        appDelegate.pcc_SlidePuzzle3 += 1
        Defaults().save_Defaults(updateStreak: true)
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
            self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_SLIDEPUZZLE_3_TIME)
        }
        alertController.addAction(okAction)
        alertController.addAction(submitScoreAction)
        alertController.addAction(submitScoreAndGoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_SLIDEPUZZLE_3_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_SLIDEPUZZLE_3_MOVES)
    }
    
    @IBAction func button_up(_ sender: Any) {
        do_Up()
    }
    @IBAction func button_down(_ sender: Any) {
        do_Down()
    }
    @IBAction func button_left(_ sender: Any) {
        do_Left()
    }
    @IBAction func button_right(_ sender: Any) {
        do_Right()
    }
    
    @objc func do_Up() {
        if selectedButton_index < 0 || selectedRow == 0 || youWin {
            return
        }
        
        var didMove = false
        if selectedRow == topLeft_Loc.row && selectedCol == topLeft_Loc.col {           //Top-Left selected
            if !isOccupiedArray[topLeft_Loc.o_00-4] && !isOccupiedArray[topLeft_Loc.o_01-4] {
                move_topLeft(direction: .Up)
                didMove = true
            }
        }else if selectedRow == topRight_Loc.row && selectedCol == topRight_Loc.col {   //Top-Right selected
            if !isOccupiedArray[topRight_Loc.o_00-4] && !isOccupiedArray[topRight_Loc.o_01-4] {
                move_topRight(direction: .Up)
                didMove = true
            }
        }else if selectedRow == botLeft_Loc.row && selectedCol == botLeft_Loc.col {     //Bottom-Left selected
            if !isOccupiedArray[botLeft_Loc.o_00-4] && !isOccupiedArray[botLeft_Loc.o_11-4] {
                move_bottomLeft(direction: .Up)
                didMove = true
            }
        }else if selectedRow == botRight_Loc.row && selectedCol == botRight_Loc.col {   //Bottom-Right selected
            if !isOccupiedArray[botRight_Loc.o_01-4] && !isOccupiedArray[botRight_Loc.o_10-4] {
                move_bottomRight(direction: .Up)
                didMove = true
            }
        }else if selectedRow == middle_Loc.row && selectedCol == middle_Loc.col {       //Middle selected
            if !isOccupiedArray[middle_Loc.o_00-4] && !isOccupiedArray[middle_Loc.o_01-4] {
                move_Middle(direction: .Up)
                didMove = true
            }
        }
        if didMove {
            selectedRow -= 1
        }
        updateUI()
    }
    
    @objc func do_Down() {
        if selectedButton_index < 0 || selectedRow == 4 || youWin {
            return
        }
        
        var didMove = false
        if selectedRow == topLeft_Loc.row && selectedCol == topLeft_Loc.col {           //Top-Left selected
            if !isOccupiedArray[topLeft_Loc.o_01+4] && !isOccupiedArray[topLeft_Loc.o_10+4] {
                move_topLeft(direction: .Down)
                didMove = true
            }
        }else if selectedRow == topRight_Loc.row && selectedCol == topRight_Loc.col {   //Top-Right selected
            if !isOccupiedArray[topRight_Loc.o_00+4] && !isOccupiedArray[topRight_Loc.o_11+4] {
                move_topRight(direction: .Down)
                didMove = true
            }
        }else if selectedRow == botLeft_Loc.row && selectedCol == botLeft_Loc.col {     //Bottom-Left selected
            if !isOccupiedArray[botLeft_Loc.o_10+4] && !isOccupiedArray[botLeft_Loc.o_11+4] {
                move_bottomLeft(direction: .Down)
                didMove = true
            }
        }else if selectedRow == botRight_Loc.row && selectedCol == botRight_Loc.col {   //Bottom-Right selected
            if !isOccupiedArray[botRight_Loc.o_10+4] && !isOccupiedArray[botRight_Loc.o_11+4] {
                move_bottomRight(direction: .Down)
                didMove = true
            }
        }else if selectedRow == middle_Loc.row && selectedCol == middle_Loc.col {       //Middle selected
            if !isOccupiedArray[middle_Loc.o_10+4] && !isOccupiedArray[middle_Loc.o_11+4] {
                move_Middle(direction: .Down)
                didMove = true
            }
        }
        if didMove {
            selectedRow += 1
        }
        updateUI()
    }
    
    @objc func do_Left() {
        if selectedButton_index < 0 || selectedCol == 0 || youWin {
            return
        }
        
        var didMove = false
        if selectedRow == topLeft_Loc.row && selectedCol == topLeft_Loc.col {           //Top-Left selected
            if !isOccupiedArray[topLeft_Loc.o_00-1] && !isOccupiedArray[topLeft_Loc.o_10-1] {
                move_topLeft(direction: .Left)
                didMove = true
            }
        }else if selectedRow == topRight_Loc.row && selectedCol == topRight_Loc.col {   //Top-Right selected
            if !isOccupiedArray[topRight_Loc.o_00-1] && !isOccupiedArray[topRight_Loc.o_11-1] {
                move_topRight(direction: .Left)
                didMove = true
            }
        }else if selectedRow == botLeft_Loc.row && selectedCol == botLeft_Loc.col {     //Bottom-Left selected
            if !isOccupiedArray[botLeft_Loc.o_00-1] && !isOccupiedArray[botLeft_Loc.o_10-1] {
                move_bottomLeft(direction: .Left)
                didMove = true
            }
        }else if selectedRow == botRight_Loc.row && selectedCol == botRight_Loc.col {   //Bottom-Right selected
            if !isOccupiedArray[botRight_Loc.o_01-1] && !isOccupiedArray[botRight_Loc.o_10-1] {
                move_bottomRight(direction: .Left)
                didMove = true
            }
        }else if selectedRow == middle_Loc.row && selectedCol == middle_Loc.col {       //Middle selected
            if !isOccupiedArray[middle_Loc.o_00-1] && !isOccupiedArray[middle_Loc.o_10-1] {
                move_Middle(direction: .Left)
                didMove = true
            }
        }
        if didMove {
            selectedCol -= 1
        }
        updateUI()
    }
    
    @objc func do_Right() {
        if selectedButton_index < 0 || selectedCol == 2 || youWin {
            return
        }
        
        var didMove = false
        if selectedRow == topLeft_Loc.row && selectedCol == topLeft_Loc.col {           //Top-Left selected
            if !isOccupiedArray[topLeft_Loc.o_01+1] && !isOccupiedArray[topLeft_Loc.o_10+1] {
                move_topLeft(direction: .Right)
                didMove = true
            }
        }else if selectedRow == topRight_Loc.row && selectedCol == topRight_Loc.col {   //Top-Right selected
            if !isOccupiedArray[topRight_Loc.o_01+1] && !isOccupiedArray[topRight_Loc.o_11+1] {
                move_topRight(direction: .Right)
                didMove = true
            }
        }else if selectedRow == botLeft_Loc.row && selectedCol == botLeft_Loc.col {     //Bottom-Left selected
            if !isOccupiedArray[botLeft_Loc.o_00+1] && !isOccupiedArray[botLeft_Loc.o_11+1] {
                move_bottomLeft(direction: .Right)
                didMove = true
            }
        }else if selectedRow == botRight_Loc.row && selectedCol == botRight_Loc.col {   //Bottom-Right selected
            if !isOccupiedArray[botRight_Loc.o_01+1] && !isOccupiedArray[botRight_Loc.o_11+1] {
                move_bottomRight(direction: .Right)
                didMove = true
            }
        }else if selectedRow == middle_Loc.row && selectedCol == middle_Loc.col {       //Middle selected
            if !isOccupiedArray[middle_Loc.o_01+1] && !isOccupiedArray[middle_Loc.o_11+1] {
                move_Middle(direction: .Right)
                didMove = true
            }
        }
        if didMove {
            selectedCol += 1
        }
        updateUI()
    }
    
    enum Direction: Int {
        case Up = -4
        case Down = 4
        case Left = -1
        case Right = 1
    }
    
    func move_topLeft(direction: Direction) {
        isOccupiedArray[topLeft_Loc.o_00] = false
        isOccupiedArray[topLeft_Loc.o_01] = false
        isOccupiedArray[topLeft_Loc.o_10] = false
        topLeft_Loc.o_00 += direction.rawValue
        topLeft_Loc.o_01 += direction.rawValue
        topLeft_Loc.o_10 += direction.rawValue
        isOccupiedArray[topLeft_Loc.o_00] = true
        isOccupiedArray[topLeft_Loc.o_01] = true
        isOccupiedArray[topLeft_Loc.o_10] = true
        switch direction {
        case .Up:
            topLeft_Loc.row -= 1
        case .Down:
            topLeft_Loc.row += 1
        case .Left:
            topLeft_Loc.col -= 1
        case .Right:
            topLeft_Loc.col += 1
        }
    }
    
    func move_topRight(direction: Direction) {
        isOccupiedArray[topRight_Loc.o_00] = false
        isOccupiedArray[topRight_Loc.o_01] = false
        isOccupiedArray[topRight_Loc.o_11] = false
        topRight_Loc.o_00 += direction.rawValue
        topRight_Loc.o_01 += direction.rawValue
        topRight_Loc.o_11 += direction.rawValue
        isOccupiedArray[topRight_Loc.o_00] = true
        isOccupiedArray[topRight_Loc.o_01] = true
        isOccupiedArray[topRight_Loc.o_11] = true
        switch direction {
        case .Up:
            topRight_Loc.row -= 1
        case .Down:
            topRight_Loc.row += 1
        case .Left:
            topRight_Loc.col -= 1
        case .Right:
            topRight_Loc.col += 1
        }
    }
    
    func move_bottomLeft(direction: Direction) {
        isOccupiedArray[botLeft_Loc.o_00] = false
        isOccupiedArray[botLeft_Loc.o_10] = false
        isOccupiedArray[botLeft_Loc.o_11] = false
        botLeft_Loc.o_00 += direction.rawValue
        botLeft_Loc.o_10 += direction.rawValue
        botLeft_Loc.o_11 += direction.rawValue
        isOccupiedArray[botLeft_Loc.o_00] = true
        isOccupiedArray[botLeft_Loc.o_10] = true
        isOccupiedArray[botLeft_Loc.o_11] = true
        switch direction {
        case .Up:
            botLeft_Loc.row -= 1
        case .Down:
            botLeft_Loc.row += 1
        case .Left:
            botLeft_Loc.col -= 1
        case .Right:
            botLeft_Loc.col += 1
        }
    }
    
    func move_bottomRight(direction: Direction) {
        isOccupiedArray[botRight_Loc.o_01] = false
        isOccupiedArray[botRight_Loc.o_10] = false
        isOccupiedArray[botRight_Loc.o_11] = false
        botRight_Loc.o_01 += direction.rawValue
        botRight_Loc.o_10 += direction.rawValue
        botRight_Loc.o_11 += direction.rawValue
        isOccupiedArray[botRight_Loc.o_01] = true
        isOccupiedArray[botRight_Loc.o_10] = true
        isOccupiedArray[botRight_Loc.o_11] = true
        switch direction {
        case .Up:
            botRight_Loc.row -= 1
        case .Down:
            botRight_Loc.row += 1
        case .Left:
            botRight_Loc.col -= 1
        case .Right:
            botRight_Loc.col += 1
        }
    }
    
    func move_Middle(direction: Direction) {
        isOccupiedArray[middle_Loc.o_00] = false
        isOccupiedArray[middle_Loc.o_01] = false
        isOccupiedArray[middle_Loc.o_10] = false
        isOccupiedArray[middle_Loc.o_11] = false
        middle_Loc.o_00 += direction.rawValue
        middle_Loc.o_01 += direction.rawValue
        middle_Loc.o_10 += direction.rawValue
        middle_Loc.o_11 += direction.rawValue
        isOccupiedArray[middle_Loc.o_00] = true
        isOccupiedArray[middle_Loc.o_01] = true
        isOccupiedArray[middle_Loc.o_10] = true
        isOccupiedArray[middle_Loc.o_11] = true
        switch direction {
        case .Up:
            middle_Loc.row -= 1
        case .Down:
            middle_Loc.row += 1
        case .Left:
            middle_Loc.col -= 1
        case .Right:
            middle_Loc.col += 1
        }
    }
    
    var buttonArray0: [UIButton] = []
    var buttonArray1: [UIButton] = []
    var buttonArray2: [UIButton] = []
    var buttonArray3: [UIButton] = []
    var buttonArray4: [UIButton] = []
    var buttonArray: [UIButton] = []
    @IBOutlet weak var b00: UIButton!
    @IBOutlet weak var b01: UIButton!
    @IBOutlet weak var b02: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b20: UIButton!
    @IBOutlet weak var b21: UIButton!
    @IBOutlet weak var b22: UIButton!
    @IBOutlet weak var b30: UIButton!
    @IBOutlet weak var b31: UIButton!
    @IBOutlet weak var b32: UIButton!
    @IBOutlet weak var b40: UIButton!
    @IBOutlet weak var b41: UIButton!
    @IBOutlet weak var b42: UIButton!
    
    @IBAction func b00(_ sender: Any) {
        selectButton(index: 0, row: 0, col: 0)
    }
    @IBAction func b01(_ sender: Any) {
        selectButton(index: 1, row: 0, col: 1)
    }
    @IBAction func b02(_ sender: Any) {
        selectButton(index: 2, row: 0, col: 2)
    }
    @IBAction func b10(_ sender: Any) {
        selectButton(index: 3, row: 1, col: 0)
    }
    @IBAction func b11(_ sender: Any) {
        selectButton(index: 4, row: 1, col: 1)
    }
    @IBAction func b12(_ sender: Any) {
        selectButton(index: 5, row: 1, col: 2)
    }
    @IBAction func b20(_ sender: Any) {
        selectButton(index: 6, row: 2, col: 0)
    }
    @IBAction func b21(_ sender: Any) {
        selectButton(index: 7, row: 2, col: 1)
    }
    @IBAction func b22(_ sender: Any) {
        selectButton(index: 8, row: 2, col: 2)
    }
    @IBAction func b30(_ sender: Any) {
        selectButton(index: 9, row: 3, col: 0)
    }
    @IBAction func b31(_ sender: Any) {
        selectButton(index: 10, row: 3, col: 1)
    }
    @IBAction func b32(_ sender: Any) {
        selectButton(index: 11, row: 3, col: 2)
    }
    @IBAction func b40(_ sender: Any) {
        selectButton(index: 12, row: 4, col: 0)
    }
    @IBAction func b41(_ sender: Any) {
        selectButton(index: 13, row: 4, col: 1)
    }
    @IBAction func b42(_ sender: Any) {
        selectButton(index: 14, row: 4, col: 2)
    }
    
    var selectedButton_index = -1
    var selectedRow = -1
    var selectedCol = -1
    func selectButton(index: Int, row: Int, col: Int) {
        selectedButton_index = index
        selectedRow = row
        selectedCol = col
        updateUI()
    }
    
    var isOccupiedArray: [Bool] = []
    var isOccupied_0: [Bool] = []
    var isOccupied_00 = false
    var isOccupied_01 = false
    var isOccupied_02 = false
    var isOccupied_03 = false
    var isOccupied_1: [Bool] = []
    var isOccupied_10 = false
    var isOccupied_11 = false
    var isOccupied_12 = false
    var isOccupied_13 = false
    var isOccupied_2: [Bool] = []
    var isOccupied_20 = false
    var isOccupied_21 = false
    var isOccupied_22 = false
    var isOccupied_23 = false
    var isOccupied_3: [Bool] = []
    var isOccupied_30 = false
    var isOccupied_31 = false
    var isOccupied_32 = false
    var isOccupied_33 = false
    var isOccupied_4: [Bool] = []
    var isOccupied_40 = false
    var isOccupied_41 = false
    var isOccupied_42 = false
    var isOccupied_43 = false
    var isOccupied_5: [Bool] = []
    var isOccupied_50 = false
    var isOccupied_51 = false
    var isOccupied_52 = false
    var isOccupied_53 = false
    
}
