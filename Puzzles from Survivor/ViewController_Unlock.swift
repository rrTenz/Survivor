//
//  ViewController_Unlock.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/25/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import StoreKit

var sharedSecret = "001c3876819a475cb7aae185ce2b8722"

enum RegisteredPurchase: String {
    case Slide_5_Piece = "5_Piece_Puzzle"
    case UnlockAll = "unlockAll"
    case AutoRenewable = "AutoRenewable"
    case BowlOfRice = "BowlOfRice"
    case Amulet_3 = "ImmunityNecklace_3"
    case Amulet_10 = "ImmunityNecklace_10"
    case Fire_And_Ice = "Fire_And_Ice"
    case Vertical_Puzzle = "Vertical_Puzzle"
    case CannotAfford = ""
}

class NetworkActivityIndicatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func NetworkOperationFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false  //19:12
        }
    }
    
    
}

class ViewController_Unlock: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myArray = ["$2.99 - Unlock All - Unlocks all current and future puzzles",
                   "$0.99 - 5 Piece Slide Puzzle - Unlock 5 Piece Slide Puzzle",
                   "$0.99 - Fire and Ice - Unlock Fire and Ice Puzzle",
                   "$0.99 - Vertical Puzzle - Unlock Vertical Puzzle",
                   "$0.99 - 3 Amulets - Keep your streak alive 3 time (3 days)",
                   "$1.99 - 10 Amulets - Keep your streak alive 3 time (3 days)",
                   "$0.99 - Bowl of Rice - Get option to buy Amulets before streak reset",
                   "I can't afford it :("]
    var RegisteredPurchaseArray: [RegisteredPurchase] = [.UnlockAll,
                                                         .Slide_5_Piece,
                                                         .Fire_And_Ice,
                                                         .Vertical_Puzzle,
                                                         .Amulet_3,
                                                         .Amulet_10,
                                                         .BowlOfRice,
                                                         .CannotAfford]
    
    
    let bundleID = "com.rrtenz.puzzlesfromsurvivor2"
    
    var SlidePuzzle_5 = RegisteredPurchase.Slide_5_Piece
    var FireAndIce = RegisteredPurchase.Fire_And_Ice
    var VerticalPuzzle = RegisteredPurchase.Vertical_Puzzle
    var UnlockAll = RegisteredPurchase.UnlockAll
    var getInfoIndex = 0
    var verifyPurchaseIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInfoIndex = 0
        getInfo(purchase: RegisteredPurchaseArray[getInfoIndex])
        promoPressCount = 0
    }
    
    var promoPressCount = 0
    @IBAction func Button_enterPromoCode(_ sender: Any) {
        if promoPressCount < 6 {
            print("increment")
            promoPressCount += 1
        }else {
            print("show")
            showPromoAlert()
            promoPressCount = 5
        }
        print(promoPressCount)
    }
    
    func showPromoAlert() {  //https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        //Step : 1
        let alert = UIAlertController(title: "Promo Code", message: "Enter your promo code", preferredStyle: UIAlertController.Style.alert)
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
            textField.placeholder = "Enter your promo code"
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
    
    var promo = ""
    func checkPromoCode(_ promoCode: String) {
        promo = promoCode.uppercased()
        var invalidCode = false
        
        if appDelegate.promoCodesUsed_Array.contains(promo) {
            print("Code has been used")
            showAlert(alert: alertWithTitle(title: "Promo Code Denied", message: "You have already used this code"))
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
                var alertTitle = "Promo Code Accepted"
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
                            alertMessage = "The Promo Code could not be applied"
                        }
                    }
                    appDelegate.promoCodesUsed_Array.append(promo)
                    Defaults().save_Defaults(updateStreak: false)
                }else {
                    alertTitle = "Invalid Promo Code Value"
                    alertMessage = "The Promo Code could not be applied"
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
            showAlert(alert: alertWithTitle(title: "Promo Code Denied", message: "Invalid promo code"))
        }
    }
    
    func update_puzzlesCompleted() {
        appDelegate.puzzlesCompleted = appDelegate.pcc_SlidePuzzle + appDelegate.pcc_Hanoi + appDelegate.pcc_MightAsWellJump + appDelegate.pcc_SlidePuzzle2 + appDelegate.pcc_ColorAndShape + appDelegate.pcc_Matchbox25 + appDelegate.pcc_SpinPuzzle + appDelegate.pcc_CombinationLock + appDelegate.pcc_NumbersGame + appDelegate.pcc_CogPuzzle + appDelegate.pcc_VerticalPuzzle + appDelegate.pcc_VerticallyChallenged + appDelegate.pcc_SlidePuzzle3
    }
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = myArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.appDelegate.haveInitPurchases == false {
            print("Initializing in-app purchase")
            return
        }
        
        print("do something \(indexPath.row) \(myArray[indexPath.row])")
        
        if myArray.count - 1 == indexPath.row {
            showAlert(alert: alertWithTitle(title: "No Money?", message: "I am trying to make\n'Puzzle Cluster'\navailable to as many people as possible. However I have locked some puzzles and am asking for a contribution because I do need some money to keep this project going.\n\nIf you don't have the money or can't get mom or dad's permission to make a purchase, here are a few ways to get a free promo code:\n\n1. Give my app a possitive review\n2. Follow rrTenz Games on Facebook\n3. Subscribe to Survivor Geek on YouTube\n4. Share the app's link on social media\n\nTake a screen shot and email it to rrtenz@gmail.com\nIf you do at least 3 of those things, I will send you a code to unlock all current and future puzzles!"))
        }else {
            purchase(purchase: RegisteredPurchaseArray[indexPath.row])
        }
    }
    
    func getInfo(purchase: RegisteredPurchase) {
        
    }
    
    func purchase(purchase: RegisteredPurchase) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = bundleID + "." + purchase.rawValue
            SKPaymentQueue.default().add(paymentRequest)
        }else {
            showAlert(alert: alertWithTitle(title: "Cannot Make Purchase", message: "You are not able to make purchases."))
        }
    }
    
    func restorePurchases() {
        
    }
    
    func verifyPurchase(product: RegisteredPurchase) {
        
    }
    
    func refreshReceipt() {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("transaction successful \(String(describing: transaction.transactionIdentifier))")
                //showAlert(alert: alertWithTitle(title: "Thank you!", message: "You purchase was successful.\n\(transaction.payment)"))
                
                if self.appDelegate.haveInitPurchases {
                    switch transaction.payment.productIdentifier {
                    case self.bundleID + "." + RegisteredPurchase.BowlOfRice.rawValue:
                        print("Purchase complete: BowlOfRice \(self.appDelegate.bowlsOfRice)")
                        self.appDelegate.bowlsOfRice += 1
                        print("                   BowlOfRice \(self.appDelegate.bowlsOfRice)")
                    case self.bundleID + "." + RegisteredPurchase.Slide_5_Piece.rawValue:
                        print("Purchase complete: Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                        self.appDelegate.haveUnlocked_5PiecePuzzle = true
                        print("                   Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                    case self.bundleID + "." + RegisteredPurchase.Fire_And_Ice.rawValue:
                        print("Purchase complete: Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                        self.appDelegate.haveUnlocked_FireAndIce = true
                        print("                   Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                    case self.bundleID + "." + RegisteredPurchase.Vertical_Puzzle.rawValue:
                        print("Purchase complete: Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                        self.appDelegate.haveUnlocked_VerticalPuzzle = true
                        print("                   Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                    case self.bundleID + "." + RegisteredPurchase.UnlockAll.rawValue:
                        print("Purchase complete: UnlockAll \(self.appDelegate.haveUnlocked_All)")
                        self.appDelegate.haveUnlocked_All = true
                        print("                   UnlockAll \(self.appDelegate.haveUnlocked_All)")
                    case self.bundleID + "." + RegisteredPurchase.AutoRenewable.rawValue:
                        print("Purchase complete: AutoRenewable !!!!!!!")
                    case self.bundleID + "." + RegisteredPurchase.Amulet_3.rawValue:
                        print("Purchase complete: Amulet_3 \(self.appDelegate.amuletCount)")
                        self.appDelegate.amuletCount += 3
                        self.appDelegate.amuletsPurchased += 3
                        print("                   Amulet_3 \(self.appDelegate.amuletCount)")
                    case self.bundleID + "." + RegisteredPurchase.Amulet_10.rawValue:
                        print("Purchase complete: Amulet_10 \(self.appDelegate.amuletCount)")
                        self.appDelegate.amuletCount += 10
                        self.appDelegate.amuletsPurchased += 10
                        print("                   Amulet_10 \(self.appDelegate.amuletCount)")
                    default:
                        print("Purchase complete: Unknown Purchase !!!!!")
                    }
                    Defaults().save_Defaults(updateStreak: false)
                }


            }else if transaction.transactionState == .failed {
                print("transaction failed \(String(describing: transaction.transactionIdentifier))")
                //showAlert(alert: alertWithTitle(title: "Purchase failed", message: "You purchase could not be completed."))
            }
        }
        self.appDelegate.haveInitPurchases = true
    }
}

extension ViewController_Unlock {
    
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
    
    
}
