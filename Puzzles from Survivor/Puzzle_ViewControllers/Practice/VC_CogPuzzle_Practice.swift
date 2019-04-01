//
//  VC_CogPuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/5/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_CogPuzzle_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    let LEADERBOARD_ID_COGPUZZLE_TIME = "com.score_cogpuzzle_time.puzzlesfromsurvivor"    //Best Time - Cog Puzzle
    let LEADERBOARD_ID_COGPUZZLE_MOVES = "com.score_cogpuzzle_moves.puzzlesfromsurvivor"  //Fewest Moves - Cog Puzzle
    
    var cogImageArray: [UIImageView] = []
    var cogButtonArray_top: [UIButton] = []
    var cogButtonArray_bottom: [UIButton] = []
    var placedCogs_top: [Int] = []
    var availableCogs_bottom: [Int] = []
//    var initialCGRectArray: [CGRect] = []
//
//    var initialPegWidth: CGFloat = 0.0
//    var initialPegHeight: CGFloat = 0.0
//    var initialImgWidth: CGFloat = 0.0
//    var initialImgHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cogImageArray = [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19]
        cogButtonArray_top = [b0_o, b1o, b2o, b3o, b4o, b5o, b6o, b7o, b8o, b9o, b10o, b11o, b12o, b13o, b14o, b15o, b16o, b170, b18o, b19o]
        cogButtonArray_bottom = [b70_0o, b70_1o, b46_0o, b46_1o, b42o, b38o, b30_0o, b30_1o, b26o]
        
        b0_o.setImage(UIImage(named: "transparent"), for: .normal)
        b19o.setImage(UIImage(named: "transparent"), for: .normal)
        
        //get all initial positions and sizes
//        initialCGRectArray.removeAll()
//        for button in cogButtonArray_top {
//            initialCGRectArray.append(button.frame)
//        }
//        initialPegWidth = b0_o.frame.width
//        initialPegHeight = b0_o.frame.height
//        initialImgWidth = i0.frame.width
//        initialImgHeight = i0.frame.height
        
        NewGame()
        
        authenticateLocalPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.b0_o.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
//        b0_o.frame.size = CGSize(width: initialPegWidth * 2, height: initialPegWidth * 2)
        //b0_o.frame = CGRect(x: b0_o.frame.origin.x - initialPegWidth/2, y: b0_o.frame.origin.y - initialPegWidth/2, width: initialPegWidth * 2, height: initialPegWidth * 2)
        //print(b0_o.frame.origin.x)
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
    
    enum Selected {
        case None
        case Top
        case Bottom
    }
    var selected = Selected.None
    
    var timer = Timer()
    var timerCount = 0.0
    var moveCount = 0
    let TIMER_INCREMENT = 0.1
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    @IBOutlet weak var i0: UIImageView!
    @IBOutlet weak var i1: UIImageView!
    @IBOutlet weak var i2: UIImageView!
    @IBOutlet weak var i3: UIImageView!
    @IBOutlet weak var i4: UIImageView!
    @IBOutlet weak var i5: UIImageView!
    @IBOutlet weak var i6: UIImageView!
    @IBOutlet weak var i7: UIImageView!
    @IBOutlet weak var i8: UIImageView!
    @IBOutlet weak var i9: UIImageView!
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
    @IBOutlet weak var b0_o: UIButton!
    @IBOutlet weak var b1o: UIButton!
    @IBOutlet weak var b2o: UIButton!
    @IBOutlet weak var b3o: UIButton!
    @IBOutlet weak var b4o: UIButton!
    @IBOutlet weak var b5o: UIButton!
    @IBOutlet weak var b6o: UIButton!
    @IBOutlet weak var b7o: UIButton!
    @IBOutlet weak var b8o: UIButton!
    @IBOutlet weak var b9o: UIButton!
    @IBOutlet weak var b10o: UIButton!
    @IBOutlet weak var b11o: UIButton!
    @IBOutlet weak var b12o: UIButton!
    @IBOutlet weak var b13o: UIButton!
    @IBOutlet weak var b14o: UIButton!
    @IBOutlet weak var b15o: UIButton!
    @IBOutlet weak var b16o: UIButton!
    @IBOutlet weak var b170: UIButton!
    @IBOutlet weak var b18o: UIButton!
    @IBOutlet weak var b19o: UIButton!
    @IBAction func b0(_ sender: Any) {
        topCogSelected(cogIndex: 0)
    }
    @IBAction func b1(_ sender: Any) {
        topCogSelected(cogIndex: 1)
    }
    @IBAction func b2(_ sender: Any) {
        topCogSelected(cogIndex: 2)
    }
    @IBAction func b3(_ sender: Any) {
        topCogSelected(cogIndex: 3)
    }
    @IBAction func b4(_ sender: Any) {
        topCogSelected(cogIndex: 4)
    }
    @IBAction func b5(_ sender: Any) {
        topCogSelected(cogIndex: 5)
    }
    @IBAction func b6(_ sender: Any) {
        topCogSelected(cogIndex: 6)
    }
    @IBAction func b7(_ sender: Any) {
        topCogSelected(cogIndex: 7)
    }
    @IBAction func b8(_ sender: Any) {
        topCogSelected(cogIndex: 8)
    }
    @IBAction func b9(_ sender: Any) {
        topCogSelected(cogIndex: 9)
    }
    @IBAction func b10(_ sender: Any) {
        topCogSelected(cogIndex: 10)
    }
    @IBAction func b11(_ sender: Any) {
        topCogSelected(cogIndex: 11)
    }
    @IBAction func b12(_ sender: Any) {
        topCogSelected(cogIndex: 12)
    }
    @IBAction func b13(_ sender: Any) {
        topCogSelected(cogIndex: 13)
    }
    @IBAction func b14(_ sender: Any) {
        topCogSelected(cogIndex: 14)
    }
    @IBAction func b15(_ sender: Any) {
        topCogSelected(cogIndex: 15)
    }
    @IBAction func b16(_ sender: Any) {
        topCogSelected(cogIndex: 16)
    }
    @IBAction func b17(_ sender: Any) {
        topCogSelected(cogIndex: 17)
    }
    @IBAction func b18(_ sender: Any) {
        topCogSelected(cogIndex: 18)
    }
    @IBAction func b19(_ sender: Any) {
        topCogSelected(cogIndex: 19)
    }
    
    @IBOutlet weak var b70_0o: UIButton!
    @IBOutlet weak var b70_1o: UIButton!
    @IBOutlet weak var b46_0o: UIButton!
    @IBOutlet weak var b46_1o: UIButton!
    @IBOutlet weak var b42o: UIButton!
    @IBOutlet weak var b38o: UIButton!
    @IBOutlet weak var b30_0o: UIButton!
    @IBOutlet weak var b30_1o: UIButton!
    @IBOutlet weak var b26o: UIButton!
    @IBAction func b70_0(_ sender: Any) {
        bottomCogSelected(size: 70, index: 0)
    }
    @IBAction func b70_1(_ sender: Any) {
        bottomCogSelected(size: 70, index: 1)
    }
    @IBAction func b46_0(_ sender: Any) {
        bottomCogSelected(size: 46, index: 2)
    }
    @IBAction func b46_1(_ sender: Any) {
        bottomCogSelected(size: 46, index: 3)
    }
    @IBAction func b42(_ sender: Any) {
        bottomCogSelected(size: 42, index: 4)
    }
    @IBAction func b38(_ sender: Any) {
        bottomCogSelected(size: 38, index: 5)
    }
    @IBAction func b30_0(_ sender: Any) {
        bottomCogSelected(size: 30, index: 6)
    }
    @IBAction func b30_1(_ sender: Any) {
        bottomCogSelected(size: 30, index: 7)
    }
    @IBAction func b26(_ sender: Any) {
        bottomCogSelected(size: 26, index: 8)
    }
    
    let Last_COG_INDEX = 0
    let First_COG_INDEX = 19
    
    func topCogSelected(cogIndex: Int) {
        print("Top Index: \(cogIndex)")
        if cogIndex == Last_COG_INDEX || cogIndex == First_COG_INDEX || sizeString.isInt == false {
            print("No action: First or last")
            return  //the first and last cog cannot be replaced, sizeString must me an Int
        }
        
        let sizeInt = Int(sizeString)!
        
        if placedCogs_top[cogIndex] == 0 && selected == .None { //There is NOT a cog where you are trying to place and you haven't selected one from the bottom
            print("No action: Empty, no cog selected")
            return
        }
        
        if placedCogs_top[cogIndex] > 0 || selected == .None {  //there IS a cog where you are trying to place a cog OR you are trying to return a cog
            //var tempIndex = -1
            if placedCogs_top[cogIndex] == 70 {
                if b70_0o.isHidden {
                    b70_0o.isHidden = false
                    //tempIndex = 0
                }else if b70_1o.isHidden {
                    b70_1o.isHidden = false
                    //tempIndex = 1
                }
            }
            if placedCogs_top[cogIndex] == 46 {
                if b46_0o.isHidden {
                    b46_0o.isHidden = false
                    //tempIndex = 2
                }else if b46_1o.isHidden {
                    b46_1o.isHidden = false
                    //tempIndex = 3
                }
            }
            if placedCogs_top[cogIndex] == 42 {
                if b42o.isHidden {
                    b42o.isHidden = false
                    //tempIndex = 4
                }
            }
            if placedCogs_top[cogIndex] == 38 {
                if b38o.isHidden {
                    b38o.isHidden = false
                    //tempIndex = 5
                }
            }
            if placedCogs_top[cogIndex] == 30 {
                if b30_0o.isHidden {
                    b30_0o.isHidden = false
                    //tempIndex = 6
                }else if b30_1o.isHidden {
                    b30_1o.isHidden = false
                    //tempIndex = 7
                }
            }
            if placedCogs_top[cogIndex] == 26 {
                if b26o.isHidden {
                    b26o.isHidden = false
                    //tempIndex = 8
                }
            }
            
            availableCogs_bottom.append(placedCogs_top[cogIndex])
            //let tempSize = placedCogs_top[cogIndex]
            placedCogs_top[cogIndex] = 0
            
            //if selected == .None {
                cogImageArray[cogIndex].image = UIImage(named: "transparent")
                //cogButtonArray_top[cogIndex].frame = initialCGRectArray[cogIndex]   //set image back to original size/position
                cogButtonArray_top[cogIndex].setImage(UIImage(named: "rockCircle_boarder"), for: .normal)
                //bottomCogSelected(size: tempSize, index: tempIndex)
                moveCount += 1
                Label_MoveCount.text = "\(moveCount)"
            //}
            return
        }
        
        if selected == .None || sizeInt <= 0 {
            return
        }
        
        if placedCogs_top[cogIndex] == 0 {  //there is NOT a cog where you are trying to place a cog
            placedCogs_top[cogIndex] = sizeInt
            cogImageArray[cogIndex].image = UIImage(named: "cog\(sizeString)")
//            cogButtonArray_top[cogIndex].frame = initialCGRectArray[cogIndex]   //set image back to original size/position
//            let newWidth = CGFloat(sizeInt) / 100.0 * initialImgWidth
//            cogButtonArray_top[cogIndex].frame = CGRect(x: cogButtonArray_top[cogIndex].frame.origin.x - newWidth/4, //change to new size/posistion
//                                                        y: cogButtonArray_top[cogIndex].frame.origin.y - newWidth/4,
//                                                        width: newWidth,
//                                                        height: newWidth)
//            cogButtonArray_top[cogIndex].setImage(UIImage(named: "transparent"), for: .normal)
            
            var i = 0
            for val in availableCogs_bottom {
                if val == sizeInt {
                    availableCogs_bottom.remove(at: i)
                    updateHidden_bottom()
                    break
                }
                i += 1
            }
        }
        
        for button in cogButtonArray_bottom {
            button.alpha = 1.0
        }
        selected = .None
        selectedIndex = -1
        sizeString = "0"
        
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        
    }
    
    func updateHidden_bottom() {
        if selectedIndex >= 0 {
            cogButtonArray_bottom[selectedIndex].isHidden = true
        }
    }
    
    var sizeString = "0"
    var selectedIndex = -1
    func bottomCogSelected(size: Int, index: Int) {
        havePressedBottom = true
        sizeString = "\(size)"
        selectedIndex = index
        selected = .Bottom
        
        for button in cogButtonArray_bottom {
            button.alpha = 0.5
        }
        if size == 70 {
            b70_0o.alpha = 1.0
            b70_1o.alpha = 1.0
        }else if size == 46 {
            b46_0o.alpha = 1.0
            b46_1o.alpha = 1.0
        }else if size == 42 {
            b42o.alpha = 1.0
        }else if size == 38 {
            b38o.alpha = 1.0
        }else if size == 30 {
            b30_0o.alpha = 1.0
            b30_1o.alpha = 1.0
        }else if size == 26 {
            b26o.alpha = 1.0
        }
    }
    
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    var havePressedBottom = false
    func NewGame() {
        didWin = false
        
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        Label_YouWin.text = ""
        
        timerCount = 0.0
        timerLabel.text = String(format: "%.1f", timerCount)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        
        var i = 0
        for image in cogImageArray {
            if i != First_COG_INDEX && i != Last_COG_INDEX {
                image.image = UIImage(named: "transparent")
            }
            i += 1
        }
        i = 0
//        for button in cogButtonArray_top {
//            button.frame = initialCGRectArray[i]   //set image back to original size/position
//            button.setImage(UIImage(named: "rockCircle_boarder"), for: .normal)
//            i += 1
//        }
        for button in cogButtonArray_bottom {
            button.isHidden = false
        }
        
        placedCogs_top = [44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 19]
        availableCogs_bottom = [70, 70, 46, 46, 42, 38, 30, 30, 26]
        
        selected = .None
        havePressedBottom = false
        
        UpdateUi()
    }
    
    func UpdateUi () {
    }
    
    var blinkTimer = 0.0
    var rotation: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var didWin = false
    @objc func inrementTimer() {
        if didWin == false {
            timerCount += TIMER_INCREMENT
            timerLabel.text = String(format: "%.1f", timerCount)
        }
        
        var alphaVal: CGFloat = 1.0
        
        if blinkTimer <= 0.7 {
            alphaVal = 1.0
        }else if blinkTimer <= 1.0 {
            alphaVal = 0.5
        }else {
            blinkTimer = 0
        }
        blinkTimer += TIMER_INCREMENT
        
        if selected == .None {
            if havePressedBottom == false {
                for button in cogButtonArray_bottom {
                    button.alpha = alphaVal
                }
            }
            for button in cogButtonArray_top {
                button.alpha = 1.0
            }
        }else if selected == .Bottom {
            var i = 0
            for button in cogButtonArray_top {
                if i != First_COG_INDEX && i != Last_COG_INDEX {
                    button.alpha = alphaVal
                }
                i += 1
            }
        }
        
        //cogImageArray = [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15, i16, i17, i18, i19]
        //[70, 70, 46, 46, 42, 38, 30, 30, 26]
        rotation[0] += 420.0 / 42.0
        UIView.animate(withDuration: TIMER_INCREMENT, animations: {
            self.i19.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[0] * .pi) / 180.0))
        })
        if placedCogs_top[10] == 70 {
            rotation[1] -= 420.0 / 70
            UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                self.i10.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[1] * .pi) / 180.0))
            })
            if placedCogs_top[18] == 26 {
                rotation[2] += 420.0 / 26
                UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                    self.i18.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[2] * .pi) / 180.0))
                })
                if placedCogs_top[16] == 30 {
                    rotation[3] -= 420.0 / 30
                    UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                        self.i16.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[3] * .pi) / 180.0))
                    })
                    if placedCogs_top[5] == 46 {
                        rotation[4] += 420.0 / 46
                        UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                            self.i5.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[4] * .pi) / 180.0))
                        })
                        if placedCogs_top[12] == 70 {
                            rotation[5] -= 420.0 / 70
                            UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                self.i12.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[5] * .pi) / 180.0))
                            })
                            var didInc = false
                            if placedCogs_top[4] == 42 {
                                didInc = true
                                rotation[6] += 420.0 / 42
                                UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                    self.i4.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[6] * .pi) / 180.0))
                                })
                            }
                            
                            if placedCogs_top[13] == 30 {
                                if didInc == false {
                                    rotation[6] += 420.0 / 30
                                }
                                UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                    self.i13.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[6] * .pi) / 180.0))
                                })
                                if placedCogs_top[9] == 42 {
                                    rotation[7] -= 420.0 / 42
                                    UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                        self.i9.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[7] * .pi) / 180.0))
                                    })
                                    if placedCogs_top[8] == 38 {
                                        rotation[8] += 420.0 / 38
                                        UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                            self.i8.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[8] * .pi) / 180.0))
                                        })
                                        if placedCogs_top[7] == 46 {
                                            rotation[9] -= 420.0 / 46
                                            UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                                self.i7.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[9] * .pi) / 180.0))
                                            })
                                            
                                            rotation[10] += 420.0 / 19
                                            UIView.animate(withDuration: TIMER_INCREMENT, animations: {
                                                self.i0.transform = CGAffineTransform(rotationAngle: CGFloat((self.rotation[10] * .pi) / 180.0))
                                            })
                                            
                                            if didWin == false {
                                                didWin = true
                                                Label_YouWin.text = "You Win!"
                                                
                                                appDelegate.puzzlesCompleted += 1
                                                appDelegate.pcc_CogPuzzle += 1
                                                Defaults().save_Defaults(updateStreak: true)
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
                                                    self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_COGPUZZLE_TIME)
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
                        }
                    }
                }
            }
        }
        
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 10), leaderBoardID: self.LEADERBOARD_ID_COGPUZZLE_TIME)
        self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_COGPUZZLE_MOVES)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
