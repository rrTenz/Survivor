//
//  VC_CombinationLock_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 1/9/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_CombinationLock_Practice: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_COMBO_TIME = "com.score_combo_time.puzzlesfromsurvivor"    //Best Time - Combination Lock
    let LEADERBOARD_ID_COMBO_MOVES = "com.score_combo_moves.puzzlesfromsurvivor"  //Fewest Moves - Combination Lock
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    @IBOutlet weak var Label_NumberOne: UILabel!
    @IBOutlet weak var Label_NumberTwo: UILabel!
    @IBOutlet weak var Label_NumberThree: UILabel!
    var numberOne = 0
    var numberTwo = 0
    var numberThree = 0
    var winningOrder = [0, 0, 0]
    var youWin = false
    
    @IBOutlet weak var CombPicker: UIPickerView!
    
    var timer = Timer()
    var timerCount: Double = 0
    var moveCount = 0
    let TIMER_INCREMENT = 0.01
    var timerStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewGame()
        
        authenticateLocalPlayer()
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    func NewGame() {
        timerCount = 0
        timerLabel.text = "\(timerCount)"
        timerStarted = true
        youWin = false
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        
        Button_Done_outlet.setTitle("Check", for: .normal)
        
        Label_YouWin.isHidden = true
        
        CombPicker.selectRow(10 * 10, inComponent: 0, animated: false)
        CombPicker.selectRow(10 * 10, inComponent: 1, animated: false)
        CombPicker.selectRow(10 * 10, inComponent: 2, animated: false)
        CombPicker.selectRow(10 * 10, inComponent: 3, animated: false)
        CombPicker.selectRow(10 * 10, inComponent: 4, animated: false)
        CombPicker.selectRow(10 * 10, inComponent: 5, animated: false)
        
        numberOne = Int.random(in: 10 ..< 99)
        repeat {
            numberTwo = Int.random(in: 10 ..< 99)
        } while numberTwo == numberOne
        repeat {
            numberThree = Int.random(in: 10 ..< 99)
        } while numberThree == numberOne || numberThree == numberTwo
        Label_NumberOne.text = "\(numberOne)"
        Label_NumberTwo.text = "\(numberTwo)"
        Label_NumberThree.text = "\(numberThree)"
        winningOrder = [numberOne, numberTwo, numberThree]
        winningOrder.shuffle()
        
        Label_YouWin.text = "\(winningOrder[0]) \(winningOrder[1]) \(winningOrder[2])"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10 * 20
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: screenHeight * 0.05)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = "\(row % 10)"
        
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row % 10)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.isHidden = true
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
    
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.2f", timerCount)
    }
    
    func checkForSolved() -> Bool {
        let digit0 = CombPicker.selectedRow(inComponent: 0)
        let digit1 = CombPicker.selectedRow(inComponent: 1)
        let digit2 = CombPicker.selectedRow(inComponent: 2)
        let digit3 = CombPicker.selectedRow(inComponent: 3)
        let digit4 = CombPicker.selectedRow(inComponent: 4)
        let digit5 = CombPicker.selectedRow(inComponent: 5)
        
        let number0 = digit0 % 10 * 10 + digit1 % 10
        let number1 = digit2 % 10 * 10 + digit3 % 10
        let number2 = digit4 % 10 * 10 + digit5 % 10
        
        if number0 == winningOrder[0] && number1 == winningOrder[1] && number2 == winningOrder[2] {
            return true
        }
        
        return false
    }
    
    @IBOutlet weak var Button_Done_outlet: UIButton!
    @IBAction func Button_Done(_ sender: Any) {
        if timerStarted {
            if checkForSolved() == false {
                Label_YouWin.isHidden = false
                Label_YouWin.text = "No, Keep trying"
            }else if youWin == false{
                timerStarted = false
                youWin = true
                timer.invalidate()
                Label_YouWin.isHidden = false
                Label_YouWin.text = "You Win!"                
                
                appDelegate.puzzlesCompleted += 1
                appDelegate.pcc_CombinationLock += 1
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
                    self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_COMBO_TIME)
                }
                alertController.addAction(okAction)
                alertController.addAction(submitScoreAction)
                alertController.addAction(submitScoreAndGoAction)
                self.present(alertController, animated: true, completion: nil)
                Button_Done_outlet.setTitle("New Game", for: .normal)
            }
        }else {
            NewGame()
        }
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 100), leaderBoardID: self.LEADERBOARD_ID_COMBO_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_COMBO_MOVES)
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

}
