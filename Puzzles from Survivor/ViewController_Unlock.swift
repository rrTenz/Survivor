//
//  ViewController_Unlock.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/25/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

var sharedSecret = "001c3876819a475cb7aae185ce2b8722"

enum RegisteredPurchase: String {
    case Slide_5_Piece = "5_Piece_Puzzle"
    case UnlockAll = "unlockAll"
    case AutoRenewable = "AutoRenewable"
    case BowlOfRice = "BowlOfRice"
    case ImmunityNecklace_3 = "ImmunityNecklace_3"
    case ImmunityNecklace_10 = "ImmunityNecklace_10"
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

class ViewController_Unlock: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myArray = ["Unlock All Current and Future Puzzles",
                   "Immunity Necklace (3) - Keep your streak alive 3 time (3 days)",
                   "Immunity Necklace (10) - Keep your streak alive 3 time (3 days)",
                   "5 Piece Slide Puzzle",
                   "Buy rrTenz a Bowl of Rice",
                   "I can't afford it :("]
    var RegisteredPurchaseArray: [RegisteredPurchase] = [.UnlockAll,
                                                         .ImmunityNecklace_3,
                                                         .ImmunityNecklace_10,
                                                         .Slide_5_Piece,
                                                         .BowlOfRice,
                                                         .CannotAfford]
    
    
    let bundleID = "com.rrtenz.puzzlesfromsurvivor"
    
    var SlidePuzzle_5 = RegisteredPurchase.Slide_5_Piece
    var UnlockAll = RegisteredPurchase.UnlockAll
    var getInfoIndex = 0
    var verifyPurchaseIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInfoIndex = 0
        getInfo(purchase: RegisteredPurchaseArray[getInfoIndex])
    }
    
    @IBAction func Button_enterPromoCode(_ sender: Any) {   //https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
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
                    case ImmunityNecklace = 1
                    case FirstDayOfStreak = 2
                    case BowlOfRice = 3
                    case Slide_5_Piece = 4
                    case LongestStreak = 5
                    case NecklacesPurchased = 6
                }
                if let typeEnum = PromoCodeType(rawValue: type) {
                    switch typeEnum {
                    case .UnlockAll:
                        alertMessage = "All current and future puzzles have been unlocked"
                        appDelegate.haveUnlocked_All = true
                    case .ImmunityNecklace:
                        alertMessage = "'Immunity Necklace' count\nhas changed from\n\(appDelegate.immunityNecklaceCount) to \(val)"
                        appDelegate.immunityNecklaceCount = val
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
                    case .NecklacesPurchased:
                        alertMessage = "'Necklaces Purchased' count\nhas changed from\n\(appDelegate.immunityNecklacesPurchased) to \(val)"
                        appDelegate.immunityNecklacesPurchased = val
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
        print("do something \(indexPath.row) \(myArray[indexPath.row])")
        
        if myArray.count - 1 == indexPath.row {
            showAlert(alert: alertWithTitle(title: "No Money?", message: "I am trying to make\n'Puzzles from Survivor'\navailable to as many people as possible. However I have locked some puzzles and am asking for a contribution because I do need some money to keep this project going.\n\nIf you don't have the money or can't get mom or dad's permission to make a purchase, send me an email, ask nicely, and I will give you a code to unlock the puzzles for free (especially if you send a screen shot of a possitive reveiw)."))
        }else {
            purchase(purchase: RegisteredPurchaseArray[indexPath.row])
        }
    }
    
    func getInfo(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                self.myArray[self.getInfoIndex] = "\(priceString) - \(product.localizedTitle) - \(product.localizedDescription)"
                
                if self.getInfoIndex < self.RegisteredPurchaseArray.count - 2 {
                    self.getInfoIndex += 1
                    self.getInfo(purchase: self.RegisteredPurchaseArray[self.getInfoIndex])
                }
                self.tableView.reloadData()
            }else {
                self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            }
        })
    }
    
    func purchase(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if case .success(let product) = result {
                
                switch product.productId {
                case self.bundleID + "." + RegisteredPurchase.BowlOfRice.rawValue:
                    print("Purchase complete: BowlOfRice \(self.appDelegate.bowlsOfRice)")
                    self.appDelegate.bowlsOfRice += 1
                    print("                   BowlOfRice \(self.appDelegate.bowlsOfRice)")
                case self.bundleID + "." + RegisteredPurchase.Slide_5_Piece.rawValue:
                    print("Purchase complete: Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                    self.appDelegate.haveUnlocked_5PiecePuzzle = true
                    print("                   Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                case self.bundleID + "." + RegisteredPurchase.UnlockAll.rawValue:
                    print("Purchase complete: UnlockAll \(self.appDelegate.haveUnlocked_All)")
                    self.appDelegate.haveUnlocked_All = true
                    print("                   UnlockAll \(self.appDelegate.haveUnlocked_All)")
                case self.bundleID + "." + RegisteredPurchase.AutoRenewable.rawValue:
                    print("Purchase complete: AutoRenewable !!!!!!!")
                case self.bundleID + "." + RegisteredPurchase.ImmunityNecklace_3.rawValue:
                    print("Purchase complete: ImmunityNecklace_3 \(self.appDelegate.immunityNecklaceCount)")
                    self.appDelegate.immunityNecklaceCount += 3
                    self.appDelegate.immunityNecklacesPurchased += 3
                    print("                   ImmunityNecklace_3 \(self.appDelegate.immunityNecklaceCount)")
                case self.bundleID + "." + RegisteredPurchase.ImmunityNecklace_10.rawValue:
                    print("Purchase complete: ImmunityNecklace_10 \(self.appDelegate.immunityNecklaceCount)")
                    self.appDelegate.immunityNecklaceCount += 10
                    self.appDelegate.immunityNecklacesPurchased += 10
                    print("                   ImmunityNecklace_10 \(self.appDelegate.immunityNecklaceCount)")
                default:
                    print("Purchase complete: Unknown Purchase !!!!!")
                }
                Defaults().save_Defaults(updateStreak: false)
                
            }
            self.showAlert(alert: self.alertForPurchaseResult(result: result))
        })
    }
    
    func restorePurchases() {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            
            self.showAlert(alert: self.alertForRestorePurchase(result: result))
            
        })
    }
    //27:06
//        func verifyReceipt() {
//            NetworkActivityIndicatorManager.NetworkOperationStarted()
//            SwiftyStoreKit.verifyreceipt (using: sharedSecret, completion: {
//                result in
//                NetworkActivityIndicatorManager.NetworkOperationFinished()
//
//                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
//
//                if case.error
//
//            })
//        }
    
    func verifyPurchase(product: RegisteredPurchase) {
            NetworkActivityIndicatorManager.NetworkOperationStarted()
            let validator = AppleReceiptValidator(service: .production)
            SwiftyStoreKit.verifyReceipt(using: validator, completion: {
                result in
                NetworkActivityIndicatorManager.NetworkOperationFinished()
                
                switch result {
                case .success(receipt: let receipt):
                    let productID = self.bundleID + "." + product.rawValue
                    
                    if product == .AutoRenewable {
                        let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: productID, inReceipt: receipt, validUntil: Date())
                        self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                    }else {
                        let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                        self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                    }
                case .error(error: let recError):
                    self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                    if case .noReceiptData = recError {
                        self.refreshReceipt()
                    }
                }
                
                if self.verifyPurchaseIndex < self.RegisteredPurchaseArray.count - 2 {
                    self.verifyPurchaseIndex += 1
                    self.verifyPurchase(product: self.RegisteredPurchaseArray[self.verifyPurchaseIndex])
                }
    
            })
        }
    
    func refreshReceipt() {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true, completion: {
            result in
            
            //self.showAlert(alert: self.alertForRefreshReceipt(result: result))
        })
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
    
    func alertForProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        }else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retreive product info", message: "Invalid product indentifier: \(invalidProductID)")
        }else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please contact support"
            return alertWithTitle(title: "Could not retreive product info", message: errorString)
        }
    }
    
    func alertForPurchaseResult(result: PurchaseResult) -> UIAlertController {
        switch result {
        case .success(purchase: let product):
            print("Purchase Successful: \(product.productId)")
            
            ////////////
            
            return alertWithTitle(title: "Thank You", message: "Purchase completed")
            
        case .error(error: let error):  //41:00
            print("Purchase failed: \(error)")
            return alertWithTitle(title: "Purchase failed", message: "\(error.localizedDescription)")
        }
    }
    
    func alertForRestorePurchase(result: RestoreResults) -> UIAlertController {
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error. Please contact support.")
        }else if result.restoredPurchases.count > 0 {
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored.")
        }else {
            return alertWithTitle(title: "Nothing to Restore", message: "No previous purchases were made.")
        }
    }
    
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        switch result {
        case.success(receipt: _):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(error: let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Reciept Verification", message: "No receipt data found, application will try to get a new one. Try Again.")
            default:
                return alertWithTitle(title: "Reciept Verification", message: "Receipt Verification failed.")
            }
        }
    }
    
    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased(item: _):
            return alertWithTitle(title: "Product is Purchased", message: "Product is Purchased was purchased and will not expire")
        case .notPurchased:
            return alertWithTitle(title: "Product not Purchased", message: "Product has never been purchased")
        }
    }
    
    func alertForVerifySubscription(result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased(item: _):
            return alertWithTitle(title: "Product is Purchased", message: "Product is Purchased was purchased and will not expire")
        case .notPurchased:
            return alertWithTitle(title: "Product not Purchased", message: "Product has never been purchased")
        case .expired(expiryDate: _, items: _  ):
            return alertWithTitle(title: "Expired Subscription", message: "Your subscription has expired")
        }
    }
    
    func alertForRefreshReceipt(result: SKReceiptRefreshRequest) -> UIAlertController {
        return alertWithTitle(title: "Refresh Receipt", message: "Trying to refresh receipt")
    }
}
