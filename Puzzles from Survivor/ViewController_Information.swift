//
//  ViewController_Information.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 9/4/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class ViewController_Information: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let channelArray = ["CBS", "Steven Burrell", "Survivor Montage", "Survivor Scholars", "Gresham College", "pocket83", "MindYourDecisions", "Survivor Geek"]
    let urlArray = ["https://www.youtube.com/user/SurvivorOnCBS",   //cbs
                    "https://www.youtube.com/channel/UCYvl6b5ZBFELhx39B6siDvA", //Steven Burrell
                    "https://www.youtube.com/channel/UC_Ev4zHgAvPf_gBOa0r6pJw", //Survivor Montage
                    "https://www.youtube.com/channel/UCCGFf31wuJ_ipzAdl7Nvfcg", //Survivor Scholars
                    "https://www.youtube.com/channel/UC1t6kKXoBvjdr8m9KJ2Fx7A", //Gresham College
                    "https://www.youtube.com/channel/UCoCEoPxruw9HW58O-l3ttDQ", //pocket83
                    "https://www.youtube.com/channel/UCHnj59g7jezwTy5GeL8EA_g", //MindYourDecisions
                    "https://www.youtube.com/channel/UCqwHMKREQeq56nFcQiLPtSg", //Survivor Geek
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = channelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(NSURL(string: urlArray[indexPath.row])! as URL)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
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
