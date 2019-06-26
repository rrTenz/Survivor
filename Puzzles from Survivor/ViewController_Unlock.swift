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
    case UnlockAll = "unlockAll"
    case Slide_5_Piece = "5_Piece_Puzzle"
    case Fire_And_Ice = "Fire_And_Ice"
    case Vertical_Puzzle = "Vertical_Puzzle"
    case Tile_Puzzle = "Tile_Puzzle"
    case Amulet_3 = "ImmunityNecklace_3"
    case Amulet_10 = "ImmunityNecklace_10"
    case BowlOfRice = "BowlOfRice"
    case CannotAfford = ""
    
    case AutoRenewable = "AutoRenewable"
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
    
    let STR_PROUDCT_NOT_AVAILABLE = "Product not available"
    
    var myArray: [String] = []
    var defaultArray = ["$2.99 - Unlock All - Unlocks all current and future puzzles",
                        "$0.99 - 5 Piece Slide Puzzle - Unlock 5 Piece Slide Puzzle",
                        "$0.99 - Fire and Ice - Unlock Fire and Ice Puzzle",
                        "$0.99 - Vertical Puzzle - Unlock Vertical Puzzle",
                        "$0.99 - Tile Puzzle - Unlock Tile Puzzle",
                        "$0.99 - 3 Amulets - Keep your streak alive 3 time (3 days)",
                        "$1.99 - 10 Amulets - Keep your streak alive 3 time (3 days)",
                        "$0.99 - Bowl of Rice - Get option to buy Amulets before streak reset",
                        "I can't afford it :("]
    var RegisteredPurchaseArray: [RegisteredPurchase] = [.UnlockAll,
                                                         .Slide_5_Piece,
                                                         .Fire_And_Ice,
                                                         .Vertical_Puzzle,
                                                         .Tile_Puzzle,
                                                         .Amulet_3,
                                                         .Amulet_10,
                                                         .BowlOfRice,
                                                         .CannotAfford]
    
    
    let bundleID = "com.rrtenz.puzzlesfromsurvivor2"
    
    var SlidePuzzle_5 = RegisteredPurchase.Slide_5_Piece
    var FireAndIce = RegisteredPurchase.Fire_And_Ice
    var VerticalPuzzle = RegisteredPurchase.Vertical_Puzzle
    var TilePuzzle = RegisteredPurchase.Tile_Puzzle
    var UnlockAll = RegisteredPurchase.UnlockAll
    var getInfoIndex = 0
    var verifyPurchaseIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        EasterEgg_outlet.isHidden = true
    }
    
    var timer = Timer()
    override func viewDidAppear(_ animated: Bool) {
        getInfoIndex = 0
        myArray.removeAll()
        getInfo(purchase: RegisteredPurchaseArray[getInfoIndex])
        promoPressCount = 0
        EasterEgg_outlet.isHidden = true
        timer.invalidate()
    }
    
    var timerCount = 0.0
    @objc func incrementTimer() {
        timerCount += 0.1
        if timerCount > 2.0 {
            //print("reset timer")
            promoPressCount = 0
            timerCount = 0.00000000001
            EasterEgg_outlet.isHidden = true
        }
    }
    
    @IBAction func button_Back(_ sender: Any) {
        timer.invalidate()
    }
    @IBAction func button_Egg(_ sender: Any) {
        timer.invalidate()
    }
    
    var promoPressCount = 0
    @IBAction func Button_enterPromoCode(_ sender: Any) {
        #if false
        if promoPressCount < 9 {
            promoPressCount += 1
            if timerCount > 0.00000000001 {
                timerCount = 0.00000000001
            }
        }else {
            EasterEgg_outlet.isHidden = false
        }
        //print(promoPressCount)
        if timerCount <= 0.0 {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        }
        #endif
    }
    
    @IBAction func Restore_button(_ sender: Any) {
        restorePurchases()
    }
    
    @IBOutlet weak var EasterEgg_outlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myArray.count > 0 {
            return myArray.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if myArray.count > 0 {
            cell.textLabel?.text = myArray[indexPath.row]
        }else {
            cell.textLabel?.text = "No purchases available"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("do something \(indexPath.row) \(myArray[indexPath.row])")
        if myArray.count > 0 {
            if myArray[indexPath.row] == STR_PROUDCT_NOT_AVAILABLE {
                showAlert(alert: alertWithTitle(title: "Not Available", message: "This product is not yet available. Check back soon."))
            }else if myArray.count - 1 == indexPath.row {
                showAlert(alert: alertWithTitle(title: "No Money?", message: "Hi, this is rrTenz from rrTenz Games. I am trying to make\n'Puzzle Cluster'\navailable to as many people as possible. However I have locked some puzzles and am asking for a contribution because I do need some money to keep this project going.\n\nIf you really don't have the money or can't get mom or dad's permission to make a purchase, here are a few things you can do:\n\n1. Follow 'rrTenz Games' on Facebook\n2. Subscribe to 'Survivor Geek' on YouTube\n3. Share Puzzle Cluster on social media\n\nWhen you have done at least one of these things, take a screen shot and email it to rrtenz@gmail.com\nFor each one you do, I will send you a promo code to 1 puzzle of your choice. If you do all 3 of those things, I'll give you a promo code for all current and future puzzles! I can only give a limited number of promo codes, so don't wait."))
            }else {
                purchase(purchase: RegisteredPurchaseArray[indexPath.row])
            }
        }
    }
    
    func getInfo(purchase: RegisteredPurchase) {
        NetworkActivityIndicatorManager.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + purchase.rawValue], completion: {
            result in
            NetworkActivityIndicatorManager.NetworkOperationFinished()
            
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                if product.localizedTitle != "" && product.localizedDescription != "" {
                    self.myArray.append("\(priceString) - \(product.localizedTitle) - \(product.localizedDescription)")
                }else {
                    self.myArray.append(self.defaultArray[self.getInfoIndex])
                }
            }else {
                self.myArray.append(self.STR_PROUDCT_NOT_AVAILABLE)
                //self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            }
            
            if self.getInfoIndex < self.RegisteredPurchaseArray.count - 2 {
                self.getInfoIndex += 1
                self.getInfo(purchase: self.RegisteredPurchaseArray[self.getInfoIndex])
            }else {
                self.myArray.append("I can't afford it :(") //holder for "cannot afford"
            }
            self.tableView.reloadData()
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
                case self.bundleID + "." + RegisteredPurchase.Fire_And_Ice.rawValue:
                    print("Purchase complete: Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                    self.appDelegate.haveUnlocked_FireAndIce = true
                    print("                   Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                case self.bundleID + "." + RegisteredPurchase.Vertical_Puzzle.rawValue:
                    print("Purchase complete: Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                    self.appDelegate.haveUnlocked_VerticalPuzzle = true
                    print("                   Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                case self.bundleID + "." + RegisteredPurchase.Tile_Puzzle.rawValue:
                    print("Purchase complete: Tile Puzzle \(self.appDelegate.haveUnlocked_TilePuzzle)")
                    self.appDelegate.haveUnlocked_TilePuzzle = true
                    print("                   Tile Puzzle \(self.appDelegate.haveUnlocked_TilePuzzle)")
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
                
                switch product.productId {
                case self.bundleID + "." + RegisteredPurchase.Slide_5_Piece.rawValue:
                    print("Restore complete: Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                    self.appDelegate.haveUnlocked_5PiecePuzzle = true
                    print("                   Slide_5_Piece \(self.appDelegate.haveUnlocked_5PiecePuzzle)")
                case self.bundleID + "." + RegisteredPurchase.Fire_And_Ice.rawValue:
                    print("Restore complete: Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                    self.appDelegate.haveUnlocked_FireAndIce = true
                    print("                   Fire and Ice \(self.appDelegate.haveUnlocked_FireAndIce)")
                case self.bundleID + "." + RegisteredPurchase.Vertical_Puzzle.rawValue:
                    print("Restore complete: Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                    self.appDelegate.haveUnlocked_VerticalPuzzle = true
                    print("                   Vertical Puzzle \(self.appDelegate.haveUnlocked_VerticalPuzzle)")
                case self.bundleID + "." + RegisteredPurchase.Tile_Puzzle.rawValue:
                    print("Restore complete: Tile Puzzle \(self.appDelegate.haveUnlocked_TilePuzzle)")
                    self.appDelegate.haveUnlocked_TilePuzzle = true
                    print("                   Tile Puzzle \(self.appDelegate.haveUnlocked_TilePuzzle)")
                case self.bundleID + "." + RegisteredPurchase.UnlockAll.rawValue:
                    print("Restore complete: UnlockAll \(self.appDelegate.haveUnlocked_All)")
                    self.appDelegate.haveUnlocked_All = true
                    print("                   UnlockAll \(self.appDelegate.haveUnlocked_All)")
                default:
                    print("Restore default ??????????????????????")
                }
            }
            Defaults().save_Defaults(updateStreak: false)
            
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
