//
//  ViewController_PuzzlePicker.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/30/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import MessageUI

class ViewController_PuzzlePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MFMailComposeViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var labelPuzzle: UILabel!
    @IBOutlet weak var textView_PuzzleDescription: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var LockImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.PuzzleSelected = 0
        appDelegate.puzzleArraySimple = Constants.PuzzleArraySimple
        
        labelPuzzle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        textView_PuzzleDescription.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Description
        image.image = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Image
        LockImage.isHidden = true        
        
        label_Steak.text = "x\(appDelegate.streakCount)"
        label_Necklace.text = "x\(appDelegate.immunityNecklaceCount)"
    }
    
    func puzzleIsLocked() -> Bool {
        if appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Locked == false || appDelegate.haveUnlocked_All {
            return false
        }
        if appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Locked == true {
            if appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name == "5 Piece Slide Puzzle" {
                if appDelegate.haveUnlocked_5PiecePuzzle {
                    return false
                }else {
                    return true
                }
            }
        }
        fatalError()
    }
    
    let fontPercent: CGFloat = 0.03
    override func viewDidAppear(_ animated: Bool) {
        appDelegate.WatchVideo = ""
        appDelegate.isLearn = false
        appDelegate.isPractice = false
        
        Defaults().load_Defaults()
        
        if checkStreak() == false {
            if checkFreeNecklace() == false {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    if appDelegate.version != version {
                        Defaults().save_Defaults(updateStreak: false)
                        displayNewVersionAlert()
                    }
                }
            }
        }
        
        puzzlePickerView.selectRow(appDelegate.lastPuzzle_index, inComponent: 0, animated: false)
        appDelegate.PuzzleSelected = appDelegate.lastPuzzle_index
        labelPuzzle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        textView_PuzzleDescription.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Description
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        textView_PuzzleDescription.font = .systemFont(ofSize: screenHeight * fontPercent)
        image.image = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Image
        
        LockImage.isHidden = !puzzleIsLocked()
        
        label_Steak.text = "x\(appDelegate.streakCount)"
        label_Necklace.text = "x\(appDelegate.immunityNecklaceCount)"
    }
    
    var haveBeenGivenChanceToBuyNecklaces = false
    func checkStreak() -> Bool {
        var didDisplayAlert = false
        
        //Check to see if dateOfFirstCompletedPuzzle is the original 1970 value
        if appDelegate.daysBetween2Dates(date1: appDelegate.dateOfFirstCompletedPuzzle, date2: Date(timeIntervalSince1970: 0)) == 0 {
            //The beginning of a new streak
//            print("--set dateOfFirstCompletedPuzzle to yesterday")
//            appDelegate.dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: -1, to: Date())!  //set to yesterday
//            print("--set dateOfFirstCompletedPuzzle to today")
//            appDelegate.dateOfFirstCompletedPuzzle = Date()  //set to today
            print("--set dateOfFirstCompletedPuzzle to tomorrow")
            appDelegate.dateOfFirstCompletedPuzzle = Calendar.current.date(byAdding: .day, value: 1, to: Date())!  //set to yesterday
            appDelegate.giveFreeNecklace = true
            button_Streak.setImage(UIImage(named: "fire_gray2"), for: .normal)
        }else {
            //let today = Date()
            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
//            let lastCompleted = formatter.date(from: "2019/3/27 12:00")
            
            appDelegate.UpdateStreakVariables(didCompletePuzzle: false)
            if appDelegate.streakCount == 0 && appDelegate.immunityNecklaceCount <= 0 {
                appDelegate.giveFreeNecklace = true
            }
            let dayDiff = appDelegate.daysBetween2Dates(date1: appDelegate.dateOfLastCompletedPuzzle, date2: Date())
            
            if dayDiff == 0 {
                button_Streak.setImage(UIImage(named: "fire2"), for: .normal)
            }else {
                button_Streak.setImage(UIImage(named: "fire_gray2"), for: .normal)
            }
            
            if dayDiff >= 2 {
                let requiredNecklaces = dayDiff - 1
                    
                if appDelegate.immunityNecklaceCount >= requiredNecklaces {
                    didDisplayAlert = true
                    let alertController = UIAlertController(title: "Immunity Necklace", message: "Your streak of \(appDelegate.streakCount) day(s) has been lost\n\nWould you like to use\n\(requiredNecklaces) Immunity Necklace(s)\nto restore your streak?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("Yes Pressed")
                        self.appDelegate.immunityNecklaceCount -= requiredNecklaces
                        Defaults().save_Defaults(updateStreak: true)
                        self.updateStreakLabelAndImage()
                    }
                    let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("No Pressed")
                        self.appDelegate.dateOfFirstCompletedPuzzle = Date() //set to today
                        self.appDelegate.UpdateStreakVariables(didCompletePuzzle: false)
                        self.updateStreakLabelAndImage()
                        self.appDelegate.giveFreeNecklace = true
                    }
                    alertController.addAction(noAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else if haveBeenGivenChanceToBuyNecklaces == false {
                    haveBeenGivenChanceToBuyNecklaces = true
                    didDisplayAlert = true
                    let alertController = UIAlertController(title: "Torch Snuffed", message: "Your streak of \(appDelegate.streakCount) day(s) has been lost\n\nWould you like a chance to buy some\nImmunity Necklaces\nto restore your streak?\n\nYou will need \(dayDiff-1) necklace(s).", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("Yes Pressed")
                        self.goToStore()
                        self.label_Steak.text = "x\(self.appDelegate.streakCount)"
                        self.label_Necklace.text = "x\(self.appDelegate.immunityNecklaceCount)"
                    }
                    let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("No Pressed")
                        self.appDelegate.dateOfFirstCompletedPuzzle = Date() //set to today
                        self.appDelegate.UpdateStreakVariables(didCompletePuzzle: false)
                        self.updateStreakLabelAndImage()
                        self.appDelegate.giveFreeNecklace = true
                    }
                    alertController.addAction(noAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else if dayDiff >= 2 {
                    self.appDelegate.dateOfFirstCompletedPuzzle = Date() //set to today
                    self.appDelegate.UpdateStreakVariables(didCompletePuzzle: false)
                    self.updateStreakLabelAndImage()
                    self.appDelegate.giveFreeNecklace = true
                }
            }
        }
        return didDisplayAlert
    }
    
    func checkFreeNecklace() -> Bool {
        if appDelegate.giveFreeNecklace {
            appDelegate.giveFreeNecklace = false
            
            var str = ""
            if appDelegate.streakCount == 0 && appDelegate.immunityNecklaceCount <= 0 {
                str = "You have been given a free\nImmunity Necklace\nwhich can keep your streak alive if you miss one day. You can go to the 'Store' to get more."
                appDelegate.immunityNecklaceCount = 1
            }else {
                str = "Congratulations!\nYou have been given a free\nImmunity Necklace\nfor getting your streak to \(appDelegate.streakCount) days.\nKeep up the good work!"
            }
            
            let alertController = UIAlertController(title: "Free Immunity Necklace", message: str, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            Defaults().save_Defaults(updateStreak: false)
            return true
        }
        return false
    }
    
    func goToStore() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController_Unlock")
        self.present(controller, animated: true, completion: nil)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_Unlock") as? ViewController_Unlock {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func updateStreakLabelAndImage() {
        self.label_Steak.text = "x\(self.appDelegate.streakCount)"
        self.label_Necklace.text = "x\(self.appDelegate.immunityNecklaceCount)"
        if self.appDelegate.daysBetween2Dates(date1: appDelegate.dateOfLastCompletedPuzzle, date2: Date()) == 0 {
            self.button_Streak.setImage(UIImage(named: "fire2"), for: .normal)
        }
    }
    
    func displayNewVersionAlert() {
        let alertController = UIAlertController(title: "New Version!", message: "A new version has been released! We hope you enjoy the improvements and/or new puzzles.\n\nTo stay up to date, follow rrTenz on Facebook and subscribe to the Survivor Geek YouTube channel.\n\nIf you have suggestions or questions, please send emails to\n rrtenz@gmail.com", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let sendEmail = UIAlertAction(title: "Send Email", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Send Email")
            self.sendEmail(body: "", subject: "Puzzles from Survivor - Questions/Comments")
        }
        let goToFacebook = UIAlertAction(title: "Facebook", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Facebook")
            UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/rrTenz/")! as URL)
        }
        let goToYouTube = UIAlertAction(title: "YouTube", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("YouTube")
            UIApplication.shared.openURL(NSURL(string: "https://www.youtube.com/channel/UCqwHMKREQeq56nFcQiLPtSg")! as URL)
        }
        alertController.addAction(sendEmail)
        alertController.addAction(goToFacebook)
        alertController.addAction(goToYouTube)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendEmail(body: String, subject: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients(["rrtenz@gmail.com"])
            mail.setSubject(subject)
            mail.setMessageBody("\(body)", isHTML: false)
            
            present(mail, animated: true)
        }
        else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var puzzlePickerView: UIPickerView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(appDelegate.puzzleArraySimple[row].Name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
            pickerLabel?.font = UIFont(name: "Helvetica Neue", size: screenHeight * 0.04)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = "\(appDelegate.puzzleArraySimple[row].Name)"
        
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.puzzleArraySimple.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        appDelegate.PuzzleSelected = row
        labelPuzzle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        textView_PuzzleDescription.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Description
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        textView_PuzzleDescription.font = .systemFont(ofSize: screenHeight * fontPercent)
        image.image = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Image
        LockImage.isHidden = !puzzleIsLocked()
    }
    
    @IBAction func Button_Learn(_ sender: Any) {
        appDelegate.isLearn = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)        
        appDelegate.WatchVideo = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].VideoCode_Learn
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController_Puzzle")
        self.present(controller, animated: true, completion: nil)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_Puzzle") as? ViewController_Puzzle {
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func Button_Practice(_ sender: Any) {
        appDelegate.isPractice = true
        appDelegate.lastPuzzle_index = puzzlePickerView.selectedRow(inComponent: 0)
        Defaults().save_Defaults(updateStreak: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name {
        case "Slide Puzzle":
            //UIApplication.shared.openURL(NSURL(string: "https://www.proprofs.com/games/puzzle/sliding/survivor-cagayan-sliding-puzzle/")! as URL)
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_SlidePuzzle_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_SlidePuzzle_Practice") as? VC_SlidePuzzle_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "8 Piece Slide Puzzle":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_SlidePuzzle2_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_SlidePuzzle2_Practice") as? VC_SlidePuzzle2_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Five Piece Puzzle":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_FivePiece_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_FivePiece_Practice") as? VC_FivePiece_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Sea Crates":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_SeaCrates_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_SeaCrates_Practice") as? VC_SeaCrates_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Tower of Hanoi":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_Hanoi_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_Hanoi_Practice") as? VC_Hanoi_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "21 Flags":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_21Flags_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_21Flags_Practice") as? VC_21Flags_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Might as Well Jump":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_MightAsWellJump_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_MightAsWellJump_Practice") as? VC_MightAsWellJump_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "The Color and the Shape":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_ColorAndShape_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_ColorAndShape_Practice") as? VC_ColorAndShape_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Matchbox 25":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_Matchbox25_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_Matchbox25_Practice") as? VC_Matchbox25_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Spin Puzzle":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_SpinPuzzle_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_SpinPuzzle_Practice") as? VC_SpinPuzzle_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Combination Lock":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_CombinationLock_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_CombinationLock_Practice") as? VC_CombinationLock_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Flip Out":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_FlipOut_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_FlipOut_Practice") as? VC_FlipOut_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "A Numbers Game":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_NumbersGame_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_NumbersGame_Practice") as? VC_NumbersGame_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Cog Puzzle":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_CogPuzzle_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_CogPuzzle_Practice") as? VC_CogPuzzle_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Vertical Puzzle":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_VerticalPuzzle_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_VerticalPuzzle_Practice") as? VC_VerticalPuzzle_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "Vertically Challenged":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_VerticallyChallenged_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_VerticallyChallenged_Practice") as? VC_VerticallyChallenged_Practice {
                present(vc, animated: true, completion: nil)
            }
        case "5 Piece Slide Puzzle":
            if puzzleIsLocked() == false {
                let controller = storyboard.instantiateViewController(withIdentifier: "VC_SlidePuzzle3_Practice")
                self.present(controller, animated: true, completion: nil)
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_SlidePuzzle3_Practice") as? VC_SlidePuzzle3_Practice {
                    present(vc, animated: true, completion: nil)
                }
            }else {
                unlockAlert()
            }
        default:
            print("!!!!!! oops !!!!!!")
        }
    }
    
    func unlockAlert() {
        let alertController = UIAlertController(title: "Locked Puzzle", message: "This puzzle is locked. Press the 'Store' button to see options.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var label_Steak: UILabel!
    @IBOutlet weak var button_Streak: UIButton!
    @IBAction func button_Streak(_ sender: Any) {
        let alertController = UIAlertController(title: "Fire Represents Life", message: "Your current streak is \(appDelegate.streakCount) day(s).\n\nTo keep your torch lit (streak alive), you must complete at least one puzzle every day. If you miss a day, your streak will be set back to 0. You can keep your streak alive even if you miss a day by purchasing Immunity Necklaces. There are some puzzles that don't count towards your streak (e.g. Five Piece Puzzle, 21 Flags, Flip Out).\n\nIf the flame icon is gray, you need to complete a puzzle today.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var label_Necklace: UILabel!
    @IBAction func button_Necklace(_ sender: Any) {
        let alertController = UIAlertController(title: "Immunity Necklaces", message: "You currently have \(appDelegate.immunityNecklaceCount) necklace(s).\n\nOne immunity necklace will keep your streak alive for one day. If you miss three days, you will need to use three necklaces to keep your streak alive.\n\nIf you buy a\nBowl of Rice\nand you miss a day, you will be given the option to buy\nImmunity Necklaces\n before you streak is set to 0.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        resetDefaults()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
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
