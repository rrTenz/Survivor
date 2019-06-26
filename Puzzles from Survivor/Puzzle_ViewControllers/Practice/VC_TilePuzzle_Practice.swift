//
//  VC_TilePuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 6/24/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_TilePuzzle_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID_TILEPUZZLE_TIME = "com.score_tilepuzzle_time.puzzlesfromsurvivor2"    //Best Time - Tile Puzzle
    let LEADERBOARD_ID_TILEPUZZLE_MOVES = "com.score_tilepuzzle_moves.puzzlesfromsurvivor2"  //Fewest Moves - Tile Puzzle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonArray_left = [d00, d01, d02, d03, d04, d05, d06, d07, d08, d09, d10, d11, d12, d13, d14, d15]
        ButtonArray_right = [b00, b01, b02, b03, b04, b05, b06, b07, b08, b09, b10, b11, b12, b13, b14, b15]

        authenticateLocalPlayer()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        NewGame()
    }
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.1
    var didWin = false
    
    var ButtonArray_left: [UIButton] = []
    var ButtonArray_right: [UIButton] = []
    
    var puzzlePieceArray_left: [PuzzlePiece] = []
    var puzzlePieceArray_right: [PuzzlePiece] = []
    
    struct PuzzlePiece {
        var name = ""
        var index = -1
        var rotation_index = 0    //0=0, 1=90, 2=180, 3=270
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    
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
    
    
    var selected_left = -1
    var selected_right = -1
    var selected_right_prev = -1
    let BLANK_SQUARE = "transparent_green_square"
    let WHITE = 0
    let YELLOW = 1
    let ORANGE = 2
    let BLACK = 3
    func NewGame() {
        didWin = false
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        var i = 0
        puzzlePieceArray_right.removeAll()
        while i < 16 {
            let piece = PuzzlePiece(name: BLANK_SQUARE, index: -1, rotation_index: 0)
            puzzlePieceArray_right.append(piece)
            i += 1
        }
        
        i = 0
        puzzlePieceArray_left.removeAll()
        while i < 16 {
            var numStr = ""
            if i < 10 {
                numStr = "0\(i)"
            }else {
                numStr = "\(i)"
            }
            let piece = PuzzlePiece(name: "ColorTiles_\(numStr)", index: i, rotation_index: Int.random(in: 0 ..< 3))
            puzzlePieceArray_left.append(piece)
            i += 1
        }
        puzzlePieceArray_left.shuffle()
        selected_left = -1
        selected_right = -1
        
        updateUI()
    }
    
    func getFinalColorArray(index: Int) -> [Int] {
        var colorArray = [0, 0, 0, 0]   //top, right, bottom, left
        switch(index) {
        case 0:
            colorArray = [ORANGE, WHITE, WHITE, YELLOW]
        case 1:
            colorArray = [YELLOW, ORANGE, ORANGE, WHITE]
        case 2:
            colorArray = [YELLOW, BLACK, BLACK, ORANGE]
        case 3:
            colorArray = [ORANGE, YELLOW, BLACK, BLACK]
        case 4:
            colorArray = [WHITE, ORANGE, ORANGE, WHITE]
        case 5:
            colorArray = [ORANGE, BLACK, BLACK, ORANGE]
        case 6:
            colorArray = [BLACK, ORANGE, WHITE, BLACK]
        case 7:
            colorArray = [BLACK, BLACK, ORANGE, ORANGE]
        case 8:
            colorArray = [ORANGE, ORANGE, WHITE, WHITE]
        case 9:
            colorArray = [BLACK, WHITE, WHITE, ORANGE]
        case 10:
            colorArray = [WHITE, ORANGE, ORANGE, WHITE]
        case 11:
            colorArray = [ORANGE, BLACK, BLACK, ORANGE]
        case 12:
            colorArray = [WHITE, WHITE, ORANGE, YELLOW]
        case 13:
            colorArray = [WHITE, ORANGE, YELLOW, WHITE]
        case 14:
            colorArray = [ORANGE, BLACK, YELLOW, ORANGE]
        case 15:
            colorArray = [BLACK, YELLOW, ORANGE, BLACK]
        default:
            print("bad index !!!!!!!!!!!!!!!!!!!!!!!")
            colorArray = [0, 0, 0, 0]
        }
        return colorArray
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.1f", timerCount)
    }
    
    func updateUI() {
        
        var i = 0
        for button in ButtonArray_left {
            button.isHidden = false
            button.setImage(UIImage(named: "\(puzzlePieceArray_left[i].name)"), for: .normal)
            if didWin {
                button.isHidden = true
            }
            if i == selected_left || selected_left == -1 {
                button.alpha = 1.0
            }else {
                button.alpha = 0.3
            }
            
            let angle = Float(puzzlePieceArray_left[i].rotation_index) * 90
            var animationDuration = 0.0
            if animateRotation {
                animationDuration = 0.25
            }
            UIView.animate(withDuration: animationDuration, animations: {
                button.transform = CGAffineTransform(rotationAngle: CGFloat((angle * .pi) / 180.0))
            })
            i += 1
        }
        
        i = 0
        for button in ButtonArray_right {
            button.isHidden = false
            button.setImage(UIImage(named: "\(puzzlePieceArray_right[i].name)"), for: .normal)
            if i == selected_right || selected_right == -1 || didWin {
                button.alpha = 1.0
            }else {
                button.alpha = 0.3
            }
            
            let angle = Float(puzzlePieceArray_right[i].rotation_index) * 90
            var animationDuration = 0.0
            if animateRotation {
                animationDuration = 0.25
            }
            UIView.animate(withDuration: animationDuration, animations: {
                button.transform = CGAffineTransform(rotationAngle: CGFloat((angle * .pi) / 180.0))
            })
            i += 1
        }
        
        animateRotation = false
        Label_MoveCount.text = "\(moveCount)"
        
        checkForWin()
        
    }
    
    func checkForWin() {
        if didWin == false {
            var piecesInPlace = 0
            for piece in puzzlePieceArray_right {
                if piece.index >= 0 {
                    piecesInPlace += 1
                }
            }
            
            if piecesInPlace == 16 {   //all 16 pieces are in place
                var i = 0
                for piece in puzzlePieceArray_right {
                    var pieceColorArray = rotateColorArray(colorArray: getFinalColorArray(index: piece.index), rotateCount: piece.rotation_index)
                    let expectedColorArray = getFinalColorArray(index: i)
                    if pieceColorArray[0] == expectedColorArray[0] &&
                        pieceColorArray[1] == expectedColorArray[1] &&
                        pieceColorArray[2] == expectedColorArray[2] &&
                        pieceColorArray[3] == expectedColorArray[3] {
                        
                    }else {
                        print("Incorrect solution")
                        break
                    }
                    
                    i += 1
                    if i == 16 {
                        didWin = true
                        print("You Win!!!")
                        updateUI()
                        
                        appDelegate.puzzlesCompleted += 1
                        appDelegate.pcc_TilePuzzle += 1
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
                            self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_TILEPUZZLE_TIME)
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(submitScoreAction)
                        alertController.addAction(submitScoreAndGoAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func rotateColorArray(colorArray: [Int], rotateCount: Int) -> [Int]{
        var rotations = rotateCount % 4
        var colorArray_local = colorArray
        while rotations > 0 {
            let temp = colorArray_local[3]
            colorArray_local[3] = colorArray_local[2]
            colorArray_local[2] = colorArray_local[1]
            colorArray_local[1] = colorArray_local[0]
            colorArray_local[0] = temp
            
            rotations -= 1
        }
        
        return colorArray_local
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_TILEPUZZLE_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_TILEPUZZLE_MOVES)
        
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_TilePuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_TilePuzzle)
    }
    
    
    @IBOutlet weak var d00: UIButton!
    @IBOutlet weak var d01: UIButton!
    @IBOutlet weak var d02: UIButton!
    @IBOutlet weak var d03: UIButton!
    @IBOutlet weak var d04: UIButton!
    @IBOutlet weak var d05: UIButton!
    @IBOutlet weak var d06: UIButton!
    @IBOutlet weak var d07: UIButton!
    @IBOutlet weak var d08: UIButton!
    @IBOutlet weak var d09: UIButton!
    @IBOutlet weak var d10: UIButton!
    @IBOutlet weak var d11: UIButton!
    @IBOutlet weak var d12: UIButton!
    @IBOutlet weak var d13: UIButton!
    @IBOutlet weak var d14: UIButton!
    @IBOutlet weak var d15: UIButton!
    @IBAction func d00(_ sender: Any) {
        pressLeft(index: 0)
    }
    @IBAction func d01(_ sender: Any) {
        pressLeft(index: 1)
    }
    @IBAction func d02(_ sender: Any) {
        pressLeft(index: 2)
    }
    @IBAction func d03(_ sender: Any) {
        pressLeft(index: 3)
    }
    @IBAction func d04(_ sender: Any) {
        pressLeft(index: 4)
    }
    @IBAction func d05(_ sender: Any) {
        pressLeft(index: 5)
    }
    @IBAction func d06(_ sender: Any) {
        pressLeft(index: 6)
    }
    @IBAction func d07(_ sender: Any) {
        pressLeft(index: 7)
    }
    @IBAction func d08(_ sender: Any) {
        pressLeft(index: 8)
    }
    @IBAction func d09(_ sender: Any) {
        pressLeft(index: 9)
    }
    @IBAction func d10(_ sender: Any) {
        pressLeft(index: 10)
    }
    @IBAction func d11(_ sender: Any) {
        pressLeft(index: 11)
    }
    @IBAction func d12(_ sender: Any) {
        pressLeft(index: 12)
    }
    @IBAction func d13(_ sender: Any) {
        pressLeft(index: 13)
    }
    @IBAction func d14(_ sender: Any) {
        pressLeft(index: 14)
    }
    @IBAction func d15(_ sender: Any) {
        pressLeft(index: 15)
    }
    func pressLeft(index: Int) {
        if didWin {
            return
        }
        
        didMovePiece = false
        if puzzlePieceArray_left[index].name == BLANK_SQUARE && selected_left == -1 && selected_right == -1 {
            return
        }
        if index == selected_left {
            RotateSelected()
        }else if selected_left >= 0 && selected_right == -1 {
            moveLeftToLeft(left_to: index, left_from: selected_left)
        }else if selected_left == -1 && selected_right >= 0 {
            moveRightToLeft(rightIndex: selected_right, leftIndex: index)
        }
        
        if didMovePiece {
            selected_left = -1
        }else {
            selected_left = index
        }
        selected_right = -1
        moveCount += 1
        updateUI()
    }
    
    @IBOutlet weak var b00: UIButton!
    @IBOutlet weak var b01: UIButton!
    @IBOutlet weak var b02: UIButton!
    @IBOutlet weak var b03: UIButton!
    @IBOutlet weak var b04: UIButton!
    @IBOutlet weak var b05: UIButton!
    @IBOutlet weak var b06: UIButton!
    @IBOutlet weak var b07: UIButton!
    @IBOutlet weak var b08: UIButton!
    @IBOutlet weak var b09: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b13: UIButton!
    @IBOutlet weak var b14: UIButton!
    @IBOutlet weak var b15: UIButton!
    @IBAction func b00(_ sender: Any) {
        pressRight(index: 0)
    }
    @IBAction func b01(_ sender: Any) {
        pressRight(index: 1)
    }
    @IBAction func b02(_ sender: Any) {
        pressRight(index: 2)
    }
    @IBAction func b03(_ sender: Any) {
        pressRight(index: 3)
    }
    @IBAction func b04(_ sender: Any) {
        pressRight(index: 4)
    }
    @IBAction func b05(_ sender: Any) {
        pressRight(index: 5)
    }
    @IBAction func b06(_ sender: Any) {
        pressRight(index: 6)
    }
    @IBAction func b07(_ sender: Any) {
        pressRight(index: 7)
    }
    @IBAction func b08(_ sender: Any) {
        pressRight(index: 8)
    }
    @IBAction func b09(_ sender: Any) {
        pressRight(index: 9)
    }
    @IBAction func b10(_ sender: Any) {
        pressRight(index: 10)
    }
    @IBAction func b11(_ sender: Any) {
        pressRight(index: 11)
    }
    @IBAction func b12(_ sender: Any) {
        pressRight(index: 12)
    }
    @IBAction func b13(_ sender: Any) {
        pressRight(index: 13)
    }
    @IBAction func b14(_ sender: Any) {
        pressRight(index: 14)
    }
    @IBAction func b15(_ sender: Any) {
        pressRight(index: 15)
    }
    func pressRight(index: Int) {
        if didWin {
            return
        }
        
        didMovePiece = false
        if puzzlePieceArray_right[index].name == BLANK_SQUARE && selected_left == -1 && selected_right == -1 {
            return
        }
        if index == selected_right {
            RotateSelected()
        }else if selected_left >= 0 && selected_right == -1 {
            moveLeftToRight(leftIndex: selected_left, rightIndex: index)
        }else if selected_left == -1 && selected_right >= 0 {
            moveRightToRight(right_to: index, right_from: selected_right)
        }
        
        selected_left = -1
        if didMovePiece {
            selected_right = -1
            selected_right_prev = index
        }else {
            selected_right = index
        }
        moveCount += 1
        updateUI()
    }
    
    var didMovePiece = false
    func moveLeftToRight(leftIndex: Int, rightIndex: Int) {
        if puzzlePieceArray_right[rightIndex].name == BLANK_SQUARE {
            puzzlePieceArray_right[rightIndex].name = puzzlePieceArray_left[leftIndex].name
            puzzlePieceArray_left[leftIndex].name = BLANK_SQUARE
            
            puzzlePieceArray_right[rightIndex].index = puzzlePieceArray_left[leftIndex].index
            puzzlePieceArray_left[leftIndex].index = -1
            
            puzzlePieceArray_right[rightIndex].rotation_index = puzzlePieceArray_left[leftIndex].rotation_index
            puzzlePieceArray_left[leftIndex].rotation_index = 0
            
            didMovePiece = true
        }
    }
    
    func moveRightToLeft(rightIndex: Int, leftIndex: Int) {
        if puzzlePieceArray_left[leftIndex].name == BLANK_SQUARE {
            puzzlePieceArray_left[leftIndex].name = puzzlePieceArray_right[rightIndex].name
            puzzlePieceArray_right[rightIndex].name = BLANK_SQUARE
            
            puzzlePieceArray_left[leftIndex].index = puzzlePieceArray_right[rightIndex].index
            puzzlePieceArray_right[rightIndex].index = -1
            
            puzzlePieceArray_left[leftIndex].rotation_index = puzzlePieceArray_right[rightIndex].rotation_index
            puzzlePieceArray_right[rightIndex].rotation_index = 0
            
            didMovePiece = true
        }
    }
    
    func moveLeftToLeft(left_to: Int, left_from: Int) {
        if puzzlePieceArray_left[left_to].name == BLANK_SQUARE {
            puzzlePieceArray_left[left_to].name = puzzlePieceArray_left[left_from].name
            puzzlePieceArray_left[left_from].name = BLANK_SQUARE
            
            puzzlePieceArray_left[left_to].index = puzzlePieceArray_left[left_from].index
            puzzlePieceArray_left[left_from].index = -1
            
            puzzlePieceArray_left[left_to].rotation_index = puzzlePieceArray_left[left_from].rotation_index
            puzzlePieceArray_left[left_from].rotation_index = 0
            
            didMovePiece = true
        }
    }
    
    func moveRightToRight(right_to: Int, right_from: Int) {
        if puzzlePieceArray_right[right_to].name == BLANK_SQUARE {
            puzzlePieceArray_right[right_to].name = puzzlePieceArray_right[right_from].name
            puzzlePieceArray_right[right_from].name = BLANK_SQUARE
            
            puzzlePieceArray_right[right_to].index = puzzlePieceArray_right[right_from].index
            puzzlePieceArray_right[right_from].index = -1
            
            puzzlePieceArray_right[right_to].rotation_index = puzzlePieceArray_right[right_from].rotation_index
            puzzlePieceArray_right[right_from].rotation_index = 0
            
            didMovePiece = true
        }
    }
    
    @IBAction func RotateTile(_ sender: Any) {
        RotateSelected()
    }
    
    var animateRotation = false
    func RotateSelected() {
        if didWin {
            return
        }
        if selected_left >= 0 {
            puzzlePieceArray_left[selected_left].rotation_index += 1
            if puzzlePieceArray_left[selected_left].rotation_index >= 4 {
                puzzlePieceArray_left[selected_left].rotation_index = 0
            }
            animateRotation = true
        }else {
            if selected_left == -1 && selected_right == -1 && selected_right_prev >= 0 {
                selected_right = selected_right_prev
            }
            if selected_right >= 0 {
                puzzlePieceArray_right[selected_right].rotation_index += 1
                if puzzlePieceArray_right[selected_right].rotation_index >= 4 {
                    puzzlePieceArray_right[selected_right].rotation_index = 0
                }
                animateRotation = true
            }
        }
        moveCount += 1
        
        updateUI()
        
    }
    
}
