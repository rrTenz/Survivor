//
//  VC_SlidePuzzle2_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 10/11/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_SlidePuzzle2_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_SLIDE8_TIME = "com.score_slide8_time.puzzlesfromsurvivor"    //Best Time - 8 Piece Slide Puzzle
    let LEADERBOARD_ID_SLIDE8_MOVES = "com.score_slide8_moves.puzzlesfromsurvivor"  //Fewest Moves - 8 Piece Slide Puzzle
    
    @IBOutlet weak var BorderTop: UIImageView!
    @IBOutlet weak var BorderMidLeft: UIImageView!
    @IBOutlet weak var BorderMidRight: UIImageView!
    @IBOutlet weak var BorderBottom: UIImageView!
    @IBOutlet weak var BorderLeft: UIImageView!
    @IBOutlet weak var BorderRight: UIImageView!
    @IBOutlet weak var BorderLeftSmall: UIImageView!
    @IBOutlet weak var BorderRightSmall: UIImageView!
    
    @IBOutlet weak var WinningImage: UIImageView!
    
    @IBOutlet weak var BlockSquare: UIImageView!
    @IBOutlet weak var BlockSmall1: UIImageView!
    @IBOutlet weak var BlockSmall2: UIImageView!
    @IBOutlet weak var BlockSmall3: UIImageView!
    @IBOutlet weak var BlockSmall4: UIImageView!
    @IBOutlet weak var BlockRect1: UIImageView!
    @IBOutlet weak var BlockRect2: UIImageView!
    @IBOutlet weak var BlockRect3: UIImageView!
    
    var images: [UIImageView] = []
    var imagesBoarder: [UIImageView] = []
    var imagesBlocks: [UIImageView] = []
    var originalCenters: [CGPoint] = []
    
//    @IBOutlet weak var Label_Time: UILabel!
//    @IBOutlet weak var Label_Moves: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        images.removeAll()
        images.append(BorderTop)
        images.append(BorderMidLeft)
        images.append(BorderMidRight)
        images.append(BorderBottom)
        images.append(BorderLeft)
        images.append(BorderRight)
        images.append(BorderLeftSmall)
        images.append(BorderRightSmall)
        images.append(WinningImage)
        images.append(BlockSquare)
        images.append(BlockSmall1)
        images.append(BlockSmall2)
        images.append(BlockSmall3)
        images.append(BlockSmall4)
        images.append(BlockRect1)
        images.append(BlockRect2)
        images.append(BlockRect3)
        
        imagesBoarder.removeAll()
        imagesBoarder.append(BorderTop)
        imagesBoarder.append(BorderMidLeft)
        imagesBoarder.append(BorderMidRight)
        imagesBoarder.append(BorderBottom)
        imagesBoarder.append(BorderLeft)
        imagesBoarder.append(BorderRight)
        imagesBoarder.append(BorderLeftSmall)
        imagesBoarder.append(BorderRightSmall)
        
        imagesBlocks.removeAll()
        imagesBlocks.append(BlockSquare)
        print("BlockSquare.center \(BlockSquare.center)")
        imagesBlocks.append(BlockSmall1)
        imagesBlocks.append(BlockSmall2)
        imagesBlocks.append(BlockSmall3)
        imagesBlocks.append(BlockSmall4)
        imagesBlocks.append(BlockRect1)
        imagesBlocks.append(BlockRect2)
        imagesBlocks.append(BlockRect3)
        
        originalCenters.removeAll()
        originalCenters.append(BlockSquare.center)
        print("originalCenters \(originalCenters[0])")
        originalCenters.append(BlockSmall1.center)
        originalCenters.append(BlockSmall2.center)
        originalCenters.append(BlockSmall3.center)
        originalCenters.append(BlockSmall4.center)
        originalCenters.append(BlockRect1.center)
        originalCenters.append(BlockRect2.center)
        originalCenters.append(BlockRect3.center)
        
        NewGame()        
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
    
    var val = 0
    var startX: CGFloat = -1.0
    var startY: CGFloat = -1.0
    var lastX: CGFloat = -1.0
    var lastY: CGFloat = -1.0
    var moveLeftRight = false
    var moveUpDown = false
    func moveImage(_ touches: Set<UITouch>) {
        var str = ""
        var currX: CGFloat = -1.0
        var currY: CGFloat = -1.0
        var useX: CGFloat = -1.0
        var useY: CGFloat = -1.0
        moveLeftRight = false
        moveUpDown = false
        if lastX == -1.0 || lastY == -1.0 {
            useX = startX
            useY = startY
        }else {
            useX = lastX
            useY = lastY
        }
        if let touch = touches.first {
            let position = touch.location(in: view)
            currX = position.x
            currY = position.y
        }
        let diffX = abs(currX - useX)
        let diffY = abs(currY - useY)
//        str += " currX \(currX) currY \(currY)"
//        print(str)
        if diffX > 20 || diffY > 20 {
            if let touch = touches.first {
                let position = touch.location(in: view)
                lastX = position.x
                lastY = position.y
            }
            return
        }
        if diffX > diffY {
            moveLeftRight = true
            str += " LR"
        }else {
            moveUpDown = true
            str += " UD"
        }
        
        //This is for when the user's finger is on the block
        var didMove = false
        for touch in touches {
            let location = touch.location(in: self.view)
            
            for image in imagesBlocks {
                if image.frame.contains(location){
                    let loc_prev = image.center
                    didMove = true
                    if moveLeftRight {
                        image.center.x += currX - useX
                    }else if moveUpDown {
                        image.center.y += currY - useY
                    }
                    
                    for image2 in images {
                        if image.center != image2.center {
                            
                            if image.frame.intersects(image2.frame) {
                                if (image.center == BlockSquare.center && image2.center == WinningImage.center) ||
                                    (image2.center == BlockSquare.center && image.center == WinningImage.center) {
                                    checkForWin()
                                    return  // let the BlockSquare on the Winning Image intersect
                                }
                                
                                //print("blah \(val)")
                                val += 1
                                image.center = loc_prev
                            }
                        }
                    }
                }
            }
        }
        
        //This is for when an image has been touched, but the user's finger is no longer on the block
        if selectedIndex >= 0 && didMove == false {
            let loc_prev = imagesBlocks[selectedIndex].center
            if moveLeftRight {
                imagesBlocks[selectedIndex].center.x += currX - useX
            }else if moveUpDown {
                imagesBlocks[selectedIndex].center.y += currY - useY
            }
            
            for image2 in images {
                if imagesBlocks[selectedIndex].center != image2.center {
                    
                    if imagesBlocks[selectedIndex].frame.intersects(image2.frame) {
                        if (imagesBlocks[selectedIndex].center == BlockSquare.center && image2.center == WinningImage.center) ||
                            (image2.center == BlockSquare.center && imagesBlocks[selectedIndex].center == WinningImage.center) {
                            checkForWin()
                            return  // let the BlockSquare on the Winning Image intersect
                        }
                        
                        //print("blah \(val)")
                        val += 1
                        imagesBlocks[selectedIndex].center = loc_prev
                    }
                }
            }
        }
        
        
        if let touch = touches.first {
            let position = touch.location(in: view)
            lastX = position.x
            lastY = position.y
        }
    }
    
    func checkForWin() {
        if BlockSquare.center.y >= WinningImage.center.y {
            YouWin()
        }
    }
    
    var selectedIndex = -1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveCount += 1
        //Label_Moves.text = "\(moveCount)"
        if let touch = touches.first {
            let position = touch.location(in: view)
            startX = position.x
            startY = position.y
        }
        
        var i = 0
        for touch in touches {
            let location = touch.location(in: self.view)
            
            i = 0
            for image in imagesBlocks {
                if image.frame.contains(location){
                    selectedIndex = i
                }
                i += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveImage(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastX = 0
        lastY = 0
        startX = 0
        startY = 0
        selectedIndex = -1
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    var timerCount = 0.0
    var moveCount: Int = 0
    let TIMER_INCREMENT = 0.01
    var timer = Timer()
    func NewGame() {
        var i = 0
        print("BlockSquare.center \(BlockSquare.center)")
        for _ in imagesBlocks {
            imagesBlocks[i].center = originalCenters[i]
            i += 1
        }
        print("BlockSquare.center \(BlockSquare.center)")
        timerCount = 0
        //Label_Time.text = String(format: "%.2f", timerCount)
        moveCount = 0
        //Label_Moves.text = "\(moveCount)"
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
    }
    
    @objc func inrementTimer() {
        timerCount += TIMER_INCREMENT
        //Label_Time.text = String(format: "%.2f", timerCount)
    }
    
    func YouWin() {
        timer.invalidate()
        let timeString = String(format: "%.2f", timerCount)
        let alertController = UIAlertController(title: "You Win", message: "Good job!\nYou completed the puzzle!\n\nMove Count: \(moveCount)\nSeconds: \(timeString)", preferredStyle: .alert)
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
            self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_SLIDE8_TIME)
        }
        alertController.addAction(okAction)
        alertController.addAction(submitScoreAction)
        alertController.addAction(submitScoreAndGoAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func submitScore() {
        self.submitScoreToGC(score: Int(self.timerCount * 100), leaderBoardID: self.LEADERBOARD_ID_SLIDE8_TIME)
        self.submitScoreToGC(score: Int(self.moveCount), leaderBoardID: self.LEADERBOARD_ID_SLIDE8_MOVES)
    }
}
