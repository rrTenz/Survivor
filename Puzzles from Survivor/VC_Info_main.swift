//
//  VC_Info_main.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/13/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import MessageUI

class VC_Info_main: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func button_Email(_ sender: Any) {
        self.sendEmail(body: "", subject: "Puzzle Cluster - Questions/Comments")
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
    
    @IBAction func button_Facebook(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/rrTenz/")! as URL)
    }
    
    @IBAction func button_YouTube(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://www.youtube.com/channel/UCqwHMKREQeq56nFcQiLPtSg")! as URL)
    }
}
