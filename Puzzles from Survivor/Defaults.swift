//
//  Defaults.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/13/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import Foundation
import UIKit

internal class Defaults {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let key_preset_version = "key_version"
    let key_lastPuzzle_index = "key_lastPuzzle_index"
    let key_streakCount = "key_streakCount"
    let key_longestStreak = "key_longestStreak"
    let key_dateOfFirstCompletedPuzzle = "key_dateOfFirstCompletedPuzzle"
    let key_dateOfLastCompletedPuzzle = "key_dateOfLastCompletedPuzzle"
    let key_amuletCount = "key_amuletCount"
    let key_amuletsPurchased = "key_amuletsPurchased"
    let key_bowlsOfRice = "key_bowlsOfRice"
    let key_haveUnlocked_All = "key_haveUnlocked_All"
    let key_haveUnlocked_5PiecePuzzle = "key_haveUnlocked_5PiecePuzzle"
    let key_haveUnlocked_FireAndIce = "key_haveUnlocked_FireAndIce"
    let key_haveUnlocked_VerticalPuzzle = "key_haveUnlocked_VerticalPuzzle"
    let key_promoCodesUsed_Array = "key_promoCodesUsed_Array"
    let key_giveFreeAmulet = "key_giveFreeAmulet"
    
    let key_puzzlesCompleted = "key_puzzlesCompleted"
    
    let key_pcc_SlidePuzzle = "key_pcc_SlidePuzzle"
    let key_pcc_SeaCrates = "key_pcc_SeaCrates"
    let key_pcc_Hanoi = "key_pcc_Hanoi"
    let key_pcc_MightAsWellJump = "key_pcc_MightAsWellJump"
    let key_pcc_SlidePuzzle2 = "key_pcc_SlidePuzzle2"
    let key_pcc_ColorAndShape = "key_pcc_ColorAndShape"
    let key_pcc_Matchbox25 = "key_pcc_Matchbox25"
    let key_pcc_SpinPuzzle = "key_pcc_SpinPuzzle"
    let key_pcc_CombinationLock = "key_pcc_CombinationLock"
    let key_pcc_NumbersGame = "key_pcc_NumbersGame"
    let key_pcc_CogPuzzle = "key_pcc_CogPuzzle"
    let key_pcc_VerticalPuzzle = "key_pcc_VerticalPuzzle"
    let key_pcc_VerticallyChallenged = "key_pcc_VerticallyChallenged"
    let key_pcc_SlidePuzzle3 = "key_pcc_SlidePuzzle3"
    
    func load_Defaults() {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: key_preset_version) == nil {
            print("Version has not been saved")
        }else {
            appDelegate.version = defaults.string(forKey: key_preset_version)!
        }
        
        appDelegate.lastPuzzle_index = defaults.integer(forKey: key_lastPuzzle_index)
        appDelegate.streakCount = defaults.integer(forKey: key_streakCount)
        appDelegate.longestStreak = defaults.integer(forKey: key_longestStreak)
        if appDelegate.streakCount > appDelegate.longestStreak {
            appDelegate.longestStreak = appDelegate.streakCount
        }
        if defaults.object(forKey: key_dateOfFirstCompletedPuzzle) == nil {
            print("dateOfFirstCompletedPuzzle has not been saved")
        }else {
            appDelegate.dateOfFirstCompletedPuzzle = defaults.object(forKey: key_dateOfFirstCompletedPuzzle) as! Date
        }
        if defaults.object(forKey: key_dateOfLastCompletedPuzzle) == nil {
            print("dateOfLastCompletedPuzzle has not been saved")
        }else {
            appDelegate.dateOfLastCompletedPuzzle = defaults.object(forKey: key_dateOfLastCompletedPuzzle) as! Date
        }
        appDelegate.amuletCount = defaults.integer(forKey: key_amuletCount)
        appDelegate.amuletsPurchased = defaults.integer(forKey: key_amuletsPurchased)
        appDelegate.bowlsOfRice = defaults.integer(forKey: key_bowlsOfRice)
        appDelegate.haveUnlocked_All = defaults.bool(forKey: key_haveUnlocked_All)
        appDelegate.haveUnlocked_5PiecePuzzle = defaults.bool(forKey: key_haveUnlocked_5PiecePuzzle)
        appDelegate.haveUnlocked_FireAndIce = defaults.bool(forKey: key_haveUnlocked_FireAndIce)
        appDelegate.haveUnlocked_VerticalPuzzle = defaults.bool(forKey: key_haveUnlocked_VerticalPuzzle)
        if defaults.object(forKey: key_promoCodesUsed_Array) == nil {
            print("key_promoCodesUsed_Array has not been saved")
        }else {
            appDelegate.promoCodesUsed_Array = defaults.object(forKey: key_promoCodesUsed_Array) as! [String]
        }
        appDelegate.giveFreeAmulet = defaults.bool(forKey: key_giveFreeAmulet)
        
        appDelegate.puzzlesCompleted = defaults.integer(forKey: key_puzzlesCompleted)
        
        appDelegate.pcc_SlidePuzzle = defaults.integer(forKey: key_pcc_SlidePuzzle)
        appDelegate.pcc_SeaCrates = defaults.integer(forKey: key_pcc_SeaCrates)
        appDelegate.pcc_Hanoi = defaults.integer(forKey: key_pcc_Hanoi)
        appDelegate.pcc_MightAsWellJump = defaults.integer(forKey: key_pcc_MightAsWellJump)
        appDelegate.pcc_SlidePuzzle2 = defaults.integer(forKey: key_pcc_SlidePuzzle2)
        appDelegate.pcc_ColorAndShape = defaults.integer(forKey: key_pcc_ColorAndShape)
        appDelegate.pcc_Matchbox25 = defaults.integer(forKey: key_pcc_Matchbox25)
        appDelegate.pcc_SpinPuzzle = defaults.integer(forKey: key_pcc_SpinPuzzle)
        appDelegate.pcc_CombinationLock = defaults.integer(forKey: key_pcc_CombinationLock)
        appDelegate.pcc_NumbersGame = defaults.integer(forKey: key_pcc_NumbersGame)
        appDelegate.pcc_CogPuzzle = defaults.integer(forKey: key_pcc_CogPuzzle)
        appDelegate.pcc_VerticalPuzzle = defaults.integer(forKey: key_pcc_VerticalPuzzle)
        appDelegate.pcc_VerticallyChallenged = defaults.integer(forKey: key_pcc_VerticallyChallenged)
        appDelegate.pcc_SlidePuzzle3 = defaults.integer(forKey: key_pcc_SlidePuzzle3)
    }
    
    func save_Defaults(updateStreak: Bool) {
        let defaults = UserDefaults.standard
        
        if updateStreak {
            appDelegate.UpdateStreakVariables(didCompletePuzzle: true)
        }
        if appDelegate.streakCount > appDelegate.longestStreak {
            appDelegate.longestStreak = appDelegate.streakCount
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            defaults.set(version, forKey: key_preset_version)
        }
        defaults.set(appDelegate.lastPuzzle_index, forKey: key_lastPuzzle_index)
        defaults.set(appDelegate.streakCount, forKey: key_streakCount)
        defaults.set(appDelegate.longestStreak, forKey: key_longestStreak)
        defaults.set(appDelegate.dateOfFirstCompletedPuzzle, forKey: key_dateOfFirstCompletedPuzzle)
        defaults.set(appDelegate.dateOfLastCompletedPuzzle, forKey: key_dateOfLastCompletedPuzzle)
        defaults.set(appDelegate.amuletCount, forKey: key_amuletCount)
        defaults.set(appDelegate.amuletsPurchased, forKey: key_amuletsPurchased)
        defaults.set(appDelegate.bowlsOfRice, forKey: key_bowlsOfRice)
        defaults.set(appDelegate.haveUnlocked_All, forKey: key_haveUnlocked_All)
        defaults.set(appDelegate.haveUnlocked_5PiecePuzzle, forKey: key_haveUnlocked_5PiecePuzzle)
        defaults.set(appDelegate.haveUnlocked_FireAndIce, forKey: key_haveUnlocked_FireAndIce)
        defaults.set(appDelegate.haveUnlocked_VerticalPuzzle, forKey: key_haveUnlocked_VerticalPuzzle)
        defaults.set(appDelegate.promoCodesUsed_Array, forKey: key_promoCodesUsed_Array)
        defaults.set(appDelegate.giveFreeAmulet, forKey: key_giveFreeAmulet)

        
        defaults.set(appDelegate.puzzlesCompleted, forKey: key_puzzlesCompleted)
        
        defaults.set(appDelegate.pcc_SlidePuzzle, forKey: key_pcc_SlidePuzzle)
        defaults.set(appDelegate.pcc_SeaCrates, forKey: key_pcc_SeaCrates)
        defaults.set(appDelegate.pcc_Hanoi, forKey: key_pcc_Hanoi)
        defaults.set(appDelegate.pcc_MightAsWellJump, forKey: key_pcc_MightAsWellJump)
        defaults.set(appDelegate.pcc_SlidePuzzle2, forKey: key_pcc_SlidePuzzle2)
        defaults.set(appDelegate.pcc_ColorAndShape, forKey: key_pcc_ColorAndShape)
        defaults.set(appDelegate.pcc_Matchbox25, forKey: key_pcc_Matchbox25)
        defaults.set(appDelegate.pcc_SpinPuzzle, forKey: key_pcc_SpinPuzzle)
        defaults.set(appDelegate.pcc_CombinationLock, forKey: key_pcc_CombinationLock)
        defaults.set(appDelegate.pcc_NumbersGame, forKey: key_pcc_NumbersGame)
        defaults.set(appDelegate.pcc_CogPuzzle, forKey: key_pcc_CogPuzzle)
        defaults.set(appDelegate.pcc_VerticalPuzzle, forKey: key_pcc_VerticalPuzzle)
        defaults.set(appDelegate.pcc_VerticallyChallenged, forKey: key_pcc_VerticallyChallenged)
        defaults.set(appDelegate.pcc_SlidePuzzle3, forKey: key_pcc_SlidePuzzle3)
    }

}
