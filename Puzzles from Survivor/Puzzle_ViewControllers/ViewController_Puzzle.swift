//
//  ViewController_Puzzle.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/29/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class ViewController_Puzzle: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var code = appDelegate.WatchVideo
        if code == "" {
            code = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].VideoCode
        }
        getVideo(videoCode: code)
        
        if appDelegate.isLearn {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name + " - Learn"
        }else if appDelegate.isPractice {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name + " - Practice"
        }else {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getVideo(videoCode: String) {
        if videoCode == "" {
            webView.isHidden = true
            
            let alert = UIAlertController(title: "No Video", message: "This puzzle video has not yet been added to the app. If you are aware of the video being available somewhere on YouTube, please contact the app developer at rrtenz@gmail.com", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            webView.isHidden = false
            
            let urlString = "https://www.youtube.com/embed/\(videoCode)"
            let url = URL(string: urlString)
            webView.loadRequest(URLRequest(url: url!))
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
