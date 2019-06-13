//
//  ViewController_Puzzle.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 5/29/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ViewController_Puzzle: UIViewController, WKYTPlayerViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var playerView: WKYTPlayerView!
    @IBOutlet weak var labelTitle: UILabel!
    var timer = Timer()
    let TIMER_INCREMENT = 1.0
    var timeInSeconds = -1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerView.delegate = self
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIMER_INCREMENT, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)

        appDelegate.lastPuzzle_index = appDelegate.PuzzleSelected
        Defaults().save_Defaults(updateStreak: false)
        
        var code = appDelegate.WatchVideo
        if code == "" {
            code = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].VideoCode
        }
        getVideo(videoCode: code)
        Slider.value = 0.0
        
        if appDelegate.isLearn {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name + " - Learn"
        }else if appDelegate.isPractice {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name + " - Practice"
        }else {
            labelTitle.text = appDelegate.puzzleArraySimple[appDelegate.PuzzleSelected].Name
        }
    }
    
    var lastState: WKYTPlayerState = .unknown
    @IBAction func overlay_button(_ sender: Any) {
        toggle_Play_Pause()
    }
    
    func toggle_Play_Pause() {
        self.playerView.getPlayerState { (state, error) in
            print(state)
            if state == .paused || state == .queued {
                self.playerView.playVideo()
                self.playerView.isHidden = false
                
                self.playerView.getDuration { (timeInverval, error) in
                    print(timeInverval)
                    self.timeInSeconds = timeInverval
                }
            }else if state == .playing {
                self.playerView.pauseVideo()
            }
            print("  \(state)")
            self.lastState = state
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        print(state)
        switch state {
        case .ended:
            playerView.isHidden = true
            textView.text = "Video complete\n\nThe video has finished playing"
        case .playing:
            playerView.isHidden = false
        default:
            print("default")
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
    
    @IBOutlet weak var Slider: UISlider!
    var isAdjustingSlider = false
    @IBAction func Slide_change(_ sender: UISlider) {
        print("change")
        isAdjustingSlider = true
    }
    @IBAction func Slide_up_inside(_ sender: UISlider) {
        print("inside")
        if self.timeInSeconds > 0 {
            self.playerView.seek(toSeconds: self.Slider.value * Float(self.timeInSeconds), allowSeekAhead: true)
        }
        isAdjustingSlider = false
    }
    @IBAction func Slide_up_outside(_ sender: UISlider) {
        print("outside")
        if self.timeInSeconds > 0 {
            self.playerView.seek(toSeconds: self.Slider.value * Float(self.timeInSeconds), allowSeekAhead: true)
        }
        isAdjustingSlider = false
    }
    
    @objc func timerFunc() {
        self.playerView.getCurrentTime { (currentTime, error) in
            self.playerView.getPlayerState { (state, error) in
                self.lastState = state
            }
            if !self.isAdjustingSlider && self.lastState == .playing && self.timeInSeconds > 0 {
                self.Slider.value = Float(currentTime / Float(self.timeInSeconds))
            }
        }
    }
    
    func getVideo(videoCode: String) {
        if videoCode == "" {
            playerView.isHidden = true
            
            let alert = UIAlertController(title: "No Video", message: "This puzzle video has not yet been added to the app. If you are aware of the video being available somewhere on YouTube, please contact the app developer at rrtenz@gmail.com", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            playerView.isHidden = false
            
            playerView.load(withVideoId: videoCode)
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
