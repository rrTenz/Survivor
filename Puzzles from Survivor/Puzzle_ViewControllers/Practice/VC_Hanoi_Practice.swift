//
//  VC_Hanoi_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 9/13/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_Hanoi_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_HANOI_TIME = "com.score_hanoi_time.puzzlesfromsurvivor"    //Best Time - Tower of Hanoi
    let LEADERBOARD_ID_HANOI_MOVES = "com.score_hanoi_moves.puzzlesfromsurvivor"  //Fewest Moves - Tower of Hanoi
    
    @IBOutlet weak var Label_Block_0_0: UILabel!
    @IBOutlet weak var Label_Block_0_1: UILabel!
    @IBOutlet weak var Label_Block_0_2: UILabel!
    @IBOutlet weak var Label_Block_0_3: UILabel!
    
    @IBOutlet weak var Label_Block_1_0: UILabel!
    @IBOutlet weak var Label_Block_1_1: UILabel!
    @IBOutlet weak var Label_Block_1_2: UILabel!
    @IBOutlet weak var Label_Block_1_3: UILabel!
    
    @IBOutlet weak var Label_Block_2_0: UILabel!
    @IBOutlet weak var Label_Block_2_1: UILabel!
    @IBOutlet weak var Label_Block_2_2: UILabel!
    @IBOutlet weak var Label_Block_2_3: UILabel!
    
    var Label_0_Array: [UILabel] = []
    var Label_1_Array: [UILabel] = []
    var Label_2_Array: [UILabel] = []
    
    @IBOutlet weak var Label_InHand: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var Column0: [Block] = []
    var Column1: [Block] = []
    var Column2: [Block] = []
    var InHand = Block(size: 0)
    var MoveCount = 0
    
    var timer = Timer()
    var timerCount = 0.0
    let TIMER_INCREMENT = 0.01
    var timerStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()

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
        Label_0_Array = [Label_Block_0_0, Label_Block_0_1, Label_Block_0_2, Label_Block_0_3]
        Label_1_Array = [Label_Block_1_0, Label_Block_1_1, Label_Block_1_2, Label_Block_1_3]
        Label_2_Array = [Label_Block_2_0, Label_Block_2_1, Label_Block_2_2, Label_Block_2_3]
        
        Column0.removeAll()
        Column1.removeAll()
        Column2.removeAll()
        InHand = Block(size: 0)
        
        Column0.append(Block(size: 4))
        Column0.append(Block(size: 3))
        Column0.append(Block(size: 2))
        Column0.append(Block(size: 1))
        
        UpdateBlockLabels()
        UpdateButtonTitles()
        MoveCount = 0
        Label_MoveCount.text = "Moves: \(MoveCount)"
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.2f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        timerStarted = true
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.2f", timerCount)
    }
    
    func UpdateBlockLabels() {
        for label in Label_0_Array {
            label.text = ""
        }
        for label in Label_1_Array {
            label.text = ""
        }
        for label in Label_2_Array {
            label.text = ""
        }
        
        var i = 0
        for block in Column0 {
            Label_0_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        i = 0
        for block in Column1 {
            Label_1_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        i = 0
        for block in Column2 {
            Label_2_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        
        Label_InHand.text = getBlockString(size: InHand.size)
    }
    
    func UpdateButtonTitles(){
        if InHand.size == 0 {
            Button_Take0_outlet.setTitle("Take", for: .normal)
            Button_Take1_outlet.setTitle("Take", for: .normal)
            Button_Take2_outlet.setTitle("Take", for: .normal)
        }else {
            Button_Take0_outlet.setTitle("Place", for: .normal)
            Button_Take1_outlet.setTitle("Place", for: .normal)
            Button_Take2_outlet.setTitle("Place", for: .normal)
        }
    }
    
    func getBlockString(size: Int) -> String{
        var myString = ""
        if size == 1 {
            myString = "O"
        }else if size == 2 {
            myString = "OO"
        }else if size == 3 {
            myString = "OOO"
        }else if size == 4 {
            myString = "OOOO"
        }
        return myString
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Button_Take0_outlet: UIButton!
    @IBAction func Button_Take0(_ sender: Any) {
        if Column0.count > 0 && InHand.size == 0 {   // Take from Column 0
            InHand = Column0.last!
            Column0.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column0.count == 0 || Column0.last!.size > InHand.size) {  //Place into Column 0
            Column0.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    @IBOutlet weak var Button_Take1_outlet: UIButton!
    @IBAction func Button_Take1(_ sender: Any) {
        if Column1.count > 0 && InHand.size == 0 {   // Take from Column 1
            InHand = Column1.last!
            Column1.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column1.count == 0 || Column1.last!.size > InHand.size) {  //Place into Column 1
            Column1.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    @IBOutlet weak var Button_Take2_outlet: UIButton!
    @IBAction func Button_Take2(_ sender: Any) {
        if Column2.count > 0 && InHand.size == 0 {   // Take from Column 2
            InHand = Column2.last!
            Column2.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column2.count == 0 || Column2.last!.size > InHand.size) {  //Place into Column 2
            Column2.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    func CheckForWin() {
        if Column0.count == 0 && Column1.count == 0 && Column2.count == 4 {
            Label_InHand.text = "You Win!"
            timerStarted = false
            timer.invalidate()
            
            let timeString = String(format: "%.2f", timerCount)
            let alertController = UIAlertController(title: "You Win", message: "Good job!\nYou completed the puzzle!\n\nMoves: \(MoveCount)\nSeconds: \(timeString)", preferredStyle: .alert)
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
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_HANOI_TIME)
            }
            alertController.addAction(okAction)
            alertController.addAction(submitScoreAction)
            alertController.addAction(submitScoreAndGoAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 100), leaderBoardID: self.LEADERBOARD_ID_HANOI_TIME)
        self.submitScoreToGC(score: self.MoveCount, leaderBoardID: self.LEADERBOARD_ID_HANOI_MOVES)
    }
    
    
    struct Block {
        var size = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
