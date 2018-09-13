//
//  VC_21Flags_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 9/1/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_21Flags_Practice: UIViewController {

    @IBOutlet weak var Label_Status1: UILabel!
    @IBOutlet weak var Label_Status2: UILabel!
    
    @IBOutlet weak var Flag01: UIImageView!
    @IBOutlet weak var Flag02: UIImageView!
    @IBOutlet weak var Flag03: UIImageView!
    @IBOutlet weak var Flag04: UIImageView!
    @IBOutlet weak var Flag05: UIImageView!
    @IBOutlet weak var Flag06: UIImageView!
    @IBOutlet weak var Flag07: UIImageView!
    @IBOutlet weak var Flag08: UIImageView!
    @IBOutlet weak var Flag09: UIImageView!
    @IBOutlet weak var Flag10: UIImageView!
    @IBOutlet weak var Flag11: UIImageView!
    @IBOutlet weak var Flag12: UIImageView!
    @IBOutlet weak var Flag13: UIImageView!
    @IBOutlet weak var Flag14: UIImageView!
    @IBOutlet weak var Flag15: UIImageView!
    @IBOutlet weak var Flag16: UIImageView!
    @IBOutlet weak var Flag17: UIImageView!
    @IBOutlet weak var Flag18: UIImageView!
    @IBOutlet weak var Flag19: UIImageView!
    @IBOutlet weak var Flag20: UIImageView!
    @IBOutlet weak var Flag21: UIImageView!
    var flagArray: [UIImageView] = []
    
    
    var whosTurn = 1    //0 = Computer, 1 = Player1, 2 = Player2
    var flagsRemaining = 21
    var didWin = false
    var isHard = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagArray = [Flag01,Flag02,Flag03,Flag04,Flag05,Flag06,Flag07,Flag08,Flag09,Flag10,Flag11,Flag12,Flag13,Flag14,Flag15,Flag16,Flag17,Flag18,Flag19,Flag20,Flag21]
        StartNewGame()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        StartNewGame()
    }
    
    @IBOutlet weak var Switch_PlayerType_outlet: UISwitch!
    @IBAction func Switch_PlayerType(_ sender: Any) {
        StartNewGame()
        
        if Switch_PlayerType_outlet.isOn {
            Switch_EasyHard_outlet.isHidden = false
            Label_Easy.isHidden = false
            Label_Hard.isHidden = false
        }else {
            Switch_EasyHard_outlet.isHidden = true
            Label_Easy.isHidden = true
            Label_Hard.isHidden = true
        }
    }
    
    @IBOutlet weak var Switch_EasyHard_outlet: UISwitch!
    @IBOutlet weak var Label_Easy: UILabel!
    @IBOutlet weak var Label_Hard: UILabel!
    @IBAction func Switch_EasyHard(_ sender: Any) {
        StartNewGame()
        
        isHard = Switch_EasyHard_outlet.isOn
    }
    
    
    @IBOutlet weak var Button_Remove1_outlet: UIButton!
    @IBAction func Button_Remove1(_ sender: Any) {
        var flagsTaken = 0
        flagsTaken += RemoveFlag()
        Label_Status1.text = "\(flagsTaken) taken, \(flagsRemaining) remaining"
        SwitchPlayer(flagsTaken: 1)
    }
    
    @IBOutlet weak var Button_Remove2_outlet: UIButton!
    @IBAction func Button_Remove2(_ sender: Any) {
        var flagsTaken = 0
        flagsTaken += RemoveFlag()
        flagsTaken += RemoveFlag()
        Label_Status1.text = "\(flagsTaken) taken, \(flagsRemaining) remaining"
        SwitchPlayer(flagsTaken: 2)
    }
    
    @IBOutlet weak var Button_Remove3_outlet: UIButton!
    @IBAction func Button_Remove3(_ sender: Any) {
        var flagsTaken = 0
        flagsTaken += RemoveFlag()
        flagsTaken += RemoveFlag()
        flagsTaken += RemoveFlag()
        Label_Status1.text = "\(flagsTaken) taken, \(flagsRemaining) remaining"
        SwitchPlayer(flagsTaken: 3)
    }
    
    func StartNewGame() {
        Label_Status1.text = ""
        Label_Status2.text = "Player 1's turn"
        whosTurn = 1
        ResetFlags()
        didWin = false
        
        Button_Remove1_outlet.isHidden = false
        Button_Remove2_outlet.isHidden = false
        Button_Remove3_outlet.isHidden = false
    }
    
    func ResetFlags() {
        flagsRemaining = 21
        for flag in flagArray {
            flag.isHidden = false
        }
    }
    
    func RemoveFlag()->Int {
        if flagsRemaining == 0 {
            return 0
        }
        
        flagsRemaining -= 1
        if flagsRemaining >= 0 {
            flagArray[flagsRemaining].isHidden = true
        }
        if flagsRemaining == 0 {
            didWin = true
            if whosTurn == 0 {
                Label_Status2.text = "The Computer Wins"
            }else if whosTurn == 1 {
                Label_Status2.text = "Player 1 Wins"
            }else {
                Label_Status2.text = "Player 2 Wins"
            }
            
            Button_Remove1_outlet.isHidden = true
            Button_Remove2_outlet.isHidden = true
            Button_Remove3_outlet.isHidden = true
        }
        
        return 1
    }
    
    func SwitchPlayer(flagsTaken: Int) {
        if didWin {
            return
        }
        
        Label_Status1.text = "\(flagsTaken) taken, \(flagsRemaining) remaining"
        
        if whosTurn == 0 || whosTurn == 2 {
            whosTurn = 1    //always switch to Player1 after Computer or Player2
            Label_Status2.text = "Player 1's turn"
        }else if Switch_PlayerType_outlet.isOn {
            whosTurn = 0    //After Player1's turn, switch to Computer if playing against computer
            Label_Status2.text = "Computer's turn"
            
            Button_Remove1_outlet.isHidden = true
            Button_Remove2_outlet.isHidden = true
            Button_Remove3_outlet.isHidden = true
            
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(DoComputersTurn), userInfo: nil, repeats: false)
        }else {
            whosTurn = 2    //After Player1's turn, switch to Player2 if playing against another player
            Label_Status2.text = "Player 2's turn"
        }
    }
    
    var timer = Timer()
    @objc func DoComputersTurn() {
        timer.invalidate()
        var removeCount = 0
        
        //AI
        if flagsRemaining <= 3 {
            removeCount = flagsRemaining
        }else if isHard {
            removeCount = flagsRemaining % 4
            if removeCount == 0 {
                removeCount = Int(arc4random_uniform(2)) + 1
            }
        }else {
            removeCount = Int(arc4random_uniform(2)) + 1
        }        
        
        for _ in 0..<removeCount {
            _ = RemoveFlag()
        }
        Label_Status1.text = "\(removeCount) taken, \(flagsRemaining) remaining"
        SwitchPlayer(flagsTaken: removeCount)
        
        Button_Remove1_outlet.isHidden = false
        Button_Remove2_outlet.isHidden = false
        Button_Remove3_outlet.isHidden = false
    }
    
}
