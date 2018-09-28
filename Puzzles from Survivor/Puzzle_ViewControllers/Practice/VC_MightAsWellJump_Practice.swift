//
//  VC_MightAsWellJump_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 9/19/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

class VC_MightAsWellJump_Practice: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_ID_WHEEL = "com.score_wheel.puzzlesfromsurvivor"    //Might as Well Jump
    let LEADERBOARD_ID_WHEEL_TIME_STANDARD = "com.score_wheel_time_standard.puzzlesfromsurvivor"    //Best Time (Standard) - Might as Well Jump
    let LEADERBOARD_ID_WHEEL_MOVES_STANDARD = "com.score_wheel_moves_standard.puzzlesfromsurvivor"  //Fewest Moves (Standard) - Might as Well Jump
    let LEADERBOARD_ID_WHEEL_TIME_RANDOM = "com.score_wheel_time_random.puzzlesfromsurvivor"        //Best Time (Random) - Might as Well Jump
    let LEADERBOARD_ID_WHEEL_MOVES_RANDOM = "com.score_wheel_moves_random.puzzlesfromsurvivor"      //Fewest Moves (Random) - Might as Well Jump
    
    
    @IBOutlet weak var View_Wheel: UIView!
    @IBOutlet weak var View_1: UIView!
    @IBOutlet weak var View_2: UIView!
    @IBOutlet weak var View_3: UIView!
    @IBOutlet weak var View_4: UIView!
    @IBOutlet weak var View_5: UIView!
    @IBOutlet weak var View_6: UIView!
    
    @IBOutlet weak var ball_1_0: UIImageView!
    @IBOutlet weak var ball_1_1: UIImageView!
    @IBOutlet weak var ball_1_2: UIImageView!
    @IBOutlet weak var ball_1_3: UIImageView!
    @IBOutlet weak var ball_1_4: UIImageView!
    
    @IBOutlet weak var ball_2_0: UIImageView!
    @IBOutlet weak var ball_2_1: UIImageView!
    @IBOutlet weak var ball_2_2: UIImageView!
    @IBOutlet weak var ball_2_3: UIImageView!
    @IBOutlet weak var ball_2_4: UIImageView!
    
    @IBOutlet weak var ball_3_0: UIImageView!
    @IBOutlet weak var ball_3_1: UIImageView!
    @IBOutlet weak var ball_3_2: UIImageView!
    @IBOutlet weak var ball_3_3: UIImageView!
    @IBOutlet weak var ball_3_4: UIImageView!
    
    @IBOutlet weak var ball_4_0: UIImageView!
    @IBOutlet weak var ball_4_1: UIImageView!
    @IBOutlet weak var ball_4_2: UIImageView!
    @IBOutlet weak var ball_4_3: UIImageView!
    @IBOutlet weak var ball_4_4: UIImageView!
    
    @IBOutlet weak var ball_5_0: UIImageView!
    @IBOutlet weak var ball_5_1: UIImageView!
    @IBOutlet weak var ball_5_2: UIImageView!
    @IBOutlet weak var ball_5_3: UIImageView!
    @IBOutlet weak var ball_5_4: UIImageView!
    
    @IBOutlet weak var ball_6_0: UIImageView!
    @IBOutlet weak var ball_6_1: UIImageView!
    @IBOutlet weak var ball_6_2: UIImageView!
    @IBOutlet weak var ball_6_3: UIImageView!
    @IBOutlet weak var ball_6_4: UIImageView!
    
    @IBOutlet weak var Label_MoveCount: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var timerCount = 0
    var moveCount = 0
    
    enum BallColor: String {
        case Yellow = "blob_yellow"
        case Orange = "blob_orange"
        case Red = "blob_red"
        case Blue = "blob_dark_blue"
        case Green = "blob_green"
        case Empty = ""
    }
    
    var RackAll: [[BallColor]] = [[.Empty],             //Rack Middle
        [.Empty, .Empty, .Empty, .Empty, .Empty],//Rack1
        [.Orange, .Green, .Red, .Blue, .Yellow], //Rack2
        [.Orange, .Red, .Green, .Blue, .Yellow], //Rack3
        [.Orange, .Red, .Blue, .Green, .Yellow], //Rack4
        [.Blue, .Green, .Orange, .Red, .Yellow], //Rack5
        [.Blue, .Orange, .Red, .Green, .Yellow]] //Rack6
    
    let RACK_COUNT = 6
    let DEGREE_DIFF: CGFloat = 60.0
    let MAX_BALLS = 5
    
    var isStandardGame = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchorY = -0.15
        self.View_1.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_2.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_3.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_4.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_5.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_6.setAnchorPoint(CGPoint(x: 0.5, y: anchorY))
        self.View_1.transform = CGAffineTransform(rotationAngle: (0 * DEGREE_DIFF * .pi) / 180.0)
        self.View_2.transform = CGAffineTransform(rotationAngle: (1 * DEGREE_DIFF * .pi) / 180.0)
        self.View_3.transform = CGAffineTransform(rotationAngle: (2 * DEGREE_DIFF * .pi) / 180.0)
        self.View_4.transform = CGAffineTransform(rotationAngle: (3 * DEGREE_DIFF * .pi) / 180.0)
        self.View_5.transform = CGAffineTransform(rotationAngle: (4 * DEGREE_DIFF * .pi) / 180.0)
        self.View_6.transform = CGAffineTransform(rotationAngle: (5 * DEGREE_DIFF * .pi) / 180.0)
        
        //self.Button_Middle_outlet.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(VC_MightAsWellJump_Practice.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(VC_MightAsWellJump_Practice.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        let up = UISwipeGestureRecognizer(target : self, action : #selector(VC_MightAsWellJump_Practice.upSwipe))
        up.direction = .up
        self.view.addGestureRecognizer(up)
        
        let down = UISwipeGestureRecognizer(target : self, action : #selector(VC_MightAsWellJump_Practice.downSwipe))
        down.direction = .down
        self.view.addGestureRecognizer(down)
        
        authenticateLocalPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alertController = UIAlertController(title: "Instructions", message: "To spin the wheel\nSwipe Left/Right or Up/Down\n\nTo move balls In/Out of the middle\nTap the rack or the center", preferredStyle: .alert)
        let standardAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.StartNewGame_alert()
        }
        alertController.addAction(standardAction)
        self.present(alertController, animated: true, completion: nil)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        StartNewGame_alert()
    }
    
    @IBAction func Button_Leaderboards(_ sender: Any) {
        if self.isStandardGame {
            checkGCLeaderboard(leaderBoardID: LEADERBOARD_ID_WHEEL_TIME_STANDARD)
        }else {
            checkGCLeaderboard(leaderBoardID: LEADERBOARD_ID_WHEEL_TIME_RANDOM)
        }
    }
    
    func StartNewGame_alert() {
        let alertController = UIAlertController(title: "Random or Standard?", message: "Do you want the game to be\n'Random' or 'Standard?\n\nRandom: Balls will be placed randomly (usually harder)\n\nStandard: Same set up as on the episode (usually easier)", preferredStyle: .alert)
        let standardAction = UIAlertAction(title: "Standard", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            self.StartNewGame(isStandard: true)
        }
        let randomAction = UIAlertAction(title: "Random", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
            self.StartNewGame(isStandard: false)
        }
        alertController.addAction(randomAction)
        alertController.addAction(standardAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var timerStarted = false
    var currentRotation: CGFloat = 0.0
    func StartNewGame(isStandard: Bool) {
        isStandardGame = isStandard
        self.currentRotation = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.View_Wheel.transform = CGAffineTransform(rotationAngle: CGFloat((self.currentRotation * .pi) / 180.0))
        })
        
        calculateCurrentBottom()
        
        //Reset Racks
        RackAll = [[.Empty],                                //Rack Middle
            [.Empty, .Empty, .Empty, .Empty, .Empty],//Rack1
            [.Orange, .Green, .Red, .Blue, .Yellow], //Rack2
            [.Orange, .Red, .Green, .Blue, .Yellow], //Rack3
            [.Orange, .Red, .Blue, .Green, .Yellow], //Rack4
            [.Blue, .Green, .Orange, .Red, .Yellow], //Rack5
            [.Blue, .Orange, .Red, .Green, .Yellow]] //Rack6
        if isStandard == false {
            //Shuffle racks
            var index = 0
            for rack in RackAll {
                var items = rack
                var shuffled = [BallColor]()
                
                for _ in 0..<items.count
                {
                    let rand = Int(arc4random_uniform(UInt32(items.count)))
                    
                    shuffled.append(items[rand])
                    
                    items.remove(at: rand)
                }
                
                print(shuffled)
                RackAll[index] = shuffled
                index += 1
            }
        }
//        RackAll = [[.Empty],                                //Rack Middle
//            [.Empty, .Empty, .Empty, .Empty, .Empty],//Rack1
//            [.Green, .Blue, .Red, .Orange, .Yellow], //Rack2
//            [.Green, .Blue, .Red, .Orange, .Yellow], //Rack3
//            [.Green, .Blue, .Red, .Orange, .Yellow], //Rack4
//            [.Green, .Blue, .Red, .Orange, .Yellow], //Rack5
//            [.Green, .Blue, .Red, .Orange, .Yellow]] //Rack6
        updateUI()
        
        MiddleIsEmpty = true
        
        timerCount = 0
        timerLabel.text = "\(timerCount)"
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        timerStarted = true
        
        moveCount = 0
        Label_MoveCount.text = "\(moveCount)"
        
        Button_Done_outlet.setTitle("Done Jeff", for: .normal)
    }
    
    @objc func inrementTimer() {
        timerCount += 1
        timerLabel.text = "\(timerCount)"
    }
    
    @IBOutlet weak var Button_Done_outlet: UIButton!
    @IBAction func Button_Done(_ sender: Any) {
        if timerStarted {
            if lookForWin() == false {
                let alertController = UIAlertController(title: "No", message: "Something is wrong! Keep going!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else {
                timerStarted = false
                timer.invalidate()
                Button_Done_outlet.setTitle("Resume", for: .normal)
            }
        }else {
            timerStarted = true
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
            Button_Done_outlet.setTitle("Done Jeff", for: .normal)
        }
    }
    
    func updateUI() {
        
        Button_MiddleBall_outlet.setImage(UIImage(named: RackAll[0][0].rawValue), for: .normal)
        
        ball_1_0.image = UIImage(named: RackAll[1][0].rawValue)
        ball_1_1.image = UIImage(named: RackAll[1][1].rawValue)
        ball_1_2.image = UIImage(named: RackAll[1][2].rawValue)
        ball_1_3.image = UIImage(named: RackAll[1][3].rawValue)
        ball_1_4.image = UIImage(named: RackAll[1][4].rawValue)
        
        ball_2_0.image = UIImage(named: RackAll[2][0].rawValue)
        ball_2_1.image = UIImage(named: RackAll[2][1].rawValue)
        ball_2_2.image = UIImage(named: RackAll[2][2].rawValue)
        ball_2_3.image = UIImage(named: RackAll[2][3].rawValue)
        ball_2_4.image = UIImage(named: RackAll[2][4].rawValue)
        
        ball_3_0.image = UIImage(named: RackAll[3][0].rawValue)
        ball_3_1.image = UIImage(named: RackAll[3][1].rawValue)
        ball_3_2.image = UIImage(named: RackAll[3][2].rawValue)
        ball_3_3.image = UIImage(named: RackAll[3][3].rawValue)
        ball_3_4.image = UIImage(named: RackAll[3][4].rawValue)
        
        ball_4_0.image = UIImage(named: RackAll[4][0].rawValue)
        ball_4_1.image = UIImage(named: RackAll[4][1].rawValue)
        ball_4_2.image = UIImage(named: RackAll[4][2].rawValue)
        ball_4_3.image = UIImage(named: RackAll[4][3].rawValue)
        ball_4_4.image = UIImage(named: RackAll[4][4].rawValue)
        
        ball_5_0.image = UIImage(named: RackAll[5][0].rawValue)
        ball_5_1.image = UIImage(named: RackAll[5][1].rawValue)
        ball_5_2.image = UIImage(named: RackAll[5][2].rawValue)
        ball_5_3.image = UIImage(named: RackAll[5][3].rawValue)
        ball_5_4.image = UIImage(named: RackAll[5][4].rawValue)
        
        ball_6_0.image = UIImage(named: RackAll[6][0].rawValue)
        ball_6_1.image = UIImage(named: RackAll[6][1].rawValue)
        ball_6_2.image = UIImage(named: RackAll[6][2].rawValue)
        ball_6_3.image = UIImage(named: RackAll[6][3].rawValue)
        ball_6_4.image = UIImage(named: RackAll[6][4].rawValue)
    }
    
    var MiddleIsEmpty = true
    @IBOutlet weak var Button_Middle_outlet: UIButton!
    @IBAction func Button_Middle(_ sender: Any) {
        moveFromMiddle()
    }
    @IBOutlet weak var Button_MiddleBall_outlet: UIButton!
    @IBAction func Button_MiddleBall(_ sender: Any) {
        moveFromMiddle()
    }
    @IBAction func Button_BallPress_1(_ sender: Any) {
        moveToMiddle(press: 1)
    }
    @IBAction func Button_BallPress_2(_ sender: Any) {
        moveToMiddle(press: 2)
    }
    @IBAction func Button_BallPress_3(_ sender: Any) {
        moveToMiddle(press: 3)
    }
    @IBAction func Button_BallPress_4(_ sender: Any) {
        moveToMiddle(press: 4)
    }
    @IBAction func Button_BallPress_5(_ sender: Any) {
        moveToMiddle(press: 5)
    }
    @IBAction func Button_BallPress_6(_ sender: Any) {
        moveToMiddle(press: 6)
    }
    
    func moveToMiddle(press: Int) {
        if press != currentBottom {
            return
        }
        if RackAll[0][0] != .Empty {
            moveFromMiddle()
            return
        }
        
        var index = 0
        while(index < MAX_BALLS){
            if RackAll[currentBottom][index] != .Empty {
                break
            }
            index += 1
        }
        if index == MAX_BALLS {
            return
        }
        
        let temp = RackAll[currentBottom][index]
        RackAll[currentBottom][index] = RackAll[0][0]
        RackAll[0][0] = temp
        updateUI()
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        _ = lookForWin()
    }
    
    func moveFromMiddle() {
        if RackAll[0][0] == .Empty {
            moveToMiddle(press: currentBottom)
            return
        }
        if RackAll[currentBottom][0] != .Empty {
            return
        }
        
        var index = MAX_BALLS - 1
        while(index >= 0){
            if RackAll[currentBottom][index] == .Empty {
                break
            }
            index -= 1
        }
        if index < 0 {
            return
        }
        
        let temp = RackAll[currentBottom][index]
        RackAll[currentBottom][index] = RackAll[0][0]
        RackAll[0][0] = temp
        updateUI()
        moveCount += 1
        Label_MoveCount.text = "\(moveCount)"
        _ = lookForWin()
    }
    
    func lookForWin() -> Bool {
        var index = -1
        for rack in RackAll {
            index += 1
            if index == 0 {
                if rack[0] != .Empty {
                    return false    //have not won if there is a ball in the middle
                }
            }else if index == 1 {
                for ball in rack {
                    if ball != .Empty {
                        return false    //have not won if there is a ball in Rack 1
                    }
                }
            }else {
                if rack[0] != .Green || rack[1] != .Blue || rack[2] != .Red || rack[3] != .Orange || rack[4] != .Yellow {
                    return  false //have not won if the colors are in the wrong places
                }
            }
        }
        
        let alertController = UIAlertController(title: "You Win", message: "Good job!\nYou completed the puzzle!\n\nMoves: \(moveCount)\nSeconds: \(timerCount)", preferredStyle: .alert)
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
            if self.isStandardGame {
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_WHEEL_TIME_STANDARD)
            }else {
                self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_ID_WHEEL_TIME_RANDOM)
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(submitScoreAction)
        alertController.addAction(submitScoreAndGoAction)
        self.present(alertController, animated: true, completion: nil)
        
        timerStarted = false
        timer.invalidate()
        Button_Done_outlet.setTitle("Resume", for: .normal)
        
        return true
        
    }
    
    func submitScore() {
        if self.isStandardGame {
            self.submitScoreToGC(score: self.timerCount, leaderBoardID: self.LEADERBOARD_ID_WHEEL_TIME_STANDARD)
            self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_WHEEL_MOVES_STANDARD)
        }else {
            self.submitScoreToGC(score: self.timerCount, leaderBoardID: self.LEADERBOARD_ID_WHEEL_TIME_RANDOM)
            self.submitScoreToGC(score: self.moveCount, leaderBoardID: self.LEADERBOARD_ID_WHEEL_MOVES_RANDOM)
        }
    }
    
    @objc
    func leftSwipe(){
        print("Left Swipe")
        doRotation(degree: DEGREE_DIFF)
    }
    
    @objc
    func rightSwipe(){
        print("Right Swipe")
        doRotation(degree: -DEGREE_DIFF)
    }
    
    @objc
    func upSwipe(){
        print("Up Swipe")
        doRotation(degree: -DEGREE_DIFF)
    }
    
    @objc
    func downSwipe(){
        print("Down Swipe")
        doRotation(degree: DEGREE_DIFF)
    }
    
    func doRotation(degree: CGFloat) {
        UIView.animate(withDuration: 0.25, animations: {
            self.currentRotation += degree
            self.View_Wheel.transform = CGAffineTransform(rotationAngle: CGFloat((self.currentRotation * .pi) / 180.0))
        })
        
        calculateCurrentBottom()
    }
    
    var currentBottom = 1
    func calculateCurrentBottom() {
        var rotation = self.currentRotation
        
        while rotation < 0 {
            rotation += 360
        }
        while rotation >= 360 {
            rotation -= 360
        }
        
        self.currentRotation = rotation
        switch currentRotation {
        case 60:
            self.currentBottom = 6
        case 120:
            self.currentBottom = 5
        case 180:
            self.currentBottom = 4
        case 240:
            self.currentBottom = 3
        case 300:
            self.currentBottom = 2
        default:
            self.currentBottom = 1
        }
        print("currentRotation: \(self.currentRotation)")
        print("currentBottom \(currentBottom)")
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


//https://www.hackingwithswift.com/example-code/calayer/how-to-change-a-views-anchor-point-without-moving-it
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
