//
//  AppDelegate.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/22/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    fatalError()
                }
            }
        }
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
        if daysBetween2Dates(date1: dateOfFirstCompletedPuzzle, date2: Date(timeIntervalSince1970: 0)) == 0 {
//            print("--set dateOfFirstCompletedPuzzle to yesterday")
//            dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: -1, to: Date())!  //set to yesterday
//            print("--set dateOfFirstCompletedPuzzle to today")
//            dateOfFirstCompletedPuzzle = Date()  //set to today
            print("--set dateOfFirstCompletedPuzzle to tomorrow")
            dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: 1, to: Date())!  //set to tomorrow
            giveFreeNecklace = true
        }
        
        if didCompletePuzzle {
            dateOfLastCompletedPuzzle = Date()  //Set today as the dateOfLastCompletedPuzzle
        }
        
        let streakCount_prev = streakCount
        print("streakCount \(streakCount)")
        streakCount = daysBetween2Dates(date1: dateOfFirstCompletedPuzzle, date2: dateOfLastCompletedPuzzle) + 1
        print("streakCount \(streakCount)")
        
        if streakCount_prev < streakCount && streakCount % DAYS_FOR_FREE_NECKCLACE == 0 {
            giveFreeNecklace = true
        }
        
        Defaults().save_Defaults(updateStreak: false)
    }
    
    func daysBetween2Dates(date1: Date, date2: Date) -> Int {
        let calendar = NSCalendar.current
        
        print("dateOfFirstCompletedPuzzle \(dateOfFirstCompletedPuzzle)")
        print("dateOfLastCompletedPuzzle \(dateOfLastCompletedPuzzle)")
        
        // Replace the hour (time) of both dates with 00:00
        let date1_mod = calendar.startOfDay(for: dateOfFirstCompletedPuzzle)
        let date2_mod = calendar.startOfDay(for: dateOfLastCompletedPuzzle)
        
        print("date1_mod \(date1_mod)")
        print("date2_mod \(date2_mod)")
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        print("components \(components)")
        
        return components.day!
    }

    //Saved variables
    var version = ""
    var lastPuzzle_index = 1
    var streakCount = 0
    var longestStreak = 0
    var dateOfFirstCompletedPuzzle = Date(timeIntervalSince1970: 0)
    var dateOfLastCompletedPuzzle = Date()
    var immunityNecklaceCount = 0
    var immunityNecklacesPurchased = 0
    var bowlsOfRice = 0
    var haveUnlocked_All = false
    var haveUnlocked_5PiecePuzzle = false
    var promoCodesUsed_Array: [String] = []
    var giveFreeNecklace = false
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
    var haveBeenGivenChanceToBuyNecklaces = false
    
    //In App Purchases - Product IDs
    let IAP_5_Piece_Puzzle = "com.rrtenz.puzzlesfromsurvivor.5_Piece_Puzzle"
}

