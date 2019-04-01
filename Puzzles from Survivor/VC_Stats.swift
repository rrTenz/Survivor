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
    let LEADERBOARD_puzzlesCompleted = "com.puzzlesCompleted.puzzlesfromsurvivor"                   //Completed Count: All Puzzles Completed
    let LEADERBOARD_pcc_SlidePuzzle = "com.pcc_SlidePuzzle.puzzlesfromsurvivor"                     //Completed Count: Slide Puzzle
    let LEADERBOARD_pcc_SeaCrates = "com.pcc_SeaCrates.puzzlesfromsurvivor"                         //Completed Count: Sea Crates
    let LEADERBOARD_pcc_Hanoi = "com.pcc_Hanoi.puzzlesfromsurvivor"                                 //Completed Count: Hanoi
    let LEADERBOARD_pcc_MightAsWellJump = "com.pcc_MightAsWellJump.puzzlesfromsurvivor"             //Completed Count: Might As Well Jump
    let LEADERBOARD_pcc_SlidePuzzle2 = "com.pcc_SlidePuzzle2.puzzlesfromsurvivor"                   //Completed Count: 8 Pieve Slide Puzzle
    let LEADERBOARD_pcc_ColorAndShape = "com.pcc_ColorAndShape.puzzlesfromsurvivor"                 //Completed Count: Color and Shape
    let LEADERBOARD_pcc_Matchbox25 = "com.pcc_Matchbox25.puzzlesfromsurvivor"                       //Completed Count: Matchbox 25
    let LEADERBOARD_pcc_SpinPuzzle = "com.pcc_SpinPuzzle.puzzlesfromsurvivor"                       //Completed Count: Spin Puzzle
    let LEADERBOARD_pcc_CombinationLock = "com.pcc_CombinationLock.puzzlesfromsurvivor"             //Completed Count: Combination Lock
    let LEADERBOARD_pcc_NumbersGame = "com.pcc_NumbersGame.puzzlesfromsurvivor"                     //Completed Count: Numbers Game
    let LEADERBOARD_pcc_CogPuzzle = "com.pcc_CogPuzzle.puzzlesfromsurvivor"                         //Completed Count: Cog Puzzle
    let LEADERBOARD_pcc_VerticalPuzzle = "com.pcc_VerticalPuzzle.puzzlesfromsurvivor"               //Completed Count: Vertical Puzzle
    let LEADERBOARD_pcc_VerticallyChallenged = "com.pcc_VerticallyChallenged.puzzlesfromsurvivor"   //Completed Count: Vertically Challenged
    let LEADERBOARD_pcc_SlidePuzzle3 = "com.pcc_SlidePuzzle3.puzzlesfromsurvivor"                   //Completed Count: 5 Piece Slide Puzzle
    
    let LEADERBOARD_streakCount = "com.streakCount.puzzlesfromsurvivor"                             //Longest Streak
    let LEADERBOARD_bowlsOfRice = "com.bowlsOfRice.puzzlesfromsurvivor"                             //Bowls of Rice
    let LEADERBOARD_immunityNecklaceCount = "com.immunityNecklaceCount.puzzlesfromsurvivor"         //Immunity Necklaces
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
        
        textView.text = "Current Streak: \(appDelegate.streakCount)\n" +
            "Longest Streak: \(appDelegate.longestStreak)\n" +
            "Current Necklaces: \(appDelegate.immunityNecklaceCount)\n" +
            "Necklaces Purchased: \(appDelegate.immunityNecklacesPurchased)\n" +
            "Rice Bowls Purchased: \(appDelegate.bowlsOfRice)\n\n" +
            "Puzzles Completed: \(appDelegate.puzzlesCompleted)\n" +
            " - 5 Piece Slide Puzzle: \(appDelegate.pcc_SlidePuzzle3)\n" +
            " - Vertically Challenged: \(appDelegate.pcc_VerticallyChallenged)\n" +
            " - Vertical Puzzle: \(appDelegate.pcc_VerticalPuzzle)\n" +
            " - Cog Puzzle: \(appDelegate.pcc_CogPuzzle)\n" +
            " - A Numbers Game: \(appDelegate.pcc_NumbersGame)\n" +
            " - Combination Lock: \(appDelegate.pcc_CombinationLock)\n" +
            " - Spin Puzzle: \(appDelegate.pcc_SpinPuzzle)\n" +
            " - Might As Well Jump: \(appDelegate.pcc_MightAsWellJump)\n" +
            " - Slide Puzzle: \(appDelegate.pcc_SlidePuzzle)\n" +
            " - Matchbox 25: \(appDelegate.pcc_Matchbox25)\n" +
            " - The Color and the Shape: \(appDelegate.pcc_ColorAndShape)\n" +
            " - 8 Piece Slide Puzzle: \(appDelegate.pcc_SlidePuzzle2)\n" +
            " - Tower of Hanoi: \(appDelegate.pcc_Hanoi)\n" +
            " - Sea Crates: \(appDelegate.pcc_SeaCrates)\n"
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
        self.submitScoreToGC(score: Int(appDelegate.puzzlesCompleted), leaderBoardID: self.LEADERBOARD_puzzlesCompleted)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle), leaderBoardID: self.LEADERBOARD_pcc_SlidePuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SeaCrates), leaderBoardID: self.LEADERBOARD_pcc_SeaCrates)
        self.submitScoreToGC(score: Int(appDelegate.pcc_Hanoi), leaderBoardID: self.LEADERBOARD_pcc_Hanoi)
        self.submitScoreToGC(score: Int(appDelegate.pcc_MightAsWellJump), leaderBoardID: self.LEADERBOARD_pcc_MightAsWellJump)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle2), leaderBoardID: self.LEADERBOARD_pcc_SlidePuzzle2)
        self.submitScoreToGC(score: Int(appDelegate.pcc_ColorAndShape), leaderBoardID: self.LEADERBOARD_pcc_ColorAndShape)
        self.submitScoreToGC(score: Int(appDelegate.pcc_Matchbox25), leaderBoardID: self.LEADERBOARD_pcc_Matchbox25)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SpinPuzzle), leaderBoardID: self.LEADERBOARD_pcc_SpinPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_CombinationLock), leaderBoardID: self.LEADERBOARD_pcc_CombinationLock)
        self.submitScoreToGC(score: Int(appDelegate.pcc_NumbersGame), leaderBoardID: self.LEADERBOARD_pcc_NumbersGame)
        self.submitScoreToGC(score: Int(appDelegate.pcc_CogPuzzle), leaderBoardID: self.LEADERBOARD_pcc_CogPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_VerticalPuzzle), leaderBoardID: self.LEADERBOARD_pcc_VerticalPuzzle)
        self.submitScoreToGC(score: Int(appDelegate.pcc_VerticallyChallenged), leaderBoardID: self.LEADERBOARD_pcc_VerticallyChallenged)
        self.submitScoreToGC(score: Int(appDelegate.pcc_SlidePuzzle3), leaderBoardID: self.LEADERBOARD_pcc_SlidePuzzle3)
        
        self.submitScoreToGC(score: Int(appDelegate.longestStreak), leaderBoardID: self.LEADERBOARD_streakCount)
        self.submitScoreToGC(score: Int(appDelegate.bowlsOfRice), leaderBoardID: self.LEADERBOARD_bowlsOfRice)
        self.submitScoreToGC(score: Int(appDelegate.immunityNecklacesPurchased), leaderBoardID: self.LEADERBOARD_immunityNecklaceCount)
        
        self.checkGCLeaderboard(leaderBoardID: self.LEADERBOARD_puzzlesCompleted)
    }
    

}
