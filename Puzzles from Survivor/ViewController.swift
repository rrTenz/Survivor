//
//  ViewController.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/22/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var buttonGo_outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let count = Constants.getPuzzleCount(season: 0 + 1)
        label.text = "1 - \(Constants.Seasons[0])"
        appDelegate.SeasonSelected = 0
        buttonGo_outlet.isEnabled = count != 0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) - \(Constants.Seasons[row]) (\(Constants.getPuzzleCount(season: row + 1)))"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Seasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let count = Constants.getPuzzleCount(season: row + 1)
        buttonGo_outlet.isEnabled = count != 0
        
        label.text = "\(row + 1) - \(Constants.Seasons[row])"
        appDelegate.SeasonSelected = row
    }


}

