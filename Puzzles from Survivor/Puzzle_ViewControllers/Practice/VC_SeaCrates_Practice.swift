//
//  VC_SeaCrates_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 8/31/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_SeaCrates_Practice: UIViewController {

    @IBOutlet weak var textField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.scrollRangeToVisible(NSMakeRange(0, 0))
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
