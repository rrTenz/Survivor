//
//  VC_Hanoi_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 9/13/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_Hanoi_Practice: UIViewController {
    
    @IBOutlet weak var Label_Block_0_0: UILabel!
    @IBOutlet weak var Label_Block_0_1: UILabel!
    @IBOutlet weak var Label_Block_0_2: UILabel!
    @IBOutlet weak var Label_Block_0_3: UILabel!
    
    @IBOutlet weak var Label_Block_1_0: UILabel!
    @IBOutlet weak var Label_Block_1_1: UILabel!
    @IBOutlet weak var Label_Block_1_2: UILabel!
    @IBOutlet weak var Label_Block_1_3: UILabel!
    
    @IBOutlet weak var Label_Block_2_0: UILabel!
    @IBOutlet weak var Label_Block_2_1: UILabel!
    @IBOutlet weak var Label_Block_2_2: UILabel!
    @IBOutlet weak var Label_Block_2_3: UILabel!
    
    var Label_0_Array: [UILabel] = []
    var Label_1_Array: [UILabel] = []
    var Label_2_Array: [UILabel] = []
    
    @IBOutlet weak var Label_InHand: UILabel!
    @IBOutlet weak var Label_MoveCount: UILabel!
    
    var Column0: [Block] = []
    var Column1: [Block] = []
    var Column2: [Block] = []
    var InHand = Block(size: 0)
    var MoveCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        NewGame()
    }
    
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    func NewGame() {
        Label_0_Array = [Label_Block_0_0, Label_Block_0_1, Label_Block_0_2, Label_Block_0_3]
        Label_1_Array = [Label_Block_1_0, Label_Block_1_1, Label_Block_1_2, Label_Block_1_3]
        Label_2_Array = [Label_Block_2_0, Label_Block_2_1, Label_Block_2_2, Label_Block_2_3]
        
        Column0.removeAll()
        Column1.removeAll()
        Column2.removeAll()
        InHand = Block(size: 0)
        
        Column0.append(Block(size: 4))
        Column0.append(Block(size: 3))
        Column0.append(Block(size: 2))
        Column0.append(Block(size: 1))
        
        UpdateBlockLabels()
        UpdateButtonTitles()
        MoveCount = 0
        Label_MoveCount.text = "Moves: \(MoveCount)"
    }
    
    func UpdateBlockLabels() {
        for label in Label_0_Array {
            label.text = ""
        }
        for label in Label_1_Array {
            label.text = ""
        }
        for label in Label_2_Array {
            label.text = ""
        }
        
        var i = 0
        for block in Column0 {
            Label_0_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        i = 0
        for block in Column1 {
            Label_1_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        i = 0
        for block in Column2 {
            Label_2_Array[i].text = getBlockString(size: block.size)
            i += 1
        }
        
        Label_InHand.text = getBlockString(size: InHand.size)
    }
    
    func UpdateButtonTitles(){
        if InHand.size == 0 {
            Button_Take0_outlet.setTitle("Take", for: .normal)
            Button_Take1_outlet.setTitle("Take", for: .normal)
            Button_Take2_outlet.setTitle("Take", for: .normal)
        }else {
            Button_Take0_outlet.setTitle("Place", for: .normal)
            Button_Take1_outlet.setTitle("Place", for: .normal)
            Button_Take2_outlet.setTitle("Place", for: .normal)
        }
    }
    
    func getBlockString(size: Int) -> String{
        var myString = ""
        if size == 1 {
            myString = "O"
        }else if size == 2 {
            myString = "OO"
        }else if size == 3 {
            myString = "OOO"
        }else if size == 4 {
            myString = "OOOO"
        }
        return myString
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var Button_Take0_outlet: UIButton!
    @IBAction func Button_Take0(_ sender: Any) {
        if Column0.count > 0 && InHand.size == 0 {   // Take from Column 0
            InHand = Column0.last!
            Column0.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column0.count == 0 || Column0.last!.size > InHand.size) {  //Place into Column 0
            Column0.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    @IBOutlet weak var Button_Take1_outlet: UIButton!
    @IBAction func Button_Take1(_ sender: Any) {
        if Column1.count > 0 && InHand.size == 0 {   // Take from Column 1
            InHand = Column1.last!
            Column1.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column1.count == 0 || Column1.last!.size > InHand.size) {  //Place into Column 1
            Column1.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    @IBOutlet weak var Button_Take2_outlet: UIButton!
    @IBAction func Button_Take2(_ sender: Any) {
        if Column2.count > 0 && InHand.size == 0 {   // Take from Column 2
            InHand = Column2.last!
            Column2.removeLast()
            UpdateBlockLabels()
            UpdateButtonTitles()
        }else if InHand.size > 0 && (Column2.count == 0 || Column2.last!.size > InHand.size) {  //Place into Column 2
            Column2.append(InHand)
            InHand.size = 0
            UpdateBlockLabels()
            UpdateButtonTitles()
            MoveCount += 1
            Label_MoveCount.text = "Moves: \(MoveCount)"
            CheckForWin()
        }
    }
    
    func CheckForWin() {
        if Column0.count == 0 && Column1.count == 0 && Column2.count == 4 {
            Label_InHand.text = "You Win!"
        }
    }
    
    
    struct Block {
        var size = 0
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
