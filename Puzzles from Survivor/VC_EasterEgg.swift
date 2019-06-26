//
//  VC_EasterEgg.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/3/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_EasterEgg: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    enum Egg {
        case All
        case Promo
        case FivePiece
        case FireAndIce
        case Vertical
        case Tile
        case Contra
        case None
    }
    
    var selectedEgg: Egg = .None

    override func viewDidLoad() {
        super.viewDidLoad()

        egg_outlet.isHidden = true
        selectedEgg = .None
        
        changeBackGround(direction: 0)
    }
    
    @IBOutlet weak var Background: UIImageView!
    
    @IBAction func up(_ sender: Any) {
        changeBackGround(direction: 0)
        checkEggHidden()
        eggString += "0"
        checkEgg()
    }
    
    @IBAction func down(_ sender: Any) {
        changeBackGround(direction: 1)
        checkEggHidden()
        eggString += "1"
        checkEgg()
    }
    
    @IBAction func left(_ sender: Any) {
        changeBackGround(direction: 2)
        checkEggHidden()
        eggString += "2"
        checkEgg()
    }
    
    @IBAction func right(_ sender: Any) {
        changeBackGround(direction: 3)
        checkEggHidden()
        eggString += "3"
        checkEgg()
    }
    
    var animationOption: UIView.AnimationOptions = .transitionFlipFromRight
    let imageArray_default = ["grass_blue.png", "grass_brown.png", "grass_green.png", "grass_pink.png", "grass_purple.png", "grass_red.png", "grass_till.png"]
    var imageArray: [String] = []
    var imageStr = "grass_green.png"
    func changeBackGround(direction: Int) {
        switch direction {
        case 3: //right
            animationOption = .transitionCrossDissolve
        case 1: //down
            animationOption = .transitionCrossDissolve
        case 2: //left
            animationOption = .transitionCrossDissolve
        case 0: //up
            animationOption = .transitionCrossDissolve
        default:
            break
        }
        
        if imageArray.count == 0 {
            imageArray = imageArray_default
            imageArray.shuffle()
        }
        if let index = imageArray.firstIndex(of:imageStr) {
            imageArray.remove(at: index)
        }
        UIView.transition(with: self.Background, duration: 0.25, options: animationOption, animations: {
            self.Background.image = UIImage.init(named: self.imageArray[0])
            self.imageStr = self.imageArray[0]
            self.imageArray.remove(at: 0)
        }, completion: nil)
    }
    
    func checkEggHidden() {
        if egg_outlet.isHidden == false {
            egg_outlet.isHidden = true
            selectedEgg = .None
            eggString = "aaaaaaaaaaaa"
        }
    }
    
    var eggString = "aaaaaaaaaaaa"
    func checkEgg() {
        
        eggString.remove(at: eggString.startIndex)
        print(eggString)
        
        if eggString.contains("212310030103") {         //left    down    left    right    down    up    up    right    up    down    up    right
            selectedEgg = .All
        }else if eggString.contains("100002012311") {   //down    up    up    up    up    left    up    down    left    right    down    down
            selectedEgg = .Promo
        }else if eggString.contains("2332010222") {     //left    right    right    left    up    down    up    left    left    left
            selectedEgg = .FivePiece
        }else if eggString.contains("0020101332") {     //up    up    left    up    down    up    down    right    right    left
            selectedEgg = .FireAndIce
        }else if eggString.contains("0022200221") {     //up    up    left    left    left    up    up    left    left    down
            selectedEgg = .Vertical
        }else if eggString.contains("00112323") {     //up    up    down    down    left    right   left    right
            selectedEgg = .Contra
        }
        
        if selectedEgg != .None {
            egg_outlet.isHidden = false
            showAlert(alert: alertWithTitle(title: "You Found an Egg!", message: "Congratulations!\nYou have found an egg!\n\nTap the egg to see what's inside!"))
        }
    }
    
    @IBOutlet weak var egg_outlet: UIButton!
    @IBAction func egg(_ sender: Any) {
        var alertMessage = ""
        if selectedEgg == .All {
            print("Unlock All")
            alertMessage = "You can now play all current and future puzzles"
            appDelegate.haveUnlocked_All = true
            checkEggHidden()
        }else if selectedEgg == .Promo  {
            print("open promo box")
            showPromoAlert()
        }else if selectedEgg == .FivePiece {
            print("5 Piece Slide Puzzle")
            alertMessage = "You can now play\n5 Piece Slide Puzzle"
            appDelegate.haveUnlocked_5PiecePuzzle = true
            checkEggHidden()
        }else if selectedEgg == .FireAndIce {
            print("Fire And Ice")
            alertMessage = "You can now play\nFire and Ice"
            appDelegate.haveUnlocked_FireAndIce = true
            checkEggHidden()
        }else if selectedEgg == .Vertical {
            print("Vertical Puzzle")
            alertMessage = "You can now play\nVertical Puzzle"
            appDelegate.haveUnlocked_VerticalPuzzle = true
            checkEggHidden()
        }else if selectedEgg == .Tile {
            print("Tile Puzzle")
            alertMessage = "You can now play\nTile Puzzle"
            appDelegate.haveUnlocked_TilePuzzle = true
            checkEggHidden()
        }else if selectedEgg == .Contra {
            print("Contra code")
            alertMessage = "You can now play\nContra Mode!\n\nOK, there isn't really Contra Mode, but nice try :)"
        }
        
        if alertMessage != "" {
            appDelegate.promoCodesUsed_Array.append(promo)
            Defaults().save_Defaults(updateStreak: false)
            showAlert(alert: alertWithTitle(title: "Egg Opened", message: alertMessage))
        }
    }
    
    func showPromoAlert() {   //https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        //Step : 1
        let alert = UIAlertController(title: "Easter Egg", message: "Enter your egg", preferredStyle: UIAlertController.Style.alert)
        //Step : 2
        let save = UIAlertAction(title: "Submit", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                print(textField.text!)
                print("TF 1 : \(textField.text!)")
                
                self.checkPromoCode(textField.text!)
            } else {
                print("TF 1 is Empty...")
            }
        }
        
        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your Easter Egg"
            textField.textColor = .black
        }
        
        //Step : 4
        alert.addAction(save)
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        //OR single line action
        //alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        
        self.present(alert, animated:true, completion: nil)
    }
    
    func subToInt(_ start: Int, _ end: Int) -> Int {
        let startIndex = promo.index(promo.startIndex, offsetBy: start)
        let endIndex = promo.index(promo.startIndex, offsetBy: end)
        if let myInt = Int(String(promo[startIndex...endIndex])) {
            return myInt
        }else {
            return -1
        }
    }
    
    func subToChar(_ start: Int, _ end: Int) -> Character {
        let startIndex = promo.index(promo.startIndex, offsetBy: start)
        let endIndex = promo.index(promo.startIndex, offsetBy: end)
        let myChar = Character(String(promo[startIndex...endIndex]))
        return myChar
    }
    
    func calcCheckSum() -> String {
        var i = 0
        var check = 0
        while i < 13 {
            let char = subToChar(i, i)
            let val = Int(char.asciiValue!)
            let bitXor = val ^ 255
            check += bitXor
            print("char \(char) bitXor \(bitXor) check \(check)")
            
            i += 1
        }
        
        check %= 256
        print("check % 256 \(check)")
        
        return String(check, radix: 16).uppercased()
    }
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    var promo = ""
    func checkPromoCode(_ promoCode: String) {
        promo = promoCode.uppercased()
        var invalidCode = false
        
        if appDelegate.promoCodesUsed_Array.contains(promo) {
            print("Code has been used")
            showAlert(alert: alertWithTitle(title: "Egg Denied", message: "You have already used this egg"))
        }else if promo.count == 15 {
            let startIndex = promo.index(promo.startIndex, offsetBy: 13)
            let endIndex = promo.index(promo.startIndex, offsetBy: 14)
            let checksum = String(promo[startIndex...endIndex])
            let calculatedCheckSum = calcCheckSum()
            print("Hex-check \(checksum) \(calculatedCheckSum)")
            if checksum == calculatedCheckSum {
                var val = 0
                let rand = subToInt(12, 12)
                let type = subToInt(0, 1) - rand
                let d0 = subToInt(2, 3) - rand
                let d1 = subToInt(4, 5) - rand
                let d2 = subToInt(6, 7) - rand
                let d3 = subToInt(8, 9) - rand
                let d4 = subToInt(10, 11) - rand
                val = d0
                if d1 >= 0 {
                    val *= 10
                    val += d1
                }
                if d2 >= 0 {
                    val *= 10
                    val += d2
                }
                if d3 >= 0 {
                    val *= 10
                    val += d3
                }
                if d4 >= 0 {
                    val *= 10
                    val += d4
                }
                print("type \(type) value \(val)")
                var alertTitle = "Egg Accepted"
                var alertMessage = ""
                enum PromoCodeType: Int {
                    case UnlockAll = 0
                    case Amulet = 1
                    case FirstDayOfStreak = 2
                    case BowlOfRice = 3
                    case Slide_5_Piece = 4
                    case LongestStreak = 5
                    case AmuletsPurchased = 6
                    case FireAndIce = 7
                    case VerticalPuzzle = 8
                    case CompletedCount_add = 9
                    case CompletedCount_set = 10
                    case TilePuzzle = 11
                }
                enum CompletedCount: Int {
                    case SlidePuzzle = 0
                    case SeaCrates = 1
                    case Hanoi = 2
                    case MightAsWellJump = 3
                    case SlidePuzzle2 = 4
                    case ColorAndShape = 5
                    case Matchbox25 = 6
                    case SpinPuzzle = 7
                    case CombinationLock = 8
                    case NumbersGame = 9
                    case CogPuzzle = 10
                    case VerticalPuzzle = 11
                    case VerticallyChallenged = 12
                    case SlidePuzzle3 = 13
                    case TilePuzzle = 14
                    case Total = 99
                }
                if let typeEnum = PromoCodeType(rawValue: type) {
                    switch typeEnum {
                    case .UnlockAll:
                        alertMessage = "All current and future puzzles have been unlocked"
                        appDelegate.haveUnlocked_All = true
                    case .Amulet:
                        alertMessage = "'Amulet' count\nhas changed from\n\(appDelegate.amuletCount) to \(val)"
                        appDelegate.amuletCount = val
                    case .FirstDayOfStreak:
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd HH:mm"
                        let March_20_2019 = formatter.date(from: "2019/3/20 12:00")
                        appDelegate.dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: val, to: March_20_2019!)!
                        appDelegate.UpdateStreakVariables(didCompletePuzzle: false)
                        alertMessage = "The first day of your streak has been set to \n\(appDelegate.dateOfFirstCompletedPuzzle)\n\n'Streak' count\nhas been set to\n\(appDelegate.streakCount)"
                    case .BowlOfRice:
                        alertMessage = "'Bowl of Rice' count\nhas changed from\n\(appDelegate.bowlsOfRice) to \(val)"
                        appDelegate.bowlsOfRice = val
                    case .Slide_5_Piece:
                        alertMessage = "5 Piece Slide Puzzle\nhas been unlocked"
                        appDelegate.haveUnlocked_5PiecePuzzle = true
                    case .LongestStreak:
                        alertMessage = "'Longest Streak' count\nhas changed from\n\(appDelegate.longestStreak) to \(val)"
                        appDelegate.longestStreak = val
                    case .AmuletsPurchased:
                        alertMessage = "'Amulets Purchased' count\nhas changed from\n\(appDelegate.amuletsPurchased) to \(val)"
                        appDelegate.amuletsPurchased = val
                    case .FireAndIce:
                        alertMessage = "Fire and Ice\nhas been unlocked"
                        appDelegate.haveUnlocked_FireAndIce = true
                    case .VerticalPuzzle:
                        alertMessage = "Vertical Puzzle\nhas been unlocked"
                        appDelegate.haveUnlocked_VerticalPuzzle = true
                    case .TilePuzzle:
                        alertMessage = "Tile Puzzle\nhas been unlocked"
                        appDelegate.haveUnlocked_TilePuzzle = true
                    case .CompletedCount_add, .CompletedCount_set:
                        print("Completed Count Promo Code")
                        if let puzzleEnum = CompletedCount(rawValue: val / 1000) {
                            alertTitle = "Updated Completed Count"
                            let count = val % 1000
                            switch puzzleEnum {
                            case .SlidePuzzle:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_SlidePuzzle += count
                                }else {
                                    appDelegate.pcc_SlidePuzzle = count
                                }
                                alertMessage = "Slide Puzzle Count: \(appDelegate.pcc_SlidePuzzle)"
                            case .SeaCrates:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_SeaCrates += count
                                }else {
                                    appDelegate.pcc_SeaCrates = count
                                }
                                alertMessage = "Instant Insanity Count: \(appDelegate.pcc_SeaCrates)"
                            case .Hanoi:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_Hanoi += count
                                }else {
                                    appDelegate.pcc_Hanoi = count
                                }
                                alertMessage = "Tower or Hanoi Count: \(appDelegate.pcc_Hanoi)"
                            case .MightAsWellJump:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_MightAsWellJump += count
                                }else {
                                    appDelegate.pcc_MightAsWellJump = count
                                }
                                alertMessage = "Turn Table Puzzle Count: \(appDelegate.pcc_MightAsWellJump)"
                            case .SlidePuzzle2:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_SlidePuzzle2 += count
                                }else {
                                    appDelegate.pcc_SlidePuzzle2 = count
                                }
                                alertMessage = "8 Piece Slide Puzzle Count: \(appDelegate.pcc_SlidePuzzle2)"
                            case .ColorAndShape:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_ColorAndShape += count
                                }else {
                                    appDelegate.pcc_ColorAndShape = count
                                }
                                alertMessage = "The Color and the Shape Count: \(appDelegate.pcc_ColorAndShape)"
                            case .Matchbox25:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_Matchbox25 += count
                                }else {
                                    appDelegate.pcc_Matchbox25 = count
                                }
                                alertMessage = "1 to 25 Count: \(appDelegate.pcc_Matchbox25)"
                            case .SpinPuzzle:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_SpinPuzzle += count
                                }else {
                                    appDelegate.pcc_SpinPuzzle = count
                                }
                                alertMessage = "Spin Puzzle Count: \(appDelegate.pcc_SpinPuzzle)"
                            case .CombinationLock:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_CombinationLock += count
                                }else {
                                    appDelegate.pcc_CombinationLock = count
                                }
                                alertMessage = "Combination Lock Count: \(appDelegate.pcc_CombinationLock)"
                            case .NumbersGame:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_NumbersGame += count
                                }else {
                                    appDelegate.pcc_NumbersGame = count
                                }
                                alertMessage = "1 to 100 Count: \(appDelegate.pcc_NumbersGame)"
                            case .CogPuzzle:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_CogPuzzle += count
                                }else {
                                    appDelegate.pcc_CogPuzzle = count
                                }
                                alertMessage = "Cog Puzzle Count: \(appDelegate.pcc_CogPuzzle)"
                            case .VerticalPuzzle:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_VerticalPuzzle += count
                                }else {
                                    appDelegate.pcc_VerticalPuzzle = count
                                }
                                alertMessage = "Vertical Puzzle Count: \(appDelegate.pcc_VerticalPuzzle)"
                            case .VerticallyChallenged:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_VerticallyChallenged += count
                                }else {
                                    appDelegate.pcc_VerticallyChallenged = count
                                }
                                alertMessage = "Fire and Ice Count: \(appDelegate.pcc_VerticallyChallenged)"
                            case .SlidePuzzle3:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_SlidePuzzle3 += count
                                }else {
                                    appDelegate.pcc_SlidePuzzle3 = count
                                }
                                alertMessage = "5 Piece Slide Puzzle Count: \(appDelegate.pcc_SlidePuzzle3)"
                            case .TilePuzzle:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.pcc_TilePuzzle += count
                                }else {
                                    appDelegate.pcc_TilePuzzle = count
                                }
                                alertMessage = "Tile Puzzle Count: \(appDelegate.pcc_TilePuzzle)"
                            case .Total:
                                if typeEnum == .CompletedCount_add {
                                    appDelegate.puzzlesCompleted += count
                                }else {
                                    appDelegate.puzzlesCompleted = count
                                }
                                alertMessage = "Puzzles Completed Count: \(appDelegate.puzzlesCompleted)"
                            }
                            update_puzzlesCompleted()
                        }else {
                            alertTitle = "Invalid Puzzle Type Value"
                            alertMessage = "The Easter Egg could not be applied"
                        }
                    }
                    appDelegate.promoCodesUsed_Array.append(promo)
                    Defaults().save_Defaults(updateStreak: false)
                }else {
                    alertTitle = "Invalid Easter Egg Value"
                    alertMessage = "The Easter Egg could not be applied"
                }
                showAlert(alert: alertWithTitle(title: alertTitle, message: alertMessage))
            }else {
                invalidCode = true
            }
        }else {
            invalidCode = true
        }
        if invalidCode {
            print("Invalid code")
            showAlert(alert: alertWithTitle(title: "Easter Egg Denied", message: "Invalid egg"))
        }
    }
    
    func update_puzzlesCompleted() {
        appDelegate.puzzlesCompleted = appDelegate.pcc_SlidePuzzle + appDelegate.pcc_Hanoi + appDelegate.pcc_MightAsWellJump + appDelegate.pcc_SlidePuzzle2 + appDelegate.pcc_ColorAndShape + appDelegate.pcc_Matchbox25 + appDelegate.pcc_SpinPuzzle + appDelegate.pcc_CombinationLock + appDelegate.pcc_NumbersGame + appDelegate.pcc_CogPuzzle + appDelegate.pcc_VerticalPuzzle + appDelegate.pcc_VerticallyChallenged + appDelegate.pcc_SlidePuzzle3 + appDelegate.pcc_TilePuzzle
    }}
