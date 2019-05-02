//
//  VC_SpinPuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 12/11/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_SpinPuzzle_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_SPIN_TIME = "com.score_spin_time.puzzlesfromsurvivor2"    //Best Time - Spin Puzzle
    let LEADERBOARD_ID_SPIN_MOVES = "com.score_spin_moves.puzzlesfromsurvivor2"  //Fewest Moves - Spin Puzzle

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    var timer = Timer()
    var timerCount: Double = 0
    var moveCount = 0
    let TIMER_INCREMENT = 0.01
    
    var SpinImages: [UIImageView] = []
    var SpinButtons: [UIButton] = []
    var FlowerImages: [UIImageView] = []
    var FlowerButtons: [UIButton] = []
    var TopFlowerButtons: [UIButton] = []
    
    var SpinOffsets: [Int] = []
    var FlowerOffsets: [Int] = []
    var TopFlowerOffsets: [Int] = []
    
    var Spin_spinnerPosition: [Float] = []
    var Flower_spinnerPosition: [Float] = []
    
    let EMPTY = "transparent.png"
    var FlowerImageArray_top: [String] = ["flower_0_0.png", "flower_0_1.png", "flower_0_2.png", "flower_0_3.png", "flower_1_0.png", "flower_1_1.png", "flower_1_2.png", "flower_1_3.png"]
    var FlowerImageArray_game: [String] = ["", "", "", "", "", "", "", ""]
    
    let ANGLE_STEP: Float = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpinButtons = [spin00o, spin01o, spin02o, spin03o, spin04o,
                       spin10o, spin11o, spin12o, spin13o, spin14o,
                       spin20o, spin21o, spin22o, spin23o, spin24o]
        FlowerButtons = [flower00o, flower01o, flower02o, flower03o,
                         flower10o, flower11o, flower12o, flower13o]
        
        SpinImages = [spin00, spin01, spin02, spin03, spin04,
                      spin10, spin11, spin12, spin13, spin14,
                      spin20, spin21, spin22, spin23, spin24]
        FlowerImages = [flower00, flower01, flower02, flower03,
                        flower10, flower11, flower12, flower13]
        
        TopFlowerButtons = [flower0, flower1, flower2, flower3,
                            flower4, flower5, flower6, flower7]
        
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
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    func NewGame() {
        timerCount = 0
        timerLabel.text = "\(timerCount)"
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        moveCount = -1
        Label_MoveCount.text = "\(moveCount)"
        
        Label_YouWin.isHidden = true
        
        SpinOffsets = [GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle()]
        FlowerOffsets = [GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle()]
        TopFlowerOffsets = [GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle(), GetRandomAngle()]
        
        FlowerImageArray_top = ["flower_0_0.png", "flower_0_1.png", "flower_0_2.png", "flower_0_3.png", "flower_1_0.png", "flower_1_1.png", "flower_1_2.png", "flower_1_3.png"]
        FlowerImageArray_top.shuffle()
        FlowerImageArray_game = [EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY]
        
        var i = 0
        for image in SpinImages {
            let angle = (Float(SpinOffsets[i]) + 360.0) * .pi
            image.transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
            i += 1
        }
        i = 0
        for image in FlowerImages {
            let angle = (Float(FlowerOffsets[i]) + 360.0) * .pi
            image.transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
            i += 1
        }
        i = 0
        for button in TopFlowerButtons {
            let angle = (Float(TopFlowerOffsets[i]) + 360.0) * .pi
            button.transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
            i += 1
        }
        
        Spin_spinnerPosition = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        Flower_spinnerPosition = [0, 0, 0, 0, 0, 0, 0, 0]
        
        SpinnerSelected = false
        FlowerSelected = false
        TopFlowerSelected = false
        IndexSelected = 0
        UpdateUI()
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.2f", timerCount)
    }
    
    func GetRandomAngle() -> Int {
        return Int.random(in: 0 ... (360 / Int(ANGLE_STEP))) * Int(ANGLE_STEP)
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var flower0: UIButton!
    @IBAction func flower0(_ sender: Any) {
        PressedTopFlower(0)
    }
    @IBOutlet weak var flower1: UIButton!
    @IBAction func flower1(_ sender: Any) {
        PressedTopFlower(1)
    }
    @IBOutlet weak var flower2: UIButton!
    @IBAction func flower2(_ sender: Any) {
        PressedTopFlower(2)
    }
    @IBOutlet weak var flower3: UIButton!
    @IBAction func flower3(_ sender: Any) {
        PressedTopFlower(3)
    }
    @IBOutlet weak var flower4: UIButton!
    @IBAction func flower4(_ sender: Any) {
        PressedTopFlower(4)
    }
    @IBOutlet weak var flower5: UIButton!
    @IBAction func flower5(_ sender: Any) {
        PressedTopFlower(5)
    }
    @IBOutlet weak var flower6: UIButton!
    @IBAction func flower6(_ sender: Any) {
        PressedTopFlower(6)
    }
    @IBOutlet weak var flower7: UIButton!
    @IBAction func flower7(_ sender: Any) {
        PressedTopFlower(7)
    }
    
    
    @IBOutlet weak var spin00: UIImageView!
    @IBOutlet weak var spin00o: UIButton!
    @IBAction func spin00(_ sender: Any) {
        PressedSpinner(0)
    }
    @IBOutlet weak var spin01: UIImageView!
    @IBOutlet weak var spin01o: UIButton!
    @IBAction func spin01(_ sender: Any) {
        PressedSpinner(1)
    }
    @IBOutlet weak var spin02: UIImageView!
    @IBOutlet weak var spin02o: UIButton!
    @IBAction func spin02(_ sender: Any) {
        PressedSpinner(2)
    }
    @IBOutlet weak var spin03: UIImageView!
    @IBOutlet weak var spin03o: UIButton!
    @IBAction func spin03(_ sender: Any) {
        PressedSpinner(3)
    }
    @IBOutlet weak var spin04: UIImageView!
    @IBOutlet weak var spin04o: UIButton!
    @IBAction func spin04(_ sender: Any) {
        PressedSpinner(4)
    }
    @IBOutlet weak var spin10: UIImageView!
    @IBOutlet weak var spin10o: UIButton!
    @IBAction func spin10(_ sender: Any) {
        PressedSpinner(5)
    }
    @IBOutlet weak var spin11: UIImageView!
    @IBOutlet weak var spin11o: UIButton!
    @IBAction func spin11(_ sender: Any) {
        PressedSpinner(6)
    }
    @IBOutlet weak var spin12: UIImageView!
    @IBOutlet weak var spin12o: UIButton!
    @IBAction func spin12(_ sender: Any) {
        PressedSpinner(7)
    }
    @IBOutlet weak var spin13: UIImageView!
    @IBOutlet weak var spin13o: UIButton!
    @IBAction func spin13(_ sender: Any) {
        PressedSpinner(8)
    }
    @IBOutlet weak var spin14: UIImageView!
    @IBOutlet weak var spin14o: UIButton!
    @IBAction func spin14(_ sender: Any) {
        PressedSpinner(9)
    }
    @IBOutlet weak var spin20: UIImageView!
    @IBOutlet weak var spin20o: UIButton!
    @IBAction func spin20(_ sender: Any) {
        PressedSpinner(10)
    }
    @IBOutlet weak var spin21: UIImageView!
    @IBOutlet weak var spin21o: UIButton!
    @IBAction func spin21(_ sender: Any) {
        PressedSpinner(11)
    }
    @IBOutlet weak var spin22: UIImageView!
    @IBOutlet weak var spin22o: UIButton!
    @IBAction func spin22(_ sender: Any) {
        PressedSpinner(12)
    }
    @IBOutlet weak var spin23: UIImageView!
    @IBOutlet weak var spin23o: UIButton!
    @IBAction func spin23(_ sender: Any) {
        PressedSpinner(13)
    }
    @IBOutlet weak var spin24: UIImageView!
    @IBOutlet weak var spin24o: UIButton!
    @IBAction func spin24(_ sender: Any) {
        PressedSpinner(14)
    }
    @IBOutlet weak var flower00: UIImageView!
    @IBOutlet weak var flower00o: UIButton!
    @IBAction func flower00(_ sender: Any) {
        PressedFlower(0)
    }
    @IBOutlet weak var flower01: UIImageView!
    @IBOutlet weak var flower01o: UIButton!
    @IBAction func flower01(_ sender: Any) {
        PressedFlower(1)
    }
    @IBOutlet weak var flower02: UIImageView!
    @IBOutlet weak var flower02o: UIButton!
    @IBAction func flower02(_ sender: Any) {
        PressedFlower(2)
    }
    @IBOutlet weak var flower03: UIImageView!
    @IBOutlet weak var flower03o: UIButton!
    @IBAction func flower03(_ sender: Any) {
        PressedFlower(3)
    }
    @IBOutlet weak var flower10: UIImageView!
    @IBOutlet weak var flower10o: UIButton!
    @IBAction func flower10(_ sender: Any) {
        PressedFlower(4)
    }
    @IBOutlet weak var flower11: UIImageView!
    @IBOutlet weak var flower11o: UIButton!
    @IBAction func flower11(_ sender: Any) {
        PressedFlower(5)
    }
    @IBOutlet weak var flower12: UIImageView!
    @IBOutlet weak var flower12o: UIButton!
    @IBAction func flower12(_ sender: Any) {
        PressedFlower(6)
    }
    @IBOutlet weak var flower13: UIImageView!
    @IBOutlet weak var flower13o: UIButton!
    @IBAction func flower13(_ sender: Any) {
        PressedFlower(7)
    }
    @IBOutlet weak var spinner: UISlider!
    @IBAction func spinner(_ sender: UISlider) {

        sender.value = Float(Int(sender.value))
        
        if SpinnerSelected == true {
            Spin_spinnerPosition[IndexSelected] = sender.value
            var angle = GetAngle(isFlower: false, index: IndexSelected)
            print(angle)
            angle *= .pi
            SpinImages[IndexSelected].transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
        }
        if FlowerSelected == true {
            Flower_spinnerPosition[IndexSelected] = sender.value
            var angle = GetAngle(isFlower: true, index: IndexSelected)
            print(angle)
            angle *= .pi
            FlowerImages[IndexSelected].transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
        }
    }
    @IBAction func spinner_editingDidEnd(_ sender: UISlider) {
        print("editingDidEnd")
    }
    @IBAction func spinner_touchUpInside(_ sender: UISlider) {
        print("touchUp Inside")
        UpdateUI()
    }
    @IBAction func spinner_touchUpOutside(_ sender: UISlider) {
        print("touchUp Outside")
        UpdateUI()
    }
    
    func GetAngle(isFlower: Bool, index: Int) -> Float {
        var angle: Float = 0.0
        if !isFlower {
            angle = Float(SpinOffsets[index]) + ANGLE_STEP * Spin_spinnerPosition[index]
        }else {
            angle = Float(FlowerOffsets[index]) + ANGLE_STEP * Flower_spinnerPosition[index]
        }
        while angle <= -360 {
            angle += 360
        }
        while angle >= 360 {
            angle -= 360
        }
        return angle
    }
    
    var SpinnerSelected = false
    var FlowerSelected = false
    var TopFlowerSelected = false
    var IndexSelected = 0
    
    func PressedSpinner(_ index: Int) {
        print("Spinner \(index)")
        SpinnerSelected = true
        FlowerSelected = false
        TopFlowerSelected = false
        IndexSelected = index
        spinner.value = Spin_spinnerPosition[IndexSelected]
        UpdateUI()
    }
    
    func PressedFlower(_ index: Int) {
        print("Flower \(index)")
        if TopFlowerSelected && FlowerImageArray_game[index] == EMPTY {
            SwapFlowers(&FlowerImageArray_game[index], &FlowerImageArray_top[IndexSelected])
        }else if FlowerSelected && FlowerImageArray_game[index] == EMPTY {
            let temp = FlowerImageArray_game[index]
            FlowerImageArray_game[index] = FlowerImageArray_game[IndexSelected]
            FlowerImageArray_game[IndexSelected] = temp
        }
        
        SpinnerSelected = false
        FlowerSelected = true
        TopFlowerSelected = false
        IndexSelected = index
        spinner.value = Flower_spinnerPosition[IndexSelected]
        UpdateUI()
    }
    
    func PressedTopFlower(_ index: Int) {
        print("Top Flower \(index)")
        if TopFlowerSelected && FlowerImageArray_top[index] == EMPTY {
            let temp = FlowerImageArray_top[index]
            FlowerImageArray_top[index] = FlowerImageArray_top[IndexSelected]
            FlowerImageArray_top[IndexSelected] = temp
        }else if FlowerSelected && FlowerImageArray_top[index] == EMPTY {
            SwapFlowers(&FlowerImageArray_game[IndexSelected], &FlowerImageArray_top[index])
        }
        
        SpinnerSelected = false
        FlowerSelected = false
        TopFlowerSelected = true
        IndexSelected = index
        //spinner.value = Flower_spinnerPosition[IndexSelected]
        UpdateUI()
    }
    
    func SwapFlowers(_ str1: inout String, _ str2: inout String) {
        let temp = str1
        str1 = str2
        str2 = temp
    }
    
    func UpdateUI() {
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        
        for button in SpinButtons {
            button.setImage(UIImage(named: "transparent.png"), for: .normal)
        }
        for button in FlowerButtons {
            button.setImage(UIImage(named: "transparent.png"), for: .normal)
        }
        
        for image in SpinImages {
            image.alpha = 0.5
        }
        var i = 0
        for image in FlowerImages {
            image.alpha = 0.5
            image.image = UIImage(named: FlowerImageArray_game[i])
            i += 1
        }
        i = 0
        for button in TopFlowerButtons {
            button.alpha = 0.5
            button.setImage(UIImage(named: FlowerImageArray_top[i]), for: .normal)
            i += 1
        }
        
        if SpinnerSelected == true {
            SpinImages[IndexSelected].alpha = 1.0
        }
        if FlowerSelected == true {
            FlowerImages[IndexSelected].alpha = 1.0
        }
        if TopFlowerSelected == true {
            TopFlowerButtons[IndexSelected].alpha = 1.0
        }
        
        if FlowerSelected || TopFlowerSelected {
            
            var i = 0
            for button in FlowerButtons {
                if FlowerImageArray_game[i] == EMPTY {
                    button.setImage(UIImage(named: "blob_green.png"), for: .normal)
                    button.alpha = 0.5
                }
                i += 1
            }
            i = 0
            for button in TopFlowerButtons {
                var angle: Float = 0.0
                if FlowerImageArray_top[i] == EMPTY {
                    button.setImage(UIImage(named: "blob_green.png"), for: .normal)
                    button.alpha = 0.5
                }else {
                    angle = (Float(TopFlowerOffsets[i]) + 360.0) * .pi
                }
                button.transform = CGAffineTransform(rotationAngle: CGFloat((angle) / 180.0))
                i += 1
            }
        }
        
        if SpinnerSelected || FlowerSelected {
            spinner.isHidden = false
        }else {
            spinner.isHidden = true
        }
        
        CheckForWin()
    }
    
    func CheckForWin() {
        var correctCount = 0
        
        if FlowerImageArray_game[0] == "flower_0_0.png" &&
            GetAngle(isFlower: true, index: 0) == 0 &&
            GetAngle(isFlower: false, index: 0) == 0 && GetAngle(isFlower: false, index: 1) == 0 && GetAngle(isFlower: false, index: 5) == 0 && GetAngle(isFlower: false, index: 6) == 0 {
            correctCount += 1
            flower00.alpha = 1
            spin00.alpha = 1
            spin01.alpha = 1
            spin10.alpha = 1
            spin11.alpha = 1
        }
        if FlowerImageArray_game[1] == "flower_0_1.png" &&
            GetAngle(isFlower: true, index: 1) == 0 &&
            GetAngle(isFlower: false, index: 1) == 0 && GetAngle(isFlower: false, index: 2) == 0 && GetAngle(isFlower: false, index: 6) == 0 && GetAngle(isFlower: false, index: 7) == 0 {
            correctCount += 1
            flower01.alpha = 1
            spin01.alpha = 1
            spin02.alpha = 1
            spin11.alpha = 1
            spin12.alpha = 1
        }
        if FlowerImageArray_game[2] == "flower_0_2.png" &&
            GetAngle(isFlower: true, index: 2) == 0 &&
            GetAngle(isFlower: false, index: 2) == 0 && GetAngle(isFlower: false, index: 3) == 0 && GetAngle(isFlower: false, index: 7) == 0 && GetAngle(isFlower: false, index: 8) == 0 {
            correctCount += 1
            flower02.alpha = 1
            spin02.alpha = 1
            spin03.alpha = 1
            spin12.alpha = 1
            spin13.alpha = 1
        }
        if FlowerImageArray_game[3] == "flower_0_3.png" &&
            GetAngle(isFlower: true, index: 3) == 0 &&
            GetAngle(isFlower: false, index: 3) == 0 && GetAngle(isFlower: false, index: 4) == 0 && GetAngle(isFlower: false, index: 8) == 0 && GetAngle(isFlower: false, index: 9) == 0 {
            correctCount += 1
            flower03.alpha = 1
            spin03.alpha = 1
            spin04.alpha = 1
            spin13.alpha = 1
            spin14.alpha = 1
        }
        if FlowerImageArray_game[4] == "flower_1_0.png" &&
            GetAngle(isFlower: true, index: 4) == 0 &&
            GetAngle(isFlower: false, index: 5) == 0 && GetAngle(isFlower: false, index: 6) == 0 && GetAngle(isFlower: false, index: 10) == 0 && GetAngle(isFlower: false, index: 11) == 0 {
            correctCount += 1
            flower10.alpha = 1
            spin10.alpha = 1
            spin11.alpha = 1
            spin20.alpha = 1
            spin21.alpha = 1
        }
        if FlowerImageArray_game[5] == "flower_1_1.png" &&
            GetAngle(isFlower: true, index: 5) == 0 &&
            GetAngle(isFlower: false, index: 6) == 0 && GetAngle(isFlower: false, index: 7) == 0 && GetAngle(isFlower: false, index: 11) == 0 && GetAngle(isFlower: false, index: 12) == 0 {
            correctCount += 1
            flower11.alpha = 1
            spin11.alpha = 1
            spin12.alpha = 1
            spin21.alpha = 1
            spin22.alpha = 1
        }
        if FlowerImageArray_game[6] == "flower_1_2.png" &&
            GetAngle(isFlower: true, index: 6) == 0 &&
            GetAngle(isFlower: false, index: 7) == 0 && GetAngle(isFlower: false, index: 8) == 0 && GetAngle(isFlower: false, index: 12) == 0 && GetAngle(isFlower: false, index: 13) == 0 {
            correctCount += 1
            flower12.alpha = 1
            spin12.alpha = 1
            spin13.alpha = 1
            spin22.alpha = 1
            spin23.alpha = 1
        }
        if FlowerImageArray_game[7] == "flower_1_3.png" &&
            GetAngle(isFlower: true, index: 7) == 0 &&
            GetAngle(isFlower: false, index: 8) == 0 && GetAngle(isFlower: false, index: 9) == 0 && GetAngle(isFlower: false, index: 13) == 0 && GetAngle(isFlower: false, index: 14) == 0 {
            correctCount += 1
            flower13.alpha = 1
            spin13.alpha = 1
            spin14.alpha = 1
            spin23.alpha = 1
            spin24.alpha = 1
        }
        
        if correctCount == 8 {
            print("You Win!")
            Label_YouWin.isHidden = false
            for button in TopFlowerButtons {
                button.setImage(UIImage(named: "transparent.png"), for: .normal)
            }
            
            timer.invalidate()
            
            appDelegate.puzzlesCompleted += 1
            appDelegate.pcc_SpinPuzzle += 1
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
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_SPIN_TIME)
            }
            alertController.addAction(okAction)
            alertController.addAction(submitScoreAction)
            alertController.addAction(submitScoreAndGoAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_SPIN_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_SPIN_MOVES)
        
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SpinPuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_SpinPuzzle)
    }
}
