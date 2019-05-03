//
//  AppDelegate.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/22/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        haveInitPurchases = false
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    let DAYS_FOR_FREE_NECKCLACE = 10
    public func UpdateStreakVariables(didCompletePuzzle: Bool) {
        //This function should get called when a puzzle has been completed
        
        //Check to see if dateOfFirstCompletedPuzzle is the original 1970 value
        if daysBetween2Dates(date1: Date(timeIntervalSince1970: 0), date2: dateOfFirstCompletedPuzzle) == 0 {
//            print("--set dateOfFirstCompletedPuzzle to yesterday")
//            dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: -1, to: Date())!  //set to yesterday
//            print("--set dateOfFirstCompletedPuzzle to today")
//            dateOfFirstCompletedPuzzle = Date()  //set to today
            print("--set dateOfFirstCompletedPuzzle to tomorrow")
            dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: 1, to: Date())!  //set to tomorrow
            giveFreeAmulet = true
        }
        
        if didCompletePuzzle {
            dateOfLastCompletedPuzzle = Date()  //Set today as the dateOfLastCompletedPuzzle
        }
        
        let streakCount_prev = streakCount
        print("streakCount \(streakCount)")
        streakCount = daysBetween2Dates(date1: dateOfFirstCompletedPuzzle, date2: dateOfLastCompletedPuzzle) + 1
        print("streakCount \(streakCount)")
        
        if streakCount_prev < streakCount && streakCount % DAYS_FOR_FREE_NECKCLACE == 0 {
            giveFreeAmulet = true
            didEarnAmulet = true
        }
        
        Defaults().save_Defaults(updateStreak: false)
    }
    
    func daysBetween2Dates(date1: Date, date2: Date) -> Int {
        let calendar = NSCalendar.current
        
        print("date1 \(date1)")
        print("date2 \(date2)")
        
        // Replace the hour (time) of both dates with 00:00
        let date1_mod = calendar.startOfDay(for: date1)
        let date2_mod = calendar.startOfDay(for: date2)
        
        print("date1_mod \(date1_mod)")
        print("date2_mod \(date2_mod)")
        
        let components = calendar.dateComponents([.day], from: date1_mod, to: date2_mod)
        
        print("components \(components)")
        print("day diff \(abs(components.day!))")
        
        return abs(components.day!)
    }

    //Saved variables
    var version = ""
    var lastPuzzle_index = 1
    var streakCount = 0
    var longestStreak = 0
    var dateOfFirstCompletedPuzzle = Date(timeIntervalSince1970: 0)
    var dateOfLastCompletedPuzzle = Date()
    var amuletCount = 0
    var amuletsPurchased = 0
    var bowlsOfRice = 0
    var haveUnlocked_All = false
    var haveUnlocked_5PiecePuzzle = false
    var haveUnlocked_FireAndIce = false
    var haveUnlocked_VerticalPuzzle = false
    var promoCodesUsed_Array: [String] = []
    var giveFreeAmulet = false
    var didEarnAmulet = false
    //puzzle completed count
    var puzzlesCompleted = 0 //-----
    var pcc_SlidePuzzle = 0
    var pcc_SeaCrates = 0
    var pcc_Hanoi = 0
    var pcc_MightAsWellJump = 0
    var pcc_SlidePuzzle2 = 0
    var pcc_ColorAndShape = 0
    var pcc_Matchbox25 = 0
    var pcc_SpinPuzzle = 0
    var pcc_CombinationLock = 0
    var pcc_NumbersGame = 0
    var pcc_CogPuzzle = 0
    var pcc_VerticalPuzzle = 0
    var pcc_VerticallyChallenged = 0
    var pcc_SlidePuzzle3 = 0

    var SeasonSelected = -1
    var EpisodeSelected = -1
    var PuzzleSelected = -1
    var puzzleArray: [Constants.Puzzle] = []    //this is a sub array of the full puzzle array that only holds the puzzles for the selected episode of a season
    var puzzleArraySimple: [Constants.PuzzleSimple] = []    //this is a full array of the simplified puzzles
    var WatchVideo = "" //If this string is empty, use the array. If it has a Code, watch this video
    var isLearn = false
    var isPractice = false
    var haveBeenGivenChanceToBuyAmulets = false
    
    var haveInitPurchases = true
    
    //In App Purchases - Product IDs
    let IAP_5_Piece_Puzzle = "com.rrtenz.puzzlesfromsurvivor2.5_Piece_Puzzle"
    
    //Global Game Center
    let LEADERBOARD_puzzlesCompleted = "com.puzzlesCompleted.puzzlesfromsurvivor2"                   //Completed Count: All Puzzles Completed
    let LEADERBOARD_pcc_SlidePuzzle = "com.pcc_SlidePuzzle.puzzlesfromsurvivor2"                     //Completed Count: Slide Puzzle
    let LEADERBOARD_pcc_SeaCrates = "com.pcc_SeaCrates.puzzlesfromsurvivor2"                         //Completed Count: Instant Insanity
    let LEADERBOARD_pcc_Hanoi = "com.pcc_Hanoi.puzzlesfromsurvivor2"                                 //Completed Count: Hanoi
    let LEADERBOARD_pcc_MightAsWellJump = "com.pcc_MightAsWellJump.puzzlesfromsurvivor2"             //Completed Count: Turn Table Puzzle
    let LEADERBOARD_pcc_SlidePuzzle2 = "com.pcc_SlidePuzzle2.puzzlesfromsurvivor2"                   //Completed Count: 8 Pieve Slide Puzzle
    let LEADERBOARD_pcc_ColorAndShape = "com.pcc_ColorAndShape.puzzlesfromsurvivor2"                 //Completed Count: Color and Shape
    let LEADERBOARD_pcc_Matchbox25 = "com.pcc_Matchbox25.puzzlesfromsurvivor2"                       //Completed Count: 1 to 25
    let LEADERBOARD_pcc_SpinPuzzle = "com.pcc_SpinPuzzle.puzzlesfromsurvivor2"                       //Completed Count: Spin Puzzle
    let LEADERBOARD_pcc_CombinationLock = "com.pcc_CombinationLock.puzzlesfromsurvivor2"             //Completed Count: Combination Lock
    let LEADERBOARD_pcc_NumbersGame = "com.pcc_NumbersGame.puzzlesfromsurvivor2"                     //Completed Count: 1 to 100
    let LEADERBOARD_pcc_CogPuzzle = "com.pcc_CogPuzzle.puzzlesfromsurvivor2"                         //Completed Count: Cog Puzzle
    let LEADERBOARD_pcc_VerticalPuzzle = "com.pcc_VerticalPuzzle.puzzlesfromsurvivor2"               //Completed Count: Vertical Puzzle
    let LEADERBOARD_pcc_VerticallyChallenged = "com.pcc_VerticallyChallenged.puzzlesfromsurvivor2"   //Completed Count: Fire and Ice
    let LEADERBOARD_pcc_SlidePuzzle3 = "com.pcc_SlidePuzzle3.puzzlesfromsurvivor2"                   //Completed Count: 5 Piece Slide Puzzle
    
}

