//
//  VC_SeaCrates_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 8/31/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_SeaCrates_Practice: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var textField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.scrollRangeToVisible(NSMakeRange(0, 0))
        
        NewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Button_GoToLink(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://docs.google.com/document/d/15X6_cSRoLe2hVMCcdYRhlxoHPRgJBalVrTodfJsmGNg/edit?usp=sharing")! as URL)
    }
    
    @IBAction func Button_CopyLink(_ sender: Any) {
        UIPasteboard.general.string = "https://docs.google.com/document/d/15X6_cSRoLe2hVMCcdYRhlxoHPRgJBalVrTodfJsmGNg/edit?usp=sharing"
    }
    
    @IBOutlet weak var Image_0_0: UIImageView!
    @IBOutlet weak var Image_0_1_0: UIImageView!
    @IBOutlet weak var Image_0_1_1: UIImageView!
    @IBOutlet weak var Image_0_1_2: UIImageView!
    @IBOutlet weak var Image_0_2: UIImageView!
    @IBOutlet weak var Image_0_3: UIImageView!
    
    @IBOutlet weak var Image_1_0: UIImageView!
    @IBOutlet weak var Image_1_1_0: UIImageView!
    @IBOutlet weak var Image_1_1_1: UIImageView!
    @IBOutlet weak var Image_1_1_2: UIImageView!
    @IBOutlet weak var Image_1_2: UIImageView!
    @IBOutlet weak var Image_1_3: UIImageView!
    
    @IBOutlet weak var Image_2_0: UIImageView!
    @IBOutlet weak var Image_2_1_0: UIImageView!
    @IBOutlet weak var Image_2_1_1: UIImageView!
    @IBOutlet weak var Image_2_1_2: UIImageView!
    @IBOutlet weak var Image_2_2: UIImageView!
    @IBOutlet weak var Image_2_3: UIImageView!
    
    @IBOutlet weak var Image_3_0: UIImageView!
    @IBOutlet weak var Image_3_1_0: UIImageView!
    @IBOutlet weak var Image_3_1_1: UIImageView!
    @IBOutlet weak var Image_3_1_2: UIImageView!
    @IBOutlet weak var Image_3_2: UIImageView!
    @IBOutlet weak var Image_3_3: UIImageView!
    
    @IBOutlet weak var Image_Top_0: UIImageView!
    @IBOutlet weak var Image_Top_1: UIImageView!
    @IBOutlet weak var Image_Top_2: UIImageView!
    @IBOutlet weak var Image_Top_3: UIImageView!
    @IBOutlet weak var Image_Bottom_0: UIImageView!
    @IBOutlet weak var Image_Bottom_1: UIImageView!
    @IBOutlet weak var Image_Bottom_2: UIImageView!
    @IBOutlet weak var Image_Bottom_3: UIImageView!
    @IBOutlet weak var Image_Left_0: UIImageView!
    @IBOutlet weak var Image_Left_1: UIImageView!
    @IBOutlet weak var Image_Left_2: UIImageView!
    @IBOutlet weak var Image_Left_3: UIImageView!
    @IBOutlet weak var Image_Right_0: UIImageView!
    @IBOutlet weak var Image_Right_1: UIImageView!
    @IBOutlet weak var Image_Right_2: UIImageView!
    @IBOutlet weak var Image_Right_3: UIImageView!
    
    @IBAction func Button_0_left(_ sender: Any) {
        let temp = Image_0_0.backgroundColor
        Image_0_0.backgroundColor = Image_0_1_1.backgroundColor
        Image_0_1_1.backgroundColor = Image_0_2.backgroundColor
        Image_0_2.backgroundColor = Image_0_3.backgroundColor
        Image_0_3.backgroundColor = temp
        UpdateMiddleColors()
        
    }
    @IBAction func Button_0_right(_ sender: Any) {
        let temp = Image_0_3.backgroundColor
        Image_0_3.backgroundColor = Image_0_2.backgroundColor
        Image_0_2.backgroundColor = Image_0_1_1.backgroundColor
        Image_0_1_1.backgroundColor = Image_0_0.backgroundColor
        Image_0_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_0_up(_ sender: Any) {
        let temp = Image_0_1_0.backgroundColor
        Image_0_1_0.backgroundColor = Image_0_1_1.backgroundColor
        Image_0_1_1.backgroundColor = Image_0_1_2.backgroundColor
        Image_0_1_2.backgroundColor = Image_0_3.backgroundColor
        Image_0_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_0_down(_ sender: Any) {
        let temp = Image_0_3.backgroundColor
        Image_0_3.backgroundColor = Image_0_1_2.backgroundColor
        Image_0_1_2.backgroundColor = Image_0_1_1.backgroundColor
        Image_0_1_1.backgroundColor = Image_0_1_0.backgroundColor
        Image_0_1_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_1_left(_ sender: Any) {
        let temp = Image_1_0.backgroundColor
        Image_1_0.backgroundColor = Image_1_1_1.backgroundColor
        Image_1_1_1.backgroundColor = Image_1_2.backgroundColor
        Image_1_2.backgroundColor = Image_1_3.backgroundColor
        Image_1_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_1_right(_ sender: Any) {
        let temp = Image_1_3.backgroundColor
        Image_1_3.backgroundColor = Image_1_2.backgroundColor
        Image_1_2.backgroundColor = Image_1_1_1.backgroundColor
        Image_1_1_1.backgroundColor = Image_1_0.backgroundColor
        Image_1_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_1_up(_ sender: Any) {
        let temp = Image_1_1_0.backgroundColor
        Image_1_1_0.backgroundColor = Image_1_1_1.backgroundColor
        Image_1_1_1.backgroundColor = Image_1_1_2.backgroundColor
        Image_1_1_2.backgroundColor = Image_1_3.backgroundColor
        Image_1_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_1_down(_ sender: Any) {
        let temp = Image_1_3.backgroundColor
        Image_1_3.backgroundColor = Image_1_1_2.backgroundColor
        Image_1_1_2.backgroundColor = Image_1_1_1.backgroundColor
        Image_1_1_1.backgroundColor = Image_1_1_0.backgroundColor
        Image_1_1_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_2_left(_ sender: Any) {
        let temp = Image_2_0.backgroundColor
        Image_2_0.backgroundColor = Image_2_1_1.backgroundColor
        Image_2_1_1.backgroundColor = Image_2_2.backgroundColor
        Image_2_2.backgroundColor = Image_2_3.backgroundColor
        Image_2_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_2_right(_ sender: Any) {
        let temp = Image_2_3.backgroundColor
        Image_2_3.backgroundColor = Image_2_2.backgroundColor
        Image_2_2.backgroundColor = Image_2_1_1.backgroundColor
        Image_2_1_1.backgroundColor = Image_2_0.backgroundColor
        Image_2_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_2_up(_ sender: Any) {
        let temp = Image_2_1_0.backgroundColor
        Image_2_1_0.backgroundColor = Image_2_1_1.backgroundColor
        Image_2_1_1.backgroundColor = Image_2_1_2.backgroundColor
        Image_2_1_2.backgroundColor = Image_2_3.backgroundColor
        Image_2_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_2_down(_ sender: Any) {
        let temp = Image_2_3.backgroundColor
        Image_2_3.backgroundColor = Image_2_1_2.backgroundColor
        Image_2_1_2.backgroundColor = Image_2_1_1.backgroundColor
        Image_2_1_1.backgroundColor = Image_2_1_0.backgroundColor
        Image_2_1_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_3_left(_ sender: Any) {
        let temp = Image_3_0.backgroundColor
        Image_3_0.backgroundColor = Image_3_1_1.backgroundColor
        Image_3_1_1.backgroundColor = Image_3_2.backgroundColor
        Image_3_2.backgroundColor = Image_3_3.backgroundColor
        Image_3_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_3_right(_ sender: Any) {
        let temp = Image_3_3.backgroundColor
        Image_3_3.backgroundColor = Image_3_2.backgroundColor
        Image_3_2.backgroundColor = Image_3_1_1.backgroundColor
        Image_3_1_1.backgroundColor = Image_3_0.backgroundColor
        Image_3_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_3_up(_ sender: Any) {
        let temp = Image_3_1_0.backgroundColor
        Image_3_1_0.backgroundColor = Image_3_1_1.backgroundColor
        Image_3_1_1.backgroundColor = Image_3_1_2.backgroundColor
        Image_3_1_2.backgroundColor = Image_3_3.backgroundColor
        Image_3_3.backgroundColor = temp
        UpdateMiddleColors()
    }
    @IBAction func Button_3_down(_ sender: Any) {
        let temp = Image_3_3.backgroundColor
        Image_3_3.backgroundColor = Image_3_1_2.backgroundColor
        Image_3_1_2.backgroundColor = Image_3_1_1.backgroundColor
        Image_3_1_1.backgroundColor = Image_3_1_0.backgroundColor
        Image_3_1_0.backgroundColor = temp
        UpdateMiddleColors()
    }
    
    func UpdateMiddleColors() {
        Image_Top_0.backgroundColor = Image_0_1_1.backgroundColor
        Image_Top_1.backgroundColor = Image_1_1_1.backgroundColor
        Image_Top_2.backgroundColor = Image_2_1_1.backgroundColor
        Image_Top_3.backgroundColor = Image_3_1_1.backgroundColor
        Image_Bottom_0.backgroundColor = Image_0_3.backgroundColor
        Image_Bottom_1.backgroundColor = Image_1_3.backgroundColor
        Image_Bottom_2.backgroundColor = Image_2_3.backgroundColor
        Image_Bottom_3.backgroundColor = Image_3_3.backgroundColor
        Image_Left_0.backgroundColor = Image_0_0.backgroundColor
        Image_Left_1.backgroundColor = Image_1_0.backgroundColor
        Image_Left_2.backgroundColor = Image_2_0.backgroundColor
        Image_Left_3.backgroundColor = Image_3_0.backgroundColor
        Image_Right_0.backgroundColor = Image_0_2.backgroundColor
        Image_Right_1.backgroundColor = Image_1_2.backgroundColor
        Image_Right_2.backgroundColor = Image_2_2.backgroundColor
        Image_Right_3.backgroundColor = Image_3_2.backgroundColor
        
        CheckSolution()
    }
    
    @IBOutlet weak var Label_Solved: UILabel!
    func CheckSolution() {
        
        Label_Solved.text = ""
        var array = [Image_Top_0.backgroundColor, Image_Top_1.backgroundColor, Image_Top_2.backgroundColor, Image_Top_3.backgroundColor]
        var unique = Array(Set(array))
        if array.count != unique.count {
            return
        }
        array = [Image_Bottom_0.backgroundColor, Image_Bottom_1.backgroundColor, Image_Bottom_2.backgroundColor, Image_Bottom_3.backgroundColor]
        unique = Array(Set(array))
        if array.count != unique.count {
            return
        }
        array = [Image_Left_0.backgroundColor, Image_Left_1.backgroundColor, Image_Left_2.backgroundColor, Image_Left_3.backgroundColor]
        unique = Array(Set(array))
        if array.count != unique.count {
            return
        }
        array = [Image_Right_0.backgroundColor, Image_Right_1.backgroundColor, Image_Right_2.backgroundColor, Image_Right_3.backgroundColor]
        unique = Array(Set(array))
        if array.count != unique.count {
            return
        }
        
        Label_Solved.text = "You Win!"
    }
    
    func NewGame() {
        Image_0_0.backgroundColor = UIColor.red
        Image_0_1_0.backgroundColor = UIColor.red
        Image_0_1_1.backgroundColor = UIColor.yellow
        Image_0_1_2.backgroundColor = UIColor.red
        Image_0_2.backgroundColor = UIColor.green
        Image_0_3.backgroundColor = UIColor.blue
        
        Image_1_0.backgroundColor = UIColor.red
        Image_1_1_0.backgroundColor = UIColor.red
        Image_1_1_1.backgroundColor = UIColor.yellow
        Image_1_1_2.backgroundColor = UIColor.yellow
        Image_1_2.backgroundColor = UIColor.blue
        Image_1_3.backgroundColor = UIColor.green
        
        Image_2_0.backgroundColor = UIColor.blue
        Image_2_1_0.backgroundColor = UIColor.green
        Image_2_1_1.backgroundColor = UIColor.blue
        Image_2_1_2.backgroundColor = UIColor.green
        Image_2_2.backgroundColor = UIColor.red
        Image_2_3.backgroundColor = UIColor.yellow
        
        Image_3_0.backgroundColor = UIColor.green
        Image_3_1_0.backgroundColor = UIColor.blue
        Image_3_1_1.backgroundColor = UIColor.yellow
        Image_3_1_2.backgroundColor = UIColor.yellow
        Image_3_2.backgroundColor = UIColor.red
        Image_3_3.backgroundColor = UIColor.green
        
        UpdateMiddleColors()
    }
    

}
