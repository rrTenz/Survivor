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

    @IBOutlet weak var labelPuzzle: UILabel!
    @IBOutlet weak var textView_PuzzleDescription: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.PuzzleSelected = 0
        appDelegate.puzzleArraySimple = Constants.PuzzleArraySimple
        
        labelPuzzle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        textView_PuzzleDescription.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Description
        image.image = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appDelegate.WatchVideo = ""
        appDelegate.isLearn = false
        appDelegate.isPractice = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(appDelegate.puzzleArraySimple[row].Name)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.puzzleArraySimple.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        appDelegate.PuzzleSelected = row
        labelPuzzle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        textView_PuzzleDescription.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Description
        image.image = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Image
    }
    
    @IBAction func Button_Learn(_ sender: Any) {
        appDelegate.isLearn = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name {
        case "Slide Puzzle", "Five Piece Puzzle", "Sea Crates", "Tower of Hanoi", "21 Flags":
            appDelegate.WatchVideo = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].VideoCode_Learn
            let controller = storyboard.instantiateViewController(withIdentifier: "ViewController_Puzzle")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController_Puzzle") as? ViewController_Puzzle {
                present(vc, animated: true, completion: nil)
            }
        default:
            print("!!!!!! oops !!!!!!")
        }
    }
    
    @IBAction func Button_Practice(_ sender: Any) {
        appDelegate.isPractice = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name {
        case "Slide Puzzle":
            UIApplication.shared.openURL(NSURL(string: "https://www.proprofs.com/games/puzzle/sliding/survivor-cagayan-sliding-puzzle/")! as URL)
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
            UIApplication.shared.openURL(NSURL(string: "https://www.mathsisfun.com/games/towerofhanoi.html")! as URL)
        case "21 Flags":
            let controller = storyboard.instantiateViewController(withIdentifier: "VC_21Flags_Practice")
            self.present(controller, animated: true, completion: nil)
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC_21Flags_Practice") as? VC_21Flags_Practice {
                present(vc, animated: true, completion: nil)
            }
        default:
            print("!!!!!! oops !!!!!!")
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
