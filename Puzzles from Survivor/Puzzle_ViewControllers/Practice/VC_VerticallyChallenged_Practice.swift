//
//  VC_VerticallyChallenged_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/15/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_VerticallyChallenged_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID_VERTCHALLENGED_TIME = "com.score_vertchallenged_time.puzzlesfromsurvivor2"    //Best Time - Fire and Ice
    let LEADERBOARD_ID_VERTCHALLENGED_MOVES = "com.score_vartchallenged_moves.puzzlesfromsurvivor2"  //Fewest Moves - Fire and Ice
    
    var ButtonArray_left: [UIButton] = []
    var ButtonArray_right: [UIButton] = []
    var ImageArray: [UIImageView] = []
    
    var puzzlePieceArray_left: [PuzzlePiece] = []
    var puzzlePieceArray_right: [PuzzlePiece] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ButtonArray_left = [b00, b01, b02, b03, b04, b05, b06, b07, b08, b09, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21]
        ButtonArray_right = [r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21]
        ImageArray = [i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i20, i21]
        
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
    
    struct PuzzlePiece {
        var name = ""
        var isFlipped = false
        var index = -1
        var rotation_degrees = 0
        var sliderValue: Float = 0.5
        var sliderValue_f: Float = 0.5
    }
    
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
    
    func NewGame() {
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        
        var i = 0
        puzzlePieceArray_right.removeAll()
        while i < 22 {
            let piece = PuzzlePiece(name: "blob_green", isFlipped: false, index: -1, rotation_degrees: 0, sliderValue: 0.5, sliderValue_f: 0.5)
            puzzlePieceArray_right.append(piece)
            i += 1
        }
        
        i = 0
        puzzlePieceArray_left.removeAll()
        while i < 22 {
            var numStr = ""
            if i < 10 {
                numStr = "0\(i)"
            }else {
                numStr = "\(i)"
            }
            let piece = PuzzlePiece(name: "vcc\(numStr)", isFlipped: Bool.random(), index: i, rotation_degrees: Int.random(in: 0 ..< 359), sliderValue: 0.5, sliderValue_f: 0.5)
            puzzlePieceArray_left.append(piece)
            i += 1
        }
        puzzlePieceArray_left.shuffle()
        selected_left = -1
        selectedPiece_left = -1
        selected_right = -1
        
        
        updateUI()
        
    }
    
    func updateUI() {
        
        var i = 0
        for button in ButtonArray_left {
            if puzzlePieceArray_left[i].index < 0 {
               button.isHidden = true
            }else {
                button.isHidden = false
                var imgName = "\(puzzlePieceArray_left[i].name)"
                if puzzlePieceArray_left[i].isFlipped {
                    imgName = "\(puzzlePieceArray_left[i].name)_f"
                }
                button.setImage(UIImage(named: imgName), for: .normal)
                if i == selected_left || selected_left == -1 {
                    button.alpha = 1.0
                }else {
                    button.alpha = 0.3
                }
                
                let angle: Float = puzzlePieceArray_left[i].sliderValue * 360.0 + Float(puzzlePieceArray_left[i].rotation_degrees)
                button.transform = CGAffineTransform(rotationAngle: CGFloat((angle * .pi) / 180.0))
            }
            i += 1
        }
        
        i = 0
        for _ in ButtonArray_right {
            var showButton = false
            switch i {
            case 0: showButton = isPlaced(1)
            case 1: showButton = isPlaced(2)
            case 2: showButton = isPlaced(3)
            case 3: showButton = isPlaced(4)
            case 4: showButton = true
            case 5: showButton = isPlaced(4)
            case 6: showButton = isPlaced(4) || isPlaced(7)
            case 7: showButton = true
            case 8: showButton = isPlaced(7)
            case 9: showButton = isPlaced(8)
            case 10: showButton = isPlaced(7)
            case 11: showButton = true
            case 12: showButton = isPlaced(15)
            case 13: showButton = isPlaced(12)
            case 14: showButton = isPlaced(13)
            case 15: showButton = isPlaced(11) || isPlaced(16)
            case 16: showButton = true
            case 17: showButton = isPlaced(19)
            case 18: showButton = isPlaced(17)
            case 19: showButton = true
            case 20: showButton = isPlaced(6)
            case 21: showButton = isPlaced(16)
            default: showButton = false
            }
            canPieceBePlaced(index: i, conditionIsMet: showButton)
            i += 1
        }
        
        i = 0
        for image in ImageArray {
            if puzzlePieceArray_right[i].index >= 0 {
                image.isHidden = false
            }else {
                image.isHidden = true
            }
            i += 1
        }
    }
    
    func canPieceBePlaced(index: Int, conditionIsMet: Bool) {
        if isPlaced(index) {
            ImageArray[index].isHidden = false
            ButtonArray_right[index].isHidden = true
        }else if conditionIsMet {
            ButtonArray_right[index].isHidden = false
            if selected_right == index {
                switch selected_right_color {
                case .red:
                    ButtonArray_right[index].setImage(UIImage(named: "blob_red"), for: .normal)
                case .yellow:
                    ButtonArray_right[index].setImage(UIImage(named: "blob_yellow"), for: .normal)
                case .orange:
                    ButtonArray_right[index].setImage(UIImage(named: "blob_orange"), for: .normal)
                default:
                    ButtonArray_right[index].setImage(UIImage(named: "blob_green"), for: .normal)
                }
            }else {
                ButtonArray_right[index].setImage(UIImage(named: "blob_green"), for: .normal)
            }
            ButtonArray_right[index].alpha = 0.5
        }else {
            ButtonArray_right[index].isHidden = true
        }
        
        Label_MoveCount.text = "\(moveCount)"
    }
    
    func isPlaced(_ index: Int) -> Bool {
        if puzzlePieceArray_right[index].index >= 0 {
            return true
        }
        return false
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_VERTCHALLENGED_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_VERTCHALLENGED_MOVES)
        
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_VerticallyChallenged), leaderBoardID: appDelegate.LEADERBOARD_pcc_VerticallyChallenged)
    }
    
    @objc func incrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.1f", timerCount)
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
    @IBOutlet weak var b16: UIButton!
    @IBOutlet weak var b17: UIButton!
    @IBOutlet weak var b18: UIButton!
    @IBOutlet weak var b19: UIButton!
    @IBOutlet weak var b20: UIButton!
    @IBOutlet weak var b21: UIButton!
    @IBAction func b00(_ sender: Any) {
        leftButtonSelected(index: 0)
    }
    @IBAction func b01(_ sender: Any) {
        leftButtonSelected(index: 1)
    }
    @IBAction func b02(_ sender: Any) {
        leftButtonSelected(index: 2)
    }
    @IBAction func b03(_ sender: Any) {
        leftButtonSelected(index: 3)
    }
    @IBAction func b04(_ sender: Any) {
        leftButtonSelected(index: 4)
    }
    @IBAction func b05(_ sender: Any) {
        leftButtonSelected(index: 5)
    }
    @IBAction func b06(_ sender: Any) {
        leftButtonSelected(index: 6)
    }
    @IBAction func b07(_ sender: Any) {
        leftButtonSelected(index: 7)
    }
    @IBAction func b08(_ sender: Any) {
        leftButtonSelected(index: 8)
    }
    @IBAction func b09(_ sender: Any) {
        leftButtonSelected(index: 9)
    }
    @IBAction func b10(_ sender: Any) {
        leftButtonSelected(index: 10)
    }
    @IBAction func b11(_ sender: Any) {
        leftButtonSelected(index: 11)
    }
    @IBAction func b12(_ sender: Any) {
        leftButtonSelected(index: 12)
    }
    @IBAction func b13(_ sender: Any) {
        leftButtonSelected(index: 13)
    }
    @IBAction func b14(_ sender: Any) {
        leftButtonSelected(index: 14)
    }
    @IBAction func b15(_ sender: Any) {
        leftButtonSelected(index: 15)
    }
    @IBAction func b16(_ sender: Any) {
        leftButtonSelected(index: 16)
    }
    @IBAction func b17(_ sender: Any) {
        leftButtonSelected(index: 17)
    }
    @IBAction func b18(_ sender: Any) {
        leftButtonSelected(index: 18)
    }
    @IBAction func b19(_ sender: Any) {
        leftButtonSelected(index: 19)
    }
    @IBAction func b20(_ sender: Any) {
        leftButtonSelected(index: 20)
    }
    @IBAction func b21(_ sender: Any) {
        leftButtonSelected(index: 21)
    }
    
    var selected_left = -1
    var selectedPiece_left = -1
    func leftButtonSelected(index: Int) {
        moveCount += 1
        selected_left = index
        selectedPiece_left = puzzlePieceArray_left[index].index
        selected_right = -1
        selected_right_color = UIColor.green
        slider.value = puzzlePieceArray_left[index].sliderValue
        updateUI()
    }
    
    @IBOutlet weak var i00: UIImageView!
    @IBOutlet weak var i01: UIImageView!
    @IBOutlet weak var i02: UIImageView!
    @IBOutlet weak var i03: UIImageView!
    @IBOutlet weak var i04: UIImageView!
    @IBOutlet weak var i05: UIImageView!
    @IBOutlet weak var i06: UIImageView!
    @IBOutlet weak var i07: UIImageView!
    @IBOutlet weak var i08: UIImageView!
    @IBOutlet weak var i09: UIImageView!
    @IBOutlet weak var i10: UIImageView!
    @IBOutlet weak var i11: UIImageView!
    @IBOutlet weak var i12: UIImageView!
    @IBOutlet weak var i13: UIImageView!
    @IBOutlet weak var i14: UIImageView!
    @IBOutlet weak var i15: UIImageView!
    @IBOutlet weak var i16: UIImageView!
    @IBOutlet weak var i17: UIImageView!
    @IBOutlet weak var i18: UIImageView!
    @IBOutlet weak var i19: UIImageView!
    @IBOutlet weak var i20: UIImageView!
    @IBOutlet weak var i21: UIImageView!
    
    @IBOutlet weak var r00: UIButton!
    @IBOutlet weak var r01: UIButton!
    @IBOutlet weak var r02: UIButton!
    @IBOutlet weak var r03: UIButton!
    @IBOutlet weak var r04: UIButton!
    @IBOutlet weak var r05: UIButton!
    @IBOutlet weak var r06: UIButton!
    @IBOutlet weak var r07: UIButton!
    @IBOutlet weak var r08: UIButton!
    @IBOutlet weak var r09: UIButton!
    @IBOutlet weak var r10: UIButton!
    @IBOutlet weak var r11: UIButton!
    @IBOutlet weak var r12: UIButton!
    @IBOutlet weak var r13: UIButton!
    @IBOutlet weak var r14: UIButton!
    @IBOutlet weak var r15: UIButton!
    @IBOutlet weak var r16: UIButton!
    @IBOutlet weak var r17: UIButton!
    @IBOutlet weak var r18: UIButton!
    @IBOutlet weak var r19: UIButton!
    @IBOutlet weak var r20: UIButton!
    @IBOutlet weak var r21: UIButton!
    
    @IBAction func r00(_ sender: Any) {
        rightButtonSelected(index: 0)
    }
    @IBAction func r01(_ sender: Any) {
        rightButtonSelected(index: 1)
    }
    @IBAction func r02(_ sender: Any) {
        rightButtonSelected(index: 2)
    }
    @IBAction func r03(_ sender: Any) {
        rightButtonSelected(index: 3)
    }
    @IBAction func r04(_ sender: Any) {
        rightButtonSelected(index: 4)
    }
    @IBAction func r05(_ sender: Any) {
        rightButtonSelected(index: 5)
    }
    @IBAction func r06(_ sender: Any) {
        rightButtonSelected(index: 6)
    }
    @IBAction func r07(_ sender: Any) {
        rightButtonSelected(index: 7)
    }
    @IBAction func r08(_ sender: Any) {
        rightButtonSelected(index: 8)
    }
    @IBAction func r09(_ sender: Any) {
        rightButtonSelected(index: 9)
    }
    @IBAction func r10(_ sender: Any) {
        rightButtonSelected(index: 10)
    }
    @IBAction func r11(_ sender: Any) {
        rightButtonSelected(index: 11)
    }
    @IBAction func r12(_ sender: Any) {
        rightButtonSelected(index: 12)
    }
    @IBAction func r13(_ sender: Any) {
        rightButtonSelected(index: 13)
    }
    @IBAction func r14(_ sender: Any) {
        rightButtonSelected(index: 14)
    }
    @IBAction func r15(_ sender: Any) {
        rightButtonSelected(index: 15)
    }
    @IBAction func r16(_ sender: Any) {
        rightButtonSelected(index: 16)
    }
    @IBAction func r17(_ sender: Any) {
        rightButtonSelected(index: 17)
    }
    @IBAction func r18(_ sender: Any) {
        rightButtonSelected(index: 18)
    }
    @IBAction func r19(_ sender: Any) {
        rightButtonSelected(index: 19)
    }
    @IBAction func r20(_ sender: Any) {
        rightButtonSelected(index: 20)
    }
    @IBAction func r21(_ sender: Any) {
        rightButtonSelected(index: 21)
    }
    
    var selected_right = -1
    var selected_right_color = UIColor.green
    func rightButtonSelected(index: Int) {
        moveCount += 1
        selected_right_color = .green
        selected_right = index
        
        var degrees = puzzlePieceArray_left[selected_left].rotation_degrees
        degrees += Int(puzzlePieceArray_left[selected_left].sliderValue * 360.0)
        while degrees > 360 {
            degrees -= 360
        }
        if degrees < 20 || degrees > 340 {
            degrees = 0
        }
        
        if selectedPiece_left == index {
            if puzzlePieceArray_left[selected_left].isFlipped == false && degrees == 0 {
                //this is the correct piece in the correct orientation and not flipped, place the piece
                puzzlePieceArray_right[index] = puzzlePieceArray_left[selected_left]
                puzzlePieceArray_left[selected_left].index = -1
                selected_left = -1
                selectedPiece_left = -1
                moveCount -= 1
                updateUI()
                checkForWin()
            }else if puzzlePieceArray_left[selected_left].isFlipped && degrees != 0 {
                selected_right_color = .orange
                ButtonArray_right[index].setImage(UIImage(named: "blob_orange"), for: .normal)
            }else if puzzlePieceArray_left[selected_left].isFlipped || degrees != 0 {
                selected_right_color = .yellow
                ButtonArray_right[index].setImage(UIImage(named: "blob_yellow"), for: .normal)
            }
            
        }else {
            selected_right_color = .red
            ButtonArray_right[index].setImage(UIImage(named: "blob_red"), for: .normal)
        }
    }
    
    func checkForWin() {
        for piece in puzzlePieceArray_right {
            if piece.index == -1 {
                return
            }
        }
        
        Label_YouWin.text = "You Win!"
        
        appDelegate.puzzlesCompleted += 1
        appDelegate.pcc_VerticallyChallenged += 1
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
            self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_VERTCHALLENGED_TIME)
        }
        alertController.addAction(okAction)
        alertController.addAction(submitScoreAction)
        alertController.addAction(submitScoreAndGoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var slider: UISlider!
    @IBAction func slider(_ sender: UISlider) {
        if selected_left >= 0 {
            let angle = sender.value * 360.0 + Float(puzzlePieceArray_left[selected_left].rotation_degrees)
            ButtonArray_left[selected_left].transform = CGAffineTransform(rotationAngle: CGFloat((angle * .pi) / 180.0))
            puzzlePieceArray_left[selected_left].sliderValue = sender.value
            print("angle: \(angle) sender.value: \(sender.value)")
        }
    }
    @IBAction func slider_touchDown(_ sender: Any) {
        if selected_left >= 0 {
            moveCount += 1
            Label_MoveCount.text = "\(moveCount)"
        }
    }
    
    @IBAction func Button_flipPiece(_ sender: Any) {
        if selected_left >= 0 {
            moveCount += 1
            var angle = slider.value * 360.0 + Float(puzzlePieceArray_left[selected_left].rotation_degrees)
            print("IN angle: \(angle) sender.value: \(slider.value)")
            puzzlePieceArray_left[selected_left].isFlipped = !puzzlePieceArray_left[selected_left].isFlipped
            var sliderValue = slider.value
            sliderValue -= 0.5
            if sliderValue < 0.0 {
                sliderValue += 1.0
            }
            slider.value = sliderValue
            puzzlePieceArray_left[selected_left].sliderValue = slider.value
            angle = slider.value * 360.0 + Float(puzzlePieceArray_left[selected_left].rotation_degrees)
            print("OUT angle: \(angle) sender.value: \(slider.value)")
            updateUI()
        }
    }
    
    
}
