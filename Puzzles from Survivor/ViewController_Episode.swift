//
//  ViewController_Episode.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/22/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class ViewController_Episode: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var label_Season: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var buttonGo_outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = Constants.getPuzzleCount(season: appDelegate.SeasonSelected + 1, episode: 0 + 1)
        label_Season.text = "\(appDelegate.SeasonSelected + 1) - \(Constants.Seasons[appDelegate.SeasonSelected])"
        
        label.text = Constants.Episodes[appDelegate.SeasonSelected][0]
        appDelegate.EpisodeSelected = 0
        buttonGo_outlet.isEnabled = count != 0

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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Constants.Episodes[appDelegate.SeasonSelected][row])  (\(Constants.getPuzzleCount(season: appDelegate.SeasonSelected + 1, episode: row + 1)))"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Episodes[appDelegate.SeasonSelected].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let count = Constants.getPuzzleCount(season: appDelegate.SeasonSelected + 1, episode: row + 1)
        buttonGo_outlet.isEnabled = count != 0
        
        label_Season.text = "\(appDelegate.SeasonSelected + 1) - \(Constants.Seasons[appDelegate.SeasonSelected])"
        label.text = Constants.Episodes[appDelegate.SeasonSelected][row]
        appDelegate.EpisodeSelected = row
    }
    
    

}
