//
//  VC_NumbersGame_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 1/30/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_NumbersGame_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID   
    let LEADERBOARD_ID_NUMBERSGAME_TIME = "com.score_numbersgame_time.puzzlesfromsurvivor"    //Best Time - A Numbers Game
    let LEADERBOARD_ID_NUMBERSGAME_MOVES = "com.score_numbersgame_moves.puzzlesfromsurvivor"  //Fewest Moves - A Numbers Game
    
    var gameViewWidth: CGFloat = 0.0
    var blockWidth: CGFloat = 0.0
    
    var whichBag = 0    //There are 4 bags they contain pieces 1-10, 11-30, 31-60, 61-100
    let bagContents = [[1, 10], [11, 30], [31, 60], [61, 100]]
    let tileCount = [10, 20, 30, 40]
    var tilesOnLeft = 0
    var lookingForTile = 1
    
    var LeftButtonArray: [UIButton] = []
    var RightButtonArray: [UIButton] = []
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LeftButtonArray = [l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40]
        RightButtonArray = [b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24, b25, b26, b27, b28, b29, b30, b31, b32, b33, b34, b35, b36, b37, b38, b39, b40, b41, b42, b43, b44, b45, b46, b47, b48, b49, b50, b51, b52, b53, b54, b55, b56, b57, b58, b59, b60, b61, b62, b63, b64, b65, b66, b67, b68, b69, b70, b71, b72, b73, b74, b75, b76, b77, b78, b79, b80, b81, b82, b83, b84, b85, b86, b87, b88, b89, b90, b91, b92, b93, b94, b95, b96, b97, b98, b99, b100]
        
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
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    func UpdateUi () {
        var i = 0
        for button in RightButtonArray {
            if i < lookingForTile - 1 {
                button.isHidden = false
            }else {
                button.isHidden = true
            }
            i += 1
        }
        
        i = 0
        for button in LeftButtonArray {
            if bagArray[i] == 0 {
                button.isHidden = true
            }else {
                button.isHidden = false
                button.setTitle("\(bagArray[i])", for: .normal)
                if doSpin {
                    let number = Float.random(in: 0 ..< 360)
                    button.transform = CGAffineTransform(rotationAngle: CGFloat((number * .pi) / 180.0))
                }
            }
            i += 1
        }
        Label_MoveCount.text = "\(moveCount)"
        doSpin = false
    }
    
    var bagArray: [Int] = []
    var doSpin = false
    func OpenBag(_ bag: Int) {
        bagArray.removeAll()
        
        for i in bagContents[bag][0]...bagContents[bag][1] {
            bagArray.append(i)
        }
        while bagArray.count < 40 {
            bagArray.append(0)
        }
        Label_YouWin.text = "Bag \(bag + 1)"
        bagArray.shuffle()
        doSpin = true
    }
    
    func NewGame() {
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        whichBag = 0
        tilesOnLeft = tileCount[whichBag]
        lookingForTile = 1
        OpenBag(whichBag)
        
        UpdateUi()
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        timerLabel.text = String(format: "%.1f", timerCount)
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    var buttonTags:[Int] = []
    var button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    override func viewDidAppear(_ animated: Bool) {
        
//        self.gameViewWidth = self.gameView.frame.size.height
//        self.blockWidth = gameViewWidth / 11
//        
//        var xCen = blockWidth / 2
//        var yCen = blockWidth / 2
//        
//        var index = 0
//        buttonTags.removeAll()
//        for _ in 0..<10 {
//            for _ in 0..<10 {
//                index += 1
//                buttonTags.append(index)
//                button.tag = index
//                button = UIButton(frame: CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth))
//                button.backgroundColor = .yellow
//                button.setTitle("\(index)", for: .normal)
//                button.setTitleColor(.black, for: .normal)
//                let currentCenter = CGPoint(x: xCen + self.gameView.frame.minX + self.gameView.frame.size.width * 0.383, y: yCen + self.gameView.frame.minY + self.gameView.frame.size.height * 0.053)
//                button.center = currentCenter
//                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//                self.view.addSubview(button)
//                
//                xCen += blockWidth
//            }
//            xCen = blockWidth / 2
//            yCen += blockWidth
//        }
        
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped \(sender.tag)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    @IBOutlet weak var b20: UIButton!
    @IBOutlet weak var b21: UIButton!
    @IBOutlet weak var b22: UIButton!
    @IBOutlet weak var b23: UIButton!
    @IBOutlet weak var b24: UIButton!
    @IBOutlet weak var b25: UIButton!
    @IBOutlet weak var b26: UIButton!
    @IBOutlet weak var b27: UIButton!
    @IBOutlet weak var b28: UIButton!
    @IBOutlet weak var b29: UIButton!
    @IBOutlet weak var b30: UIButton!
    @IBOutlet weak var b31: UIButton!
    @IBOutlet weak var b32: UIButton!
    @IBOutlet weak var b33: UIButton!
    @IBOutlet weak var b34: UIButton!
    @IBOutlet weak var b35: UIButton!
    @IBOutlet weak var b36: UIButton!
    @IBOutlet weak var b37: UIButton!
    @IBOutlet weak var b38: UIButton!
    @IBOutlet weak var b39: UIButton!
    @IBOutlet weak var b40: UIButton!
    @IBOutlet weak var b41: UIButton!
    @IBOutlet weak var b42: UIButton!
    @IBOutlet weak var b43: UIButton!
    @IBOutlet weak var b44: UIButton!
    @IBOutlet weak var b45: UIButton!
    @IBOutlet weak var b46: UIButton!
    @IBOutlet weak var b47: UIButton!
    @IBOutlet weak var b48: UIButton!
    @IBOutlet weak var b49: UIButton!
    @IBOutlet weak var b50: UIButton!
    @IBOutlet weak var b51: UIButton!
    @IBOutlet weak var b52: UIButton!
    @IBOutlet weak var b53: UIButton!
    @IBOutlet weak var b54: UIButton!
    @IBOutlet weak var b55: UIButton!
    @IBOutlet weak var b56: UIButton!
    @IBOutlet weak var b57: UIButton!
    @IBOutlet weak var b58: UIButton!
    @IBOutlet weak var b59: UIButton!
    @IBOutlet weak var b60: UIButton!
    @IBOutlet weak var b61: UIButton!
    @IBOutlet weak var b62: UIButton!
    @IBOutlet weak var b63: UIButton!
    @IBOutlet weak var b64: UIButton!
    @IBOutlet weak var b65: UIButton!
    @IBOutlet weak var b66: UIButton!
    @IBOutlet weak var b67: UIButton!
    @IBOutlet weak var b68: UIButton!
    @IBOutlet weak var b69: UIButton!
    @IBOutlet weak var b70: UIButton!
    @IBOutlet weak var b71: UIButton!
    @IBOutlet weak var b72: UIButton!
    @IBOutlet weak var b73: UIButton!
    @IBOutlet weak var b74: UIButton!
    @IBOutlet weak var b75: UIButton!
    @IBOutlet weak var b76: UIButton!
    @IBOutlet weak var b77: UIButton!
    @IBOutlet weak var b78: UIButton!
    @IBOutlet weak var b79: UIButton!
    @IBOutlet weak var b80: UIButton!
    @IBOutlet weak var b81: UIButton!
    @IBOutlet weak var b82: UIButton!
    @IBOutlet weak var b83: UIButton!
    @IBOutlet weak var b84: UIButton!
    @IBOutlet weak var b85: UIButton!
    @IBOutlet weak var b86: UIButton!
    @IBOutlet weak var b87: UIButton!
    @IBOutlet weak var b88: UIButton!
    @IBOutlet weak var b89: UIButton!
    @IBOutlet weak var b90: UIButton!
    @IBOutlet weak var b91: UIButton!
    @IBOutlet weak var b92: UIButton!
    @IBOutlet weak var b93: UIButton!
    @IBOutlet weak var b94: UIButton!
    @IBOutlet weak var b95: UIButton!
    @IBOutlet weak var b96: UIButton!
    @IBOutlet weak var b97: UIButton!
    @IBOutlet weak var b98: UIButton!
    @IBOutlet weak var b99: UIButton!
    @IBOutlet weak var b100: UIButton!
    
    @IBOutlet weak var l1: UIButton!
    @IBOutlet weak var l2: UIButton!
    @IBOutlet weak var l3: UIButton!
    @IBOutlet weak var l4: UIButton!
    @IBOutlet weak var l5: UIButton!
    @IBOutlet weak var l6: UIButton!
    @IBOutlet weak var l7: UIButton!
    @IBOutlet weak var l8: UIButton!
    @IBOutlet weak var l9: UIButton!
    @IBOutlet weak var l10: UIButton!
    @IBOutlet weak var l11: UIButton!
    @IBOutlet weak var l12: UIButton!
    @IBOutlet weak var l13: UIButton!
    @IBOutlet weak var l14: UIButton!
    @IBOutlet weak var l15: UIButton!
    @IBOutlet weak var l16: UIButton!
    @IBOutlet weak var l17: UIButton!
    @IBOutlet weak var l18: UIButton!
    @IBOutlet weak var l19: UIButton!
    @IBOutlet weak var l20: UIButton!
    @IBOutlet weak var l21: UIButton!
    @IBOutlet weak var l22: UIButton!
    @IBOutlet weak var l23: UIButton!
    @IBOutlet weak var l24: UIButton!
    @IBOutlet weak var l25: UIButton!
    @IBOutlet weak var l26: UIButton!
    @IBOutlet weak var l27: UIButton!
    @IBOutlet weak var l28: UIButton!
    @IBOutlet weak var l29: UIButton!
    @IBOutlet weak var l30: UIButton!
    @IBOutlet weak var l31: UIButton!
    @IBOutlet weak var l32: UIButton!
    @IBOutlet weak var l33: UIButton!
    @IBOutlet weak var l34: UIButton!
    @IBOutlet weak var l35: UIButton!
    @IBOutlet weak var l36: UIButton!
    @IBOutlet weak var l37: UIButton!
    @IBOutlet weak var l38: UIButton!
    @IBOutlet weak var l39: UIButton!
    @IBOutlet weak var l40: UIButton!
    
    @IBAction func l1(_ sender: Any) {
        leftButtonPress(1, sender)
    }
    @IBAction func l2(_ sender: Any) {
        leftButtonPress(2, sender)
    }
    @IBAction func l3(_ sender: Any) {
        leftButtonPress(3, sender)
    }
    @IBAction func l4(_ sender: Any) {
        leftButtonPress(4, sender)
    }
    @IBAction func l5(_ sender: Any) {
        leftButtonPress(5, sender)
    }
    @IBAction func l6(_ sender: Any) {
        leftButtonPress(6, sender)
    }
    @IBAction func l7(_ sender: Any) {
        leftButtonPress(7, sender)
    }
    @IBAction func l8(_ sender: Any) {
        leftButtonPress(8, sender)
    }
    @IBAction func l9(_ sender: Any) {
        leftButtonPress(9, sender)
    }
    @IBAction func l10(_ sender: Any) {
        leftButtonPress(10, sender)
    }
    @IBAction func l11(_ sender: Any) {
        leftButtonPress(11, sender)
    }
    @IBAction func l12(_ sender: Any) {
        leftButtonPress(12, sender)
    }
    @IBAction func l13(_ sender: Any) {
        leftButtonPress(13, sender)
    }
    @IBAction func l14(_ sender: Any) {
        leftButtonPress(14, sender)
    }
    @IBAction func l15(_ sender: Any) {
        leftButtonPress(15, sender)
    }
    @IBAction func l16(_ sender: Any) {
        leftButtonPress(16, sender)
    }
    @IBAction func l17(_ sender: Any) {
        leftButtonPress(17, sender)
    }
    @IBAction func l18(_ sender: Any) {
        leftButtonPress(18, sender)
    }
    @IBAction func l19(_ sender: Any) {
        leftButtonPress(19, sender)
    }
    @IBAction func l20(_ sender: Any) {
        leftButtonPress(20, sender)
    }
    @IBAction func l21(_ sender: Any) {
        leftButtonPress(21, sender)
    }
    @IBAction func l22(_ sender: Any) {
        leftButtonPress(22, sender)
    }
    @IBAction func l23(_ sender: Any) {
        leftButtonPress(23, sender)
    }
    @IBAction func l24(_ sender: Any) {
        leftButtonPress(24, sender)
    }
    @IBAction func l25(_ sender: Any) {
        leftButtonPress(25, sender)
    }
    @IBAction func l26(_ sender: Any) {
        leftButtonPress(26, sender)
    }
    @IBAction func l27(_ sender: Any) {
        leftButtonPress(27, sender)
    }
    @IBAction func l28(_ sender: Any) {
        leftButtonPress(28, sender)
    }
    @IBAction func l29(_ sender: Any) {
        leftButtonPress(29, sender)
    }
    @IBAction func l30(_ sender: Any) {
        leftButtonPress(30, sender)
    }
    @IBAction func l31(_ sender: Any) {
        leftButtonPress(31, sender)
    }
    @IBAction func l32(_ sender: Any) {
        leftButtonPress(32, sender)
    }
    @IBAction func l33(_ sender: Any) {
        leftButtonPress(33, sender)
    }
    @IBAction func l34(_ sender: Any) {
        leftButtonPress(34, sender)
    }
    @IBAction func l35(_ sender: Any) {
        leftButtonPress(35, sender)
    }
    @IBAction func l36(_ sender: Any) {
        leftButtonPress(36, sender)
    }
    @IBAction func l37(_ sender: Any) {
        leftButtonPress(37, sender)
    }
    @IBAction func l38(_ sender: Any) {
        leftButtonPress(38, sender)
    }
    @IBAction func l39(_ sender: Any) {
        leftButtonPress(39, sender)
    }
    @IBAction func l40(_ sender: Any) {
        leftButtonPress(40, sender)
    }
    
    func leftButtonPress(_ index: Int, _ sender: Any) {
        print("\(index-1) \(bagArray[index-1])")
        moveCount += 1
        
        if bagArray[index-1] == lookingForTile {
            lookingForTile += 1
            bagArray[index-1] = 0
            
            var nonZeroCount = 0
            for val in bagArray {
                if val != 0 {
                    nonZeroCount += 1
                }
            }
            if nonZeroCount == 0 {
                whichBag += 1
                if whichBag > 3 {
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
                        self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_NUMBERSGAME_TIME)
                    }
                    alertController.addAction(okAction)
                    alertController.addAction(submitScoreAction)
                    alertController.addAction(submitScoreAndGoAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    OpenBag(whichBag)
                }
            }
        }else {
            UIView.animate(withDuration: 0.35, animations: {
                (sender as! UIButton).transform = CGAffineTransform(rotationAngle: 0)
            })
        }
        UpdateUi()
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_NUMBERSGAME_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_NUMBERSGAME_MOVES)
    }
    
}
