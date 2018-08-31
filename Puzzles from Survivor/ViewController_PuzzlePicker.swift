//
//  ViewController_PuzzlePicker.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/30/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class ViewController_PuzzlePicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var labelSeason: UILabel!
    @IBOutlet weak var labelEpisode: UILabel!
    @IBOutlet weak var labelPuzzle: UILabel!
    @IBOutlet weak var textView_PuzzleDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.PuzzleSelected = 0
        appDelegate.puzzleArray = Constants.getPuzzleArray(season: appDelegate.SeasonSelected + 1, episode: appDelegate.EpisodeSelected + 1)
        
        labelSeason.text = "\(appDelegate.SeasonSelected + 1) - \(Constants.Seasons[appDelegate.SeasonSelected])"
        labelEpisode.text = Constants.Episodes[appDelegate.SeasonSelected][appDelegate.EpisodeSelected]
        labelPuzzle.text = appDelegate.puzzleArray[appDelegate.PuzzleSelected].Name
        
        textView_PuzzleDescription.text = appDelegate.puzzleArray[appDelegate.PuzzleSelected].Description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        appDelegate.puzzleArray = Constants.getPuzzleArray(season: appDelegate.SeasonSelected + 1, episode: appDelegate.EpisodeSelected + 1)
        return "\(appDelegate.puzzleArray[row].Name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.puzzleArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelSeason.text = "\(appDelegate.SeasonSelected + 1) - \(Constants.Seasons[appDelegate.SeasonSelected])"
        labelEpisode.text = Constants.Episodes[appDelegate.SeasonSelected][appDelegate.EpisodeSelected]
        labelPuzzle.text = appDelegate.puzzleArray[row].Name
        
        appDelegate.PuzzleSelected = row
        
        textView_PuzzleDescription.text = appDelegate.puzzleArray[appDelegate.PuzzleSelected].Description
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
