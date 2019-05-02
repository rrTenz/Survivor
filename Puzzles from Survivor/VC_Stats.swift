//
//  VC_Stats.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/28/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import GameKit

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

extension StringProtocol where Self: RangeReplaceableCollection{
    func paddingToLeft(upTo length: Int, using element: Element = " ") -> Self {
        return Self(repeatElement(element, count: Swift.max(0, length-count))) + suffix(Swift.max(count, count-length))
    }
}

class VC_Stats: UIViewController, GKGameCenterControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var textView: UITextView!
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    let LEADERBOARD_streakCount = "com.streakCount.puzzlesfromsurvivor2"                             //Longest Streak
    let LEADERBOARD_bowlsOfRice = "com.bowlsOfRice.puzzlesfromsurvivor2"                             //Bowls of Rice
    let LEADERBOARD_currentAmuletCount = "com.currentAmuletCount.puzzlesfromsurvivor2"               //Current Amulets
    let LEADERBOARD_amuletsPurchasedCount = "com.amuletsPurchasedCount.puzzlesfromsurvivor2"         //Amulets Purchased
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
        
        textView.text = "Current Streak: \(appDelegate.streakCount)\n" +
            "Longest Streak: \(appDelegate.longestStreak)\n" +
            "Current Amulets: \(appDelegate.amuletCount)\n" +
            "Amulets Purchased: \(appDelegate.amuletsPurchased)\n" +
            "Rice Bowls Purchased: \(appDelegate.bowlsOfRice)\n\n" +
            "Puzzles Completed: \(appDelegate.puzzlesCompleted)\n" +
            " - 5 Piece Slide Puzzle: \(appDelegate.pcc_SlidePuzzle3)\n" +
            " - Fire and Ice: \(appDelegate.pcc_VerticallyChallenged)\n" +
            " - Vertical Puzzle: \(appDelegate.pcc_VerticalPuzzle)\n" +
            " - Cog Puzzle: \(appDelegate.pcc_CogPuzzle)\n" +
            " - 1 to 100: \(appDelegate.pcc_NumbersGame)\n" +
            " - Combination Lock: \(appDelegate.pcc_CombinationLock)\n" +
            " - Spin Puzzle: \(appDelegate.pcc_SpinPuzzle)\n" +
            " - Turn Table Puzzle: \(appDelegate.pcc_MightAsWellJump)\n" +
            " - Slide Puzzle: \(appDelegate.pcc_SlidePuzzle)\n" +
            " - 1 to 25: \(appDelegate.pcc_Matchbox25)\n" +
            " - The Color and the Shape: \(appDelegate.pcc_ColorAndShape)\n" +
            " - 8 Piece Slide Puzzle: \(appDelegate.pcc_SlidePuzzle2)\n" +
            " - Tower of Hanoi: \(appDelegate.pcc_Hanoi)\n"// +
           // " - Instant Insanity: \(appDelegate.pcc_SeaCrates)\n"
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
    
    @IBAction func button_Submit(_ sender: Any) {
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_SlidePuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SeaCrates), leaderBoardID: appDelegate.LEADERBOARD_pcc_SeaCrates)
        self.submitScoreToGC(score: Int(appDelegate.pcc_Hanoi), leaderBoardID: appDelegate.LEADERBOARD_pcc_Hanoi)
        self.submitScoreToGC(score: Int(appDelegate.pcc_MightAsWellJump), leaderBoardID: appDelegate.LEADERBOARD_pcc_MightAsWellJump)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle2), leaderBoardID: appDelegate.LEADERBOARD_pcc_SlidePuzzle2)
        self.submitScoreToGC(score: Int(appDelegate.pcc_ColorAndShape), leaderBoardID: appDelegate.LEADERBOARD_pcc_ColorAndShape)
        self.submitScoreToGC(score: Int(appDelegate.pcc_Matchbox25), leaderBoardID: appDelegate.LEADERBOARD_pcc_Matchbox25)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SpinPuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_SpinPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_CombinationLock), leaderBoardID: appDelegate.LEADERBOARD_pcc_CombinationLock)
        self.submitScoreToGC(score: Int(appDelegate.pcc_NumbersGame), leaderBoardID: appDelegate.LEADERBOARD_pcc_NumbersGame)
        self.submitScoreToGC(score: Int(appDelegate.pcc_CogPuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_CogPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_VerticalPuzzle), leaderBoardID: appDelegate.LEADERBOARD_pcc_VerticalPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_VerticallyChallenged), leaderBoardID: appDelegate.LEADERBOARD_pcc_VerticallyChallenged)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle3), leaderBoardID: appDelegate.LEADERBOARD_pcc_SlidePuzzle3)
        
        self.submitScoreToGC(score: Int(appDelegate.longestStreak), leaderBoardID: self.LEADERBOARD_streakCount)
        self.submitScoreToGC(score: Int(appDelegate.bowlsOfRice), leaderBoardID: self.LEADERBOARD_bowlsOfRice)
        self.submitScoreToGC(score: Int(appDelegate.amuletCount), leaderBoardID: self.LEADERBOARD_currentAmuletCount)
        self.submitScoreToGC(score: Int(appDelegate.amuletsPurchased), leaderBoardID: self.LEADERBOARD_amuletsPurchasedCount)
        
        self.checkGCLeaderboard(leaderBoardID: appDelegate.LEADERBOARD_puzzlesCompleted)
    }
    

}
