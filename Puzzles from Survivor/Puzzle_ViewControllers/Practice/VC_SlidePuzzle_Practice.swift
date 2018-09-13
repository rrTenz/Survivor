//
//  VC_SlidePuzzle_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 8/31/18.
//  Copyright © 2018 Ryan Tensmeyer. All rights reserved.
//

import UIKit

class VC_SlidePuzzle_Practice: UIViewController {

    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var Label_YouWin: UILabel!
    
    var allImgViews: [UIImageView] = []
    var allCenters: [CGPoint] = []
    
    var gameViewWidth: CGFloat = 0.0
    var blockWidth: CGFloat = 0.0
    
    var timer = Timer()
    var timerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameViewWidth = self.gameView.frame.size.height
        self.blockWidth = gameViewWidth / 6
        
        var xCen = blockWidth / 2
        var yCen = blockWidth / 2
        
        allImgViews = []
        var index = 1
        for _ in 0..<4 {
            for _ in 0..<4 {
                let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth))
                
                let currentCenter = CGPoint(x: xCen, y: yCen)
                allCenters.append(currentCenter)
                myImageView.center = currentCenter
                
                if index < 10 {
                    myImageView.image = UIImage(named: "0\(index)")
                }else {
                    myImageView.image = UIImage(named: "\(index)")
                }
                index += 1
                allImgViews.append(myImageView)
                myImageView.isUserInteractionEnabled = true
                self.gameView.addSubview(myImageView)
                
                xCen += blockWidth
            }
            xCen = blockWidth / 2
            yCen += blockWidth
        }
        
        emptySpot = allCenters.last!
        allImgViews[15].removeFromSuperview()
        allImgViews.removeLast()
        
        ranodomizeBlocks()
    }
    
    var timerStarted = false
    @IBAction func Button_NewGame(_ sender: Any) {
        timerCount = 0
        timerLabel.text = "\(timerCount)"
        ranodomizeBlocks()
    }
    
    @IBOutlet weak var Button_Done_outlet: UIButton!
    @IBAction func Button_Done(_ sender: Any) {
        if timerStarted {
            timerStarted = false
            timer.invalidate()
            Button_Done_outlet.setTitle("Resume", for: .normal)
        }else {
            timerStarted = true
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
            Button_Done_outlet.setTitle("Done Jeff", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    var emptySpot = CGPoint(x: 0, y: 0)
    func ranodomizeBlocks() {
        
/*  This is not always a solvable puzzle
        var allCenters_copy = allCenters
        var randLocInt: Int
        var randLoc: CGPoint
        
        for any in allImgViews {
            randLocInt = Int(arc4random() % UInt32(allCenters_copy.count))
            randLoc = allCenters_copy[randLocInt]
            
            any.center = randLoc
            allCenters_copy.remove(at: randLocInt)
        }
        emptySpot = allCenters_copy[0]  //the last spot is the empty one
 */
        for _ in 0...1000 {
            let randIndex = Int(arc4random() % UInt32(allImgViews.count))
            let myTouch = allImgViews[randIndex]
            
            tapCenter = myTouch.center
            
            left = CGPoint(x: tapCenter.x - blockWidth, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + blockWidth, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + blockWidth)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - blockWidth)
            
            if Int(emptySpot.x) == Int(left.x) && Int(emptySpot.y) == Int(left.y) {
                leftIsEmpty = true
            }else if Int(emptySpot.x) == Int(right.x) && Int(emptySpot.y) == Int(right.y) {
                rightIsEmpty = true
            }else if Int(emptySpot.x) == Int(top.x) && Int(emptySpot.y) == Int(top.y) {
                topIsEmpty = true
            }else if Int(emptySpot.x) == Int(bottom.x) && Int(emptySpot.y) == Int(bottom.y) {
                bottomIsEmpty = true
            }
            
            if leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty {
                allImgViews[randIndex].center = emptySpot
                emptySpot = tapCenter
                leftIsEmpty = false
                rightIsEmpty = false
                topIsEmpty = false
                bottomIsEmpty = false
            }
        }
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
        Label_YouWin.isHidden = true
        timerStarted = true
    }
    
    @objc func inrementTimer() {
        timerCount += 1
        timerLabel.text = "\(timerCount)"
    }
    
    var tapCenter = CGPoint(x: 0, y: 0)
    var left = CGPoint(x: 0, y: 0)
    var right = CGPoint(x: 0, y: 0)
    var top = CGPoint(x: 0, y: 0)
    var bottom = CGPoint(x: 0, y: 0)
    var leftIsEmpty = false
    var rightIsEmpty = false
    var topIsEmpty = false
    var bottomIsEmpty = false
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch = touches.first
        
        if myTouch?.view != self.view {
            tapCenter = (myTouch?.view?.center)!
            
            left = CGPoint(x: tapCenter.x - blockWidth, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + blockWidth, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + blockWidth)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - blockWidth)
            
            if Int(emptySpot.x) == Int(left.x) && Int(emptySpot.y) == Int(left.y) {
                leftIsEmpty = true
            }else if Int(emptySpot.x) == Int(right.x) && Int(emptySpot.y) == Int(right.y) {
                rightIsEmpty = true
            }else if Int(emptySpot.x) == Int(top.x) && Int(emptySpot.y) == Int(top.y) {
                topIsEmpty = true
            }else if Int(emptySpot.x) == Int(bottom.x) && Int(emptySpot.y) == Int(bottom.y) {
                bottomIsEmpty = true
            }
            
            if leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty {
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.5)
                myTouch?.view?.center = emptySpot
                UIView.commitAnimations()
                emptySpot = tapCenter
                leftIsEmpty = false
                rightIsEmpty = false
                topIsEmpty = false
                bottomIsEmpty = false
            }
        }
    }

}
