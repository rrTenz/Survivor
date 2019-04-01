//
//  VC_FlipOut_Practice.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 1/14/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import UIKit

struct Tile {
    var button: UIButton?
    var buttonIndex: Int
    var neighbors: [Int]
    var flipped: Bool = false
}

class VC_FlipOut_Practice: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var BackgroundRing: UIView!
    
    var TileArray: [Tile] = []
    
    var playerLoc = [0, 1, 2, 3, 4, 5]
    var nameArray = ["White", "Red", "Blue", "Orange", "Green", "Yellow"]
    var canPlay = [true, true, true, true, true, true]
    var isComputer = [false, true, true, true, true, true]
    var turnCount = [0, 0, 0, 0, 0, 0]
    var playersLeft = 6
    var whosTurn = 0
    var bestMove = -1
    var lastPlayerToMove = -1
    
    var timer = Timer()
    let TIME_INTERVAL = 0.75

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NewGame()
    }
    
    @IBOutlet weak var Label_YouWin: UILabel!
    
    @IBOutlet weak var NewGame_outlet: UIButton!
    @IBAction func Button_NewGame(_ sender: Any) {
        NewGame()
    }
    
    @objc func inrementTimer() {
        if isComputer[whosTurn] {
            if bestMove == -1 {
                bestMove = findBestMove()
            }
            tilePressed(buttonNum: bestMove)
        }
        
        if isComputer[whosTurn] == false {
            for tile in TileArray {
                var adjustTileAlpha = false
                if playerLoc[0] == tile.buttonIndex && whosTurn == 0 {
                    if playerLoc[0] == 0 {
                        if WhiteStart.alpha == 1 {
                            WhiteStart.alpha = 0.5
                        }else {
                            WhiteStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }else if playerLoc[1] == tile.buttonIndex && whosTurn == 1  {
                    if playerLoc[1] == 1 {
                        if RedStart.alpha == 1 {
                            RedStart.alpha = 0.5
                        }else {
                            RedStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }else if playerLoc[2] == tile.buttonIndex && whosTurn == 2  {
                    if playerLoc[2] == 2 {
                        if BlueStart.alpha == 1 {
                            BlueStart.alpha = 0.5
                        }else {
                            BlueStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }else if playerLoc[3] == tile.buttonIndex && whosTurn == 3  {
                    if playerLoc[3] == 3 {
                        if OrangeStart.alpha == 1 {
                            OrangeStart.alpha = 0.5
                        }else {
                            OrangeStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }else if playerLoc[4] == tile.buttonIndex && whosTurn == 4  {
                    if playerLoc[4] == 4 {
                        if GreenStart.alpha == 1 {
                            GreenStart.alpha = 0.5
                        }else {
                            GreenStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }else if playerLoc[5] == tile.buttonIndex && whosTurn == 5  {
                    if playerLoc[5] == 5 {
                        if YellowStart.alpha == 1 {
                            YellowStart.alpha = 0.5
                        }else {
                            YellowStart.alpha = 1
                        }
                    }else {
                        adjustTileAlpha = true
                    }
                }
                
                if adjustTileAlpha {
                    if tile.button?.alpha == 1 {
                        tile.button?.alpha = 0.5
                    }else {
                        tile.button?.alpha = 1
                    }
                }
            }
        }
    }
    
    @IBAction func Button_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func NewGame() {
        
        TileArray.removeAll()
        TileArray.append(Tile(button: nil, buttonIndex: 0, neighbors: [21, 32], flipped: true))
        TileArray.append(Tile(button: nil, buttonIndex: 1, neighbors: [101, 113], flipped: true))
        TileArray.append(Tile(button: nil, buttonIndex: 2, neighbors: [6, 7], flipped: true))
        TileArray.append(Tile(button: nil, buttonIndex: 3, neighbors: [137, 138], flipped: true))
        TileArray.append(Tile(button: nil, buttonIndex: 4, neighbors: [31, 43], flipped: true))
        TileArray.append(Tile(button: nil, buttonIndex: 5, neighbors: [112, 123], flipped: true))
        TileArray.append(Tile(button: o6, buttonIndex: 6, neighbors: [9, 10, 7], flipped: false))
        TileArray.append(Tile(button: o7, buttonIndex: 7, neighbors: [6, 10, 11], flipped: false))
        TileArray.append(Tile(button: o8, buttonIndex: 8, neighbors: [14, 15, 9], flipped: false))
        TileArray.append(Tile(button: o9, buttonIndex: 9, neighbors: [8, 15, 16, 10, 6], flipped: false))
        TileArray.append(Tile(button: o10, buttonIndex: 10, neighbors: [6, 7, 9, 16, 17, 11], flipped: false))
        TileArray.append(Tile(button: o11, buttonIndex: 11, neighbors: [7, 10, 17, 18, 12], flipped: false))
        TileArray.append(Tile(button: o12, buttonIndex: 12, neighbors: [11, 18, 19], flipped: false))
        TileArray.append(Tile(button: o13, buttonIndex: 13, neighbors: [22, 23, 14], flipped: false))
        TileArray.append(Tile(button: o14, buttonIndex: 14, neighbors: [13, 23, 24, 15, 8], flipped: false))
        TileArray.append(Tile(button: o15, buttonIndex: 15, neighbors: [8, 9, 14, 16, 24, 25], flipped: false))
        TileArray.append(Tile(button: o16, buttonIndex: 16, neighbors: [9, 10, 15, 17, 25, 26], flipped: false))
        TileArray.append(Tile(button: o17, buttonIndex: 17, neighbors: [10, 11, 16, 18, 26, 27], flipped: false))
        TileArray.append(Tile(button: o18, buttonIndex: 18, neighbors: [11, 12, 17, 19, 27, 28], flipped: false))
        TileArray.append(Tile(button: o19, buttonIndex: 19, neighbors: [12, 18, 20, 28, 29], flipped: false))
        TileArray.append(Tile(button: o20, buttonIndex: 20, neighbors: [19, 29, 30], flipped: false))
        TileArray.append(Tile(button: o21, buttonIndex: 21, neighbors: [22, 32, 33], flipped: false))
        TileArray.append(Tile(button: o22, buttonIndex: 22, neighbors: [13, 21, 23, 33, 34], flipped: false))
        TileArray.append(Tile(button: o23, buttonIndex: 23, neighbors: [13, 14, 22, 24, 34, 35], flipped: false))
        TileArray.append(Tile(button: o24, buttonIndex: 24, neighbors: [14, 15, 23, 25, 35, 36], flipped: false))
        TileArray.append(Tile(button: o25, buttonIndex: 25, neighbors: [15, 16, 24, 26, 36, 37], flipped: false))
        TileArray.append(Tile(button: o26, buttonIndex: 26, neighbors: [16, 17, 25, 27, 37, 38], flipped: false))
        TileArray.append(Tile(button: o27, buttonIndex: 27, neighbors: [17, 18, 26, 28, 38, 39], flipped: false))
        TileArray.append(Tile(button: o28, buttonIndex: 28, neighbors: [18, 19, 27, 29, 39, 40], flipped: false))
        TileArray.append(Tile(button: o29, buttonIndex: 29, neighbors: [19, 20, 28, 30, 40, 41], flipped: false))
        TileArray.append(Tile(button: o30, buttonIndex: 30, neighbors: [20, 29, 31, 41, 42], flipped: false))
        TileArray.append(Tile(button: o31, buttonIndex: 31, neighbors: [30, 42, 43], flipped: false))
        TileArray.append(Tile(button: o32, buttonIndex: 32, neighbors: [21, 33, 44], flipped: false))
        TileArray.append(Tile(button: o33, buttonIndex: 33, neighbors: [21, 22, 32, 34, 44, 45], flipped: false))
        TileArray.append(Tile(button: o34, buttonIndex: 34, neighbors: [22, 23, 33, 35, 45, 46], flipped: false))
        TileArray.append(Tile(button: o35, buttonIndex: 35, neighbors: [23, 24, 34, 36, 46, 47], flipped: false))
        TileArray.append(Tile(button: o36, buttonIndex: 36, neighbors: [24, 25, 35, 37, 47, 48], flipped: false))
        TileArray.append(Tile(button: o37, buttonIndex: 37, neighbors: [25, 26, 36, 38, 48, 49], flipped: false))
        TileArray.append(Tile(button: o38, buttonIndex: 38, neighbors: [26, 27, 37, 39, 49, 50], flipped: false))
        TileArray.append(Tile(button: o39, buttonIndex: 39, neighbors: [27, 28, 38, 40, 50, 51], flipped: false))
        TileArray.append(Tile(button: o40, buttonIndex: 40, neighbors: [28, 29, 39, 41, 51, 52], flipped: false))
        TileArray.append(Tile(button: o41, buttonIndex: 41, neighbors: [29, 30, 40, 42, 52, 53], flipped: false))
        TileArray.append(Tile(button: o42, buttonIndex: 42, neighbors: [30, 31, 41, 43, 53, 54], flipped: false))
        TileArray.append(Tile(button: o43, buttonIndex: 43, neighbors: [31, 42, 54], flipped: false))
        TileArray.append(Tile(button: o44, buttonIndex: 44, neighbors: [32, 33, 45, 55, 56], flipped: false))
        TileArray.append(Tile(button: o45, buttonIndex: 45, neighbors: [33, 34, 44, 46, 56, 57], flipped: false))
        TileArray.append(Tile(button: o46, buttonIndex: 46, neighbors: [34, 35, 45, 47, 57, 58], flipped: false))
        TileArray.append(Tile(button: o47, buttonIndex: 47, neighbors: [35, 36, 46, 48, 58, 59], flipped: false))
        TileArray.append(Tile(button: o48, buttonIndex: 48, neighbors: [36, 37, 47, 49, 59, 60], flipped: false))
        TileArray.append(Tile(button: o49, buttonIndex: 49, neighbors: [37, 38, 48, 50, 60, 61], flipped: false))
        TileArray.append(Tile(button: o50, buttonIndex: 50, neighbors: [38, 39, 49, 51, 61, 62], flipped: false))
        TileArray.append(Tile(button: o51, buttonIndex: 51, neighbors: [39, 40, 50, 52, 62, 63], flipped: false))
        TileArray.append(Tile(button: o52, buttonIndex: 52, neighbors: [40, 41, 51, 53, 63, 64], flipped: false))
        TileArray.append(Tile(button: o53, buttonIndex: 53, neighbors: [41, 42, 52, 54, 64, 65], flipped: false))
        TileArray.append(Tile(button: o54, buttonIndex: 54, neighbors: [42, 43, 53, 65, 66], flipped: false))
        TileArray.append(Tile(button: o55, buttonIndex: 55, neighbors: [44, 56, 67], flipped: false))
        TileArray.append(Tile(button: o56, buttonIndex: 56, neighbors: [44, 45, 55, 57, 67, 68], flipped: false))
        TileArray.append(Tile(button: o57, buttonIndex: 57, neighbors: [45, 46, 56, 58, 68, 69], flipped: false))
        TileArray.append(Tile(button: o58, buttonIndex: 58, neighbors: [46, 47, 57, 59, 69, 70], flipped: false))
        TileArray.append(Tile(button: o59, buttonIndex: 59, neighbors: [47, 48, 58, 60, 70, 71], flipped: false))
        TileArray.append(Tile(button: o60, buttonIndex: 60, neighbors: [48, 49, 59, 61, 71, 72], flipped: false))
        TileArray.append(Tile(button: o61, buttonIndex: 61, neighbors: [49, 50, 60, 62, 72, 73], flipped: false))
        TileArray.append(Tile(button: o62, buttonIndex: 62, neighbors: [50, 51, 61, 63, 73, 74], flipped: false))
        TileArray.append(Tile(button: o63, buttonIndex: 63, neighbors: [51, 52, 62, 64, 74, 75], flipped: false))
        TileArray.append(Tile(button: o64, buttonIndex: 64, neighbors: [52, 53, 63, 65, 75, 76], flipped: false))
        TileArray.append(Tile(button: o65, buttonIndex: 65, neighbors: [53, 54, 64, 66, 76, 77], flipped: false))
        TileArray.append(Tile(button: o66, buttonIndex: 66, neighbors: [54, 65, 77], flipped: false))
        TileArray.append(Tile(button: o67, buttonIndex: 67, neighbors: [55, 56, 68, 78, 79], flipped: false))
        TileArray.append(Tile(button: o68, buttonIndex: 68, neighbors: [56, 57, 67, 69, 79, 80], flipped: false))
        TileArray.append(Tile(button: o69, buttonIndex: 69, neighbors: [57, 58, 68, 70, 80, 81], flipped: false))
        TileArray.append(Tile(button: o70, buttonIndex: 70, neighbors: [58, 59, 69, 71, 81, 82], flipped: false))
        TileArray.append(Tile(button: o71, buttonIndex: 71, neighbors: [59, 60, 70, 72, 82, 83], flipped: false))
        TileArray.append(Tile(button: o72, buttonIndex: 72, neighbors: [60, 61, 71, 73, 83, 84], flipped: false))
        TileArray.append(Tile(button: o73, buttonIndex: 73, neighbors: [61, 62, 72, 74, 84, 85], flipped: false))
        TileArray.append(Tile(button: o74, buttonIndex: 74, neighbors: [62, 63, 73, 75, 85, 86], flipped: false))
        TileArray.append(Tile(button: o75, buttonIndex: 75, neighbors: [63, 64, 74, 76, 86, 87], flipped: false))
        TileArray.append(Tile(button: o76, buttonIndex: 76, neighbors: [64, 65, 75, 77, 87, 88], flipped: false))
        TileArray.append(Tile(button: o77, buttonIndex: 77, neighbors: [65, 66, 76, 88, 89], flipped: false))
        TileArray.append(Tile(button: o78, buttonIndex: 78, neighbors: [67, 79, 90], flipped: false))
        TileArray.append(Tile(button: o79, buttonIndex: 79, neighbors: [67, 68, 78, 80, 90, 91], flipped: false))
        TileArray.append(Tile(button: o80, buttonIndex: 80, neighbors: [68, 69, 79, 81, 91, 92], flipped: false))
        TileArray.append(Tile(button: o81, buttonIndex: 81, neighbors: [69, 70, 80, 82, 92, 93], flipped: false))
        TileArray.append(Tile(button: o82, buttonIndex: 82, neighbors: [70, 71, 81, 83, 93, 94], flipped: false))
        TileArray.append(Tile(button: o83, buttonIndex: 83, neighbors: [71, 72, 82, 84, 94, 95], flipped: false))
        TileArray.append(Tile(button: o84, buttonIndex: 84, neighbors: [72, 73, 83, 85, 95, 96], flipped: false))
        TileArray.append(Tile(button: o85, buttonIndex: 85, neighbors: [73, 74, 84, 86, 96, 97], flipped: false))
        TileArray.append(Tile(button: o86, buttonIndex: 86, neighbors: [74, 75, 85, 87, 97, 98], flipped: false))
        TileArray.append(Tile(button: o87, buttonIndex: 87, neighbors: [75, 76, 86, 88, 98, 99], flipped: false))
        TileArray.append(Tile(button: o88, buttonIndex: 88, neighbors: [76, 77, 87, 89, 99, 100], flipped: false))
        TileArray.append(Tile(button: o89, buttonIndex: 89, neighbors: [77, 88, 100], flipped: false))
        TileArray.append(Tile(button: o90, buttonIndex: 90, neighbors: [78, 79, 91, 101, 102], flipped: false))
        TileArray.append(Tile(button: o91, buttonIndex: 91, neighbors: [79, 80, 90, 92, 102, 103], flipped: false))
        TileArray.append(Tile(button: o92, buttonIndex: 92, neighbors: [80, 81, 91, 93, 103, 104], flipped: false))
        TileArray.append(Tile(button: o93, buttonIndex: 93, neighbors: [81, 82, 92, 94, 104, 105], flipped: false))
        TileArray.append(Tile(button: o94, buttonIndex: 94, neighbors: [82, 83, 93, 95, 105, 106], flipped: false))
        TileArray.append(Tile(button: o95, buttonIndex: 95, neighbors: [83, 84, 94, 96, 106, 107], flipped: false))
        TileArray.append(Tile(button: o96, buttonIndex: 96, neighbors: [84, 85, 95, 97, 107, 108], flipped: false))
        TileArray.append(Tile(button: o97, buttonIndex: 97, neighbors: [85, 86, 96, 98, 108, 109], flipped: false))
        TileArray.append(Tile(button: o98, buttonIndex: 98, neighbors: [86, 87, 97, 99, 109, 110], flipped: false))
        TileArray.append(Tile(button: o99, buttonIndex: 99, neighbors: [87, 88, 98, 100, 110, 111], flipped: false))
        TileArray.append(Tile(button: o100, buttonIndex: 100, neighbors: [88, 89, 99, 111, 112], flipped: false))
        TileArray.append(Tile(button: o101, buttonIndex: 101, neighbors: [90, 102, 113], flipped: false))
        TileArray.append(Tile(button: o102, buttonIndex: 102, neighbors: [90, 91, 101, 103, 113, 114], flipped: false))
        TileArray.append(Tile(button: o103, buttonIndex: 103, neighbors: [91, 92, 102, 104, 114, 115], flipped: false))
        TileArray.append(Tile(button: o104, buttonIndex: 104, neighbors: [92, 93, 103, 105, 115, 116], flipped: false))
        TileArray.append(Tile(button: o105, buttonIndex: 105, neighbors: [93, 94, 104, 106, 116, 117], flipped: false))
        TileArray.append(Tile(button: o106, buttonIndex: 106, neighbors: [94, 95, 105, 107, 117, 118], flipped: false))
        TileArray.append(Tile(button: o107, buttonIndex: 107, neighbors: [95, 96, 106, 108, 118, 119], flipped: false))
        TileArray.append(Tile(button: o108, buttonIndex: 108, neighbors: [96, 97, 107, 109, 119, 120], flipped: false))
        TileArray.append(Tile(button: o109, buttonIndex: 109, neighbors: [97, 98, 108, 110, 120, 121], flipped: false))
        TileArray.append(Tile(button: o110, buttonIndex: 110, neighbors: [98, 99, 109, 111, 121, 122], flipped: false))
        TileArray.append(Tile(button: o111, buttonIndex: 111, neighbors: [99, 100, 110, 112, 122, 123], flipped: false))
        TileArray.append(Tile(button: o112, buttonIndex: 112, neighbors: [100, 111, 123], flipped: false))
        TileArray.append(Tile(button: o113, buttonIndex: 113, neighbors: [101, 102, 114], flipped: false))
        TileArray.append(Tile(button: o114, buttonIndex: 114, neighbors: [102, 103, 113, 115, 124], flipped: false))
        TileArray.append(Tile(button: o115, buttonIndex: 115, neighbors: [103, 104, 114, 116, 124, 125], flipped: false))
        TileArray.append(Tile(button: o116, buttonIndex: 116, neighbors: [104, 105, 115, 117, 125, 126], flipped: false))
        TileArray.append(Tile(button: o117, buttonIndex: 117, neighbors: [105, 106, 116, 118, 126, 127], flipped: false))
        TileArray.append(Tile(button: o118, buttonIndex: 118, neighbors: [106, 107, 117, 119, 127, 128], flipped: false))
        TileArray.append(Tile(button: o119, buttonIndex: 119, neighbors: [107, 108, 118, 120, 128, 129], flipped: false))
        TileArray.append(Tile(button: o120, buttonIndex: 120, neighbors: [108, 109, 119, 121, 129, 130], flipped: false))
        TileArray.append(Tile(button: o121, buttonIndex: 121, neighbors: [109, 110, 120, 122, 130, 131], flipped: false))
        TileArray.append(Tile(button: o122, buttonIndex: 122, neighbors: [110, 111, 121, 123, 131], flipped: false))
        TileArray.append(Tile(button: o123, buttonIndex: 123, neighbors: [111, 112, 122], flipped: false))
        TileArray.append(Tile(button: o124, buttonIndex: 124, neighbors: [114, 115, 125], flipped: false))
        TileArray.append(Tile(button: o125, buttonIndex: 125, neighbors: [115, 116, 124, 126, 132], flipped: false))
        TileArray.append(Tile(button: o126, buttonIndex: 126, neighbors: [116, 117, 125, 127, 132, 133], flipped: false))
        TileArray.append(Tile(button: o127, buttonIndex: 127, neighbors: [117, 118, 126, 128, 133, 134], flipped: false))
        TileArray.append(Tile(button: o128, buttonIndex: 128, neighbors: [118, 119, 127, 129, 134, 135], flipped: false))
        TileArray.append(Tile(button: o129, buttonIndex: 129, neighbors: [119, 120, 128, 130, 135, 136], flipped: false))
        TileArray.append(Tile(button: o130, buttonIndex: 130, neighbors: [120, 121, 129, 131, 136], flipped: false))
        TileArray.append(Tile(button: o131, buttonIndex: 131, neighbors: [121, 122, 130], flipped: false))
        TileArray.append(Tile(button: o132, buttonIndex: 132, neighbors: [125, 126, 133], flipped: false))
        TileArray.append(Tile(button: o133, buttonIndex: 133, neighbors: [126, 127, 132, 134, 137], flipped: false))
        TileArray.append(Tile(button: o134, buttonIndex: 134, neighbors: [127, 128, 133, 135, 137, 138], flipped: false))
        TileArray.append(Tile(button: o135, buttonIndex: 135, neighbors: [128, 129, 134, 136, 138], flipped: false))
        TileArray.append(Tile(button: o136, buttonIndex: 136, neighbors: [129, 130, 135], flipped: false))
        TileArray.append(Tile(button: o137, buttonIndex: 137, neighbors: [133, 134, 138], flipped: false))
        TileArray.append(Tile(button: o138, buttonIndex: 138, neighbors: [134, 135, 137], flipped: false))
        
        playerLoc = [0, 1, 2, 3, 4, 5]
        canPlay = [true, true, true, true, true, true]
        playersLeft = 6
        whosTurn = 0
        lastPlayerToMove = -1
        turnCount = [0, 0, 0, 0, 0, 0]
        
        NewGame_outlet.setTitle("Restart", for: .normal)
        UpdateUi()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL, target: self, selector: #selector(inrementTimer), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var Button_Done_outlet: UIButton!
    @IBAction func Button_Done(_ sender: Any) {
    }
    
    @IBOutlet weak var BlueStart: UIImageView!
    @IBOutlet weak var WhiteStart: UIImageView!
    @IBOutlet weak var RedStart: UIImageView!
    @IBOutlet weak var YellowStart: UIImageView!
    @IBOutlet weak var OrangeStart: UIImageView!
    @IBOutlet weak var GreenStart: UIImageView!
    
    
    @IBOutlet weak var o7: UIButton!
    @IBOutlet weak var o6: UIButton!
    
    @IBOutlet weak var o11: UIButton!
    @IBOutlet weak var o12: UIButton!
    @IBOutlet weak var o10: UIButton!
    @IBOutlet weak var o9: UIButton!
    @IBOutlet weak var o8: UIButton!
    
    @IBOutlet weak var o17: UIButton!
    @IBOutlet weak var o18: UIButton!
    @IBOutlet weak var o19: UIButton!
    @IBOutlet weak var o20: UIButton!
    @IBOutlet weak var o16: UIButton!
    @IBOutlet weak var o15: UIButton!
    @IBOutlet weak var o14: UIButton!
    @IBOutlet weak var o13: UIButton!
    
    @IBOutlet weak var o27: UIButton!
    @IBOutlet weak var o28: UIButton!
    @IBOutlet weak var o29: UIButton!
    @IBOutlet weak var o30: UIButton!
    @IBOutlet weak var o31: UIButton!
    @IBOutlet weak var o26: UIButton!
    @IBOutlet weak var o25: UIButton!
    @IBOutlet weak var o24: UIButton!
    @IBOutlet weak var o23: UIButton!
    @IBOutlet weak var o22: UIButton!
    @IBOutlet weak var o21: UIButton!
    
    @IBOutlet weak var o38: UIButton!
    @IBOutlet weak var o39: UIButton!
    @IBOutlet weak var o40: UIButton!
    @IBOutlet weak var o41: UIButton!
    @IBOutlet weak var o42: UIButton!
    @IBOutlet weak var o43: UIButton!
    @IBOutlet weak var o37: UIButton!
    @IBOutlet weak var o36: UIButton!
    @IBOutlet weak var o35: UIButton!
    @IBOutlet weak var o34: UIButton!
    @IBOutlet weak var o33: UIButton!
    @IBOutlet weak var o32: UIButton!
    
    @IBOutlet weak var o50: UIButton!
    @IBOutlet weak var o51: UIButton!
    @IBOutlet weak var o52: UIButton!
    @IBOutlet weak var o53: UIButton!
    @IBOutlet weak var o54: UIButton!
    @IBOutlet weak var o49: UIButton!
    @IBOutlet weak var o48: UIButton!
    @IBOutlet weak var o47: UIButton!
    @IBOutlet weak var o46: UIButton!
    @IBOutlet weak var o45: UIButton!
    @IBOutlet weak var o44: UIButton!
    
    @IBOutlet weak var o61: UIButton!
    @IBOutlet weak var o62: UIButton!
    @IBOutlet weak var o63: UIButton!
    @IBOutlet weak var o64: UIButton!
    @IBOutlet weak var o65: UIButton!
    @IBOutlet weak var o66: UIButton!
    @IBOutlet weak var o60: UIButton!
    @IBOutlet weak var o59: UIButton!
    @IBOutlet weak var o58: UIButton!
    @IBOutlet weak var o57: UIButton!
    @IBOutlet weak var o56: UIButton!
    @IBOutlet weak var o55: UIButton!
    
    @IBOutlet weak var o73: UIButton!
    @IBOutlet weak var o74: UIButton!
    @IBOutlet weak var o75: UIButton!
    @IBOutlet weak var o76: UIButton!
    @IBOutlet weak var o77: UIButton!
    @IBOutlet weak var o72: UIButton!
    @IBOutlet weak var o71: UIButton!
    @IBOutlet weak var o70: UIButton!
    @IBOutlet weak var o69: UIButton!
    @IBOutlet weak var o68: UIButton!
    @IBOutlet weak var o67: UIButton!
    
    @IBOutlet weak var o84: UIButton!
    @IBOutlet weak var o85: UIButton!
    @IBOutlet weak var o86: UIButton!
    @IBOutlet weak var o87: UIButton!
    @IBOutlet weak var o88: UIButton!
    @IBOutlet weak var o89: UIButton!
    @IBOutlet weak var o83: UIButton!
    @IBOutlet weak var o82: UIButton!
    @IBOutlet weak var o81: UIButton!
    @IBOutlet weak var o80: UIButton!
    @IBOutlet weak var o79: UIButton!
    @IBOutlet weak var o78: UIButton!
    
    @IBOutlet weak var o96: UIButton!
    @IBOutlet weak var o97: UIButton!
    @IBOutlet weak var o98: UIButton!
    @IBOutlet weak var o99: UIButton!
    @IBOutlet weak var o100: UIButton!
    @IBOutlet weak var o95: UIButton!
    @IBOutlet weak var o94: UIButton!
    @IBOutlet weak var o93: UIButton!
    @IBOutlet weak var o92: UIButton!
    @IBOutlet weak var o91: UIButton!
    @IBOutlet weak var o90: UIButton!
    
    @IBOutlet weak var o107: UIButton!
    @IBOutlet weak var o108: UIButton!
    @IBOutlet weak var o109: UIButton!
    @IBOutlet weak var o110: UIButton!
    @IBOutlet weak var o111: UIButton!
    @IBOutlet weak var o112: UIButton!
    @IBOutlet weak var o106: UIButton!
    @IBOutlet weak var o105: UIButton!
    @IBOutlet weak var o104: UIButton!
    @IBOutlet weak var o103: UIButton!
    @IBOutlet weak var o102: UIButton!
    @IBOutlet weak var o101: UIButton!
    
    @IBOutlet weak var o119: UIButton!
    @IBOutlet weak var o120: UIButton!
    @IBOutlet weak var o121: UIButton!
    @IBOutlet weak var o122: UIButton!
    @IBOutlet weak var o123: UIButton!
    @IBOutlet weak var o118: UIButton!
    @IBOutlet weak var o117: UIButton!
    @IBOutlet weak var o116: UIButton!
    @IBOutlet weak var o115: UIButton!
    @IBOutlet weak var o114: UIButton!
    @IBOutlet weak var o113: UIButton!
    
    @IBOutlet weak var o128: UIButton!
    @IBOutlet weak var o129: UIButton!
    @IBOutlet weak var o130: UIButton!
    @IBOutlet weak var o131: UIButton!
    @IBOutlet weak var o127: UIButton!
    @IBOutlet weak var o126: UIButton!
    @IBOutlet weak var o125: UIButton!
    @IBOutlet weak var o124: UIButton!
    
    @IBOutlet weak var o135: UIButton!
    @IBOutlet weak var o136: UIButton!
    @IBOutlet weak var o134: UIButton!
    @IBOutlet weak var o133: UIButton!
    @IBOutlet weak var o132: UIButton!
    
    @IBOutlet weak var o138: UIButton!
    @IBOutlet weak var o137: UIButton!
    
    
    @IBAction func b6(_ sender: Any) {
        tilePressed(buttonNum: 6)
    }
    @IBAction func b7(_ sender: Any) {
        tilePressed(buttonNum: 7)
    }
    
    @IBAction func b8(_ sender: Any) {
        tilePressed(buttonNum: 8)
    }
    @IBAction func b9(_ sender: Any) {
        tilePressed(buttonNum: 9)
    }
    @IBAction func b10(_ sender: Any) {
        tilePressed(buttonNum: 10)
    }
    @IBAction func b11(_ sender: Any) {
        tilePressed(buttonNum: 11)
    }
    @IBAction func b12(_ sender: Any) {
        tilePressed(buttonNum: 12)
    }
    
    @IBAction func b13(_ sender: Any) {
        tilePressed(buttonNum: 13)
    }
    @IBAction func b14(_ sender: Any) {
        tilePressed(buttonNum: 14)
    }
    @IBAction func b15(_ sender: Any) {
        tilePressed(buttonNum: 15)
    }
    @IBAction func b16(_ sender: Any) {
        tilePressed(buttonNum: 16)
    }
    @IBAction func b17(_ sender: Any) {
        tilePressed(buttonNum: 17)
    }
    @IBAction func b18(_ sender: Any) {
        tilePressed(buttonNum: 18)
    }
    @IBAction func b19(_ sender: Any) {
        tilePressed(buttonNum: 19)
    }
    @IBAction func b20(_ sender: Any) {
        tilePressed(buttonNum: 20)
    }
    
    @IBAction func b21(_ sender: Any) {
        tilePressed(buttonNum: 21)
    }
    @IBAction func b22(_ sender: Any) {
        tilePressed(buttonNum: 22)
    }
    @IBAction func b23(_ sender: Any) {
        tilePressed(buttonNum: 23)
    }
    @IBAction func b24(_ sender: Any) {
        tilePressed(buttonNum: 24)
    }
    @IBAction func b25(_ sender: Any) {
        tilePressed(buttonNum: 25)
    }
    @IBAction func b26(_ sender: Any) {
        tilePressed(buttonNum: 26)
    }
    @IBAction func b27(_ sender: Any) {
        tilePressed(buttonNum: 27)
    }
    @IBAction func b28(_ sender: Any) {
        tilePressed(buttonNum: 28)
    }
    @IBAction func b29(_ sender: Any) {
        tilePressed(buttonNum: 29)
    }
    @IBAction func b30(_ sender: Any) {
        tilePressed(buttonNum: 30)
    }
    @IBAction func b31(_ sender: Any) {
        tilePressed(buttonNum: 31)
    }
    
    @IBAction func b32(_ sender: Any) {
        tilePressed(buttonNum: 32)
    }
    @IBAction func b33(_ sender: Any) {
        tilePressed(buttonNum: 33)
    }
    @IBAction func b34(_ sender: Any) {
        tilePressed(buttonNum: 34)
    }
    @IBAction func b35(_ sender: Any) {
        tilePressed(buttonNum: 35)
    }
    @IBAction func b36(_ sender: Any) {
        tilePressed(buttonNum: 36)
    }
    @IBAction func b37(_ sender: Any) {
        tilePressed(buttonNum: 37)
    }
    @IBAction func b38(_ sender: Any) {
        tilePressed(buttonNum: 38)
    }
    @IBAction func b39(_ sender: Any) {
        tilePressed(buttonNum: 39)
    }
    @IBAction func b40(_ sender: Any) {
        tilePressed(buttonNum: 40)
    }
    @IBAction func b41(_ sender: Any) {
        tilePressed(buttonNum: 41)
    }
    @IBAction func b42(_ sender: Any) {
        tilePressed(buttonNum: 42)
    }
    @IBAction func b43(_ sender: Any) {
        tilePressed(buttonNum: 43)
    }
    
    @IBAction func b44(_ sender: Any) {
        tilePressed(buttonNum: 44)
    }
    @IBAction func b45(_ sender: Any) {
        tilePressed(buttonNum: 45)
    }
    @IBAction func b46(_ sender: Any) {
        tilePressed(buttonNum: 46)
    }
    @IBAction func b47(_ sender: Any) {
        tilePressed(buttonNum: 47)
    }
    @IBAction func b48(_ sender: Any) {
        tilePressed(buttonNum: 48)
    }
    @IBAction func b49(_ sender: Any) {
        tilePressed(buttonNum: 49)
    }
    @IBAction func b50(_ sender: Any) {
        tilePressed(buttonNum: 50)
    }
    @IBAction func b51(_ sender: Any) {
        tilePressed(buttonNum: 51)
    }
    @IBAction func b52(_ sender: Any) {
        tilePressed(buttonNum: 52)
    }
    @IBAction func b53(_ sender: Any) {
        tilePressed(buttonNum: 53)
    }
    @IBAction func b54(_ sender: Any) {
        tilePressed(buttonNum: 54)
    }
    
    @IBAction func b55(_ sender: Any) {
        tilePressed(buttonNum: 55)
    }
    @IBAction func b56(_ sender: Any) {
        tilePressed(buttonNum: 56)
    }
    @IBAction func b57(_ sender: Any) {
        tilePressed(buttonNum: 57)
    }
    @IBAction func b58(_ sender: Any) {
        tilePressed(buttonNum: 58)
    }
    @IBAction func b59(_ sender: Any) {
        tilePressed(buttonNum: 59)
    }
    @IBAction func b60(_ sender: Any) {
        tilePressed(buttonNum: 60)
    }
    @IBAction func b61(_ sender: Any) {
        tilePressed(buttonNum: 61)
    }
    @IBAction func b62(_ sender: Any) {
        tilePressed(buttonNum: 62)
    }
    @IBAction func b63(_ sender: Any) {
        tilePressed(buttonNum: 63)
    }
    @IBAction func b64(_ sender: Any) {
        tilePressed(buttonNum: 64)
    }
    @IBAction func b65(_ sender: Any) {
        tilePressed(buttonNum: 65)
    }
    @IBAction func b66(_ sender: Any) {
        tilePressed(buttonNum: 66)
    }
    
    @IBAction func b67(_ sender: Any) {
        tilePressed(buttonNum: 67)
    }
    @IBAction func b68(_ sender: Any) {
        tilePressed(buttonNum: 68)
    }
    @IBAction func b69(_ sender: Any) {
        tilePressed(buttonNum: 69)
    }
    @IBAction func b70(_ sender: Any) {
        tilePressed(buttonNum: 70)
    }
    @IBAction func b71(_ sender: Any) {
        tilePressed(buttonNum: 71)
    }
    @IBAction func b72(_ sender: Any) {
        tilePressed(buttonNum: 72)
    }
    @IBAction func b73(_ sender: Any) {
        tilePressed(buttonNum: 73)
    }
    @IBAction func b74(_ sender: Any) {
        tilePressed(buttonNum: 74)
    }
    @IBAction func b75(_ sender: Any) {
        tilePressed(buttonNum: 75)
    }
    @IBAction func b76(_ sender: Any) {
        tilePressed(buttonNum: 76)
    }
    @IBAction func b77(_ sender: Any) {
        tilePressed(buttonNum: 77)
    }
    
    @IBAction func b78(_ sender: Any) {
        tilePressed(buttonNum: 78)
    }
    @IBAction func b79(_ sender: Any) {
        tilePressed(buttonNum: 79)
    }
    @IBAction func b80(_ sender: Any) {
        tilePressed(buttonNum: 80)
    }
    @IBAction func b81(_ sender: Any) {
        tilePressed(buttonNum: 81)
    }
    @IBAction func b82(_ sender: Any) {
        tilePressed(buttonNum: 82)
    }
    @IBAction func b83(_ sender: Any) {
        tilePressed(buttonNum: 83)
    }
    @IBAction func b84(_ sender: Any) {
        tilePressed(buttonNum: 84)
    }
    @IBAction func b85(_ sender: Any) {
        tilePressed(buttonNum: 85)
    }
    @IBAction func b86(_ sender: Any) {
        tilePressed(buttonNum: 86)
    }
    @IBAction func b87(_ sender: Any) {
        tilePressed(buttonNum: 87)
    }
    @IBAction func b88(_ sender: Any) {
        tilePressed(buttonNum: 88)
    }
    @IBAction func b89(_ sender: Any) {
        tilePressed(buttonNum: 89)
    }
    
    @IBAction func b90(_ sender: Any) {
        tilePressed(buttonNum: 90)
    }
    @IBAction func b91(_ sender: Any) {
        tilePressed(buttonNum: 91)
    }
    @IBAction func b92(_ sender: Any) {
        tilePressed(buttonNum: 92)
    }
    @IBAction func b93(_ sender: Any) {
        tilePressed(buttonNum: 93)
    }
    @IBAction func b94(_ sender: Any) {
        tilePressed(buttonNum: 94)
    }
    @IBAction func b95(_ sender: Any) {
        tilePressed(buttonNum: 95)
    }
    @IBAction func b96(_ sender: Any) {
        tilePressed(buttonNum: 96)
    }
    @IBAction func b97(_ sender: Any) {
        tilePressed(buttonNum: 97)
    }
    @IBAction func b98(_ sender: Any) {
        tilePressed(buttonNum: 98)
    }
    @IBAction func b99(_ sender: Any) {
        tilePressed(buttonNum: 99)
    }
    @IBAction func b100(_ sender: Any) {
        tilePressed(buttonNum: 100)
    }
    
    @IBAction func b101(_ sender: Any) {
        tilePressed(buttonNum: 101)
    }
    @IBAction func b102(_ sender: Any) {
        tilePressed(buttonNum: 102)
    }
    @IBAction func b103(_ sender: Any) {
        tilePressed(buttonNum: 103)
    }
    @IBAction func b104(_ sender: Any) {
        tilePressed(buttonNum: 104)
    }
    @IBAction func b105(_ sender: Any) {
        tilePressed(buttonNum: 105)
    }
    @IBAction func b106(_ sender: Any) {
        tilePressed(buttonNum: 106)
    }
    @IBAction func b107(_ sender: Any) {
        tilePressed(buttonNum: 107)
    }
    @IBAction func b108(_ sender: Any) {
        tilePressed(buttonNum: 108)
    }
    @IBAction func b109(_ sender: Any) {
        tilePressed(buttonNum: 109)
    }
    @IBAction func b110(_ sender: Any) {
        tilePressed(buttonNum: 110)
    }
    @IBAction func b111(_ sender: Any) {
        tilePressed(buttonNum: 111)
    }
    @IBAction func b112(_ sender: Any) {
        tilePressed(buttonNum: 112)
    }
    
    @IBAction func b113(_ sender: Any) {
        tilePressed(buttonNum: 113)
    }
    @IBAction func b114(_ sender: Any) {
        tilePressed(buttonNum: 114)
    }
    @IBAction func b115(_ sender: Any) {
        tilePressed(buttonNum: 115)
    }
    @IBAction func b116(_ sender: Any) {
        tilePressed(buttonNum: 116)
    }
    @IBAction func b117(_ sender: Any) {
        tilePressed(buttonNum: 117)
    }
    @IBAction func b118(_ sender: Any) {
        tilePressed(buttonNum: 118)
    }
    @IBAction func b119(_ sender: Any) {
        tilePressed(buttonNum: 119)
    }
    @IBAction func b120(_ sender: Any) {
        tilePressed(buttonNum: 120)
    }
    @IBAction func b121(_ sender: Any) {
        tilePressed(buttonNum: 121)
    }
    @IBAction func b122(_ sender: Any) {
        tilePressed(buttonNum: 122)
    }
    @IBAction func b123(_ sender: Any) {
        tilePressed(buttonNum: 123)
    }
    
    @IBAction func b124(_ sender: Any) {
        tilePressed(buttonNum: 124)
    }
    @IBAction func b125(_ sender: Any) {
        tilePressed(buttonNum: 125)
    }
    @IBAction func b126(_ sender: Any) {
        tilePressed(buttonNum: 126)
    }
    @IBAction func b127(_ sender: Any) {
        tilePressed(buttonNum: 127)
    }
    @IBAction func b128(_ sender: Any) {
        tilePressed(buttonNum: 128)
    }
    @IBAction func b129(_ sender: Any) {
        tilePressed(buttonNum: 129)
    }
    @IBAction func b130(_ sender: Any) {
        tilePressed(buttonNum: 130)
    }
    @IBAction func b131(_ sender: Any) {
        tilePressed(buttonNum: 131)
    }
    
    @IBAction func b132(_ sender: Any) {
        tilePressed(buttonNum: 132)
    }
    @IBAction func b133(_ sender: Any) {
        tilePressed(buttonNum: 133)
    }
    @IBAction func b134(_ sender: Any) {
        tilePressed(buttonNum: 134)
    }
    @IBAction func b135(_ sender: Any) {
        tilePressed(buttonNum: 135)
    }
    @IBAction func b136(_ sender: Any) {
        tilePressed(buttonNum: 136)
    }
    
    @IBAction func b137(_ sender: Any) {
        tilePressed(buttonNum: 137)
    }
    @IBAction func b138(_ sender: Any) {
        tilePressed(buttonNum: 138)
    }
    
    @IBOutlet weak var human0: UILabel!
    @IBOutlet weak var cpu0: UILabel!
    @IBAction func switch0(_ sender: UISwitch) {
        isComputer[0] = sender.isOn
        human0.isHidden = sender.isOn
        cpu0.isHidden = !sender.isOn
    }
    @IBOutlet weak var human1: UILabel!
    @IBOutlet weak var cpu1: UILabel!
    @IBAction func switch1(_ sender: UISwitch) {
        isComputer[1] = sender.isOn
        human1.isHidden = sender.isOn
        cpu1.isHidden = !sender.isOn
    }
    @IBOutlet weak var human2: UILabel!
    @IBOutlet weak var cpu2: UILabel!
    @IBAction func switch2(_ sender: UISwitch) {
        isComputer[2] = sender.isOn
        human2.isHidden = sender.isOn
        cpu2.isHidden = !sender.isOn
    }
    @IBOutlet weak var human3: UILabel!
    @IBOutlet weak var cpu3: UILabel!
    @IBAction func switch3(_ sender: UISwitch) {
        isComputer[3] = sender.isOn
        human3.isHidden = sender.isOn
        cpu3.isHidden = !sender.isOn
    }
    @IBOutlet weak var human4: UILabel!
    @IBOutlet weak var cpu4: UILabel!
    @IBAction func switch4(_ sender: UISwitch) {
        isComputer[4] = sender.isOn
        human4.isHidden = sender.isOn
        cpu4.isHidden = !sender.isOn
    }
    @IBOutlet weak var human5: UILabel!
    @IBOutlet weak var cpu5: UILabel!
    @IBAction func switch5(_ sender: UISwitch) {
        isComputer[5] = sender.isOn
        human5.isHidden = sender.isOn
        cpu5.isHidden = !sender.isOn
    }
    
    
    func tilePressed(buttonNum: Int) {
        if NewGame_outlet.titleLabel?.text != "Restart" {
            let alertController1 = UIAlertController(title: "Start Game", message: "You must begin a game before flipping a tile.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController1.addAction(okAction)
            self.present(alertController1, animated: true, completion: nil)
            return
        }
        
        print(buttonNum)
        
        let currentIndex = playerLoc[whosTurn]
        let currentLocationTile = TileArray[currentIndex]
        var validMove = false

        for neighbor in currentLocationTile.neighbors {
            if neighbor == buttonNum && TileArray[neighbor].flipped == false {
                validMove = true
                lastPlayerToMove = whosTurn
                break
            }
        }

        if validMove {
            print("Valid Move")
            turnCount[whosTurn] += 1
            playerLoc[whosTurn] = buttonNum
            TileArray[buttonNum].flipped = true
            
            var foundNext = false
            while !foundNext && playersLeft > 1 {
                whosTurn += 1
                if whosTurn > 5 {
                    whosTurn = 0
                }
                
                if playerLoc[whosTurn] >= 0 {
                    let nextPlayerLoc = TileArray[playerLoc[whosTurn]]
                    var validMoves = 0
                    for neighbor in nextPlayerLoc.neighbors {
                        if TileArray[neighbor].flipped == false {
                            validMoves += 1
                            break
                        }
                    }
                    if validMoves == 0 {
                        print("Player has been eliminated")
                        playerLoc[whosTurn] = -1
                        playersLeft -= 1
                        
                        timer.invalidate()
                        let alertController1 = UIAlertController(title: "\(nameArray[whosTurn]) has been eliminated", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            if !self.PlayerWins() {
                                self.timer.invalidate()
                                self.timer = Timer.scheduledTimer(timeInterval: self.TIME_INTERVAL, target: self, selector: #selector(self.inrementTimer), userInfo: nil, repeats: true)
                            }
                        }
                        alertController1.addAction(okAction)
                        self.present(alertController1, animated: true, completion: nil)
                    }else {
                        foundNext = true
                    }
                }
            }
            
            if foundNext && playersLeft > 1 && isComputer[whosTurn] {
                bestMove = findBestMove()
            }
        }else {
            print("Invalid Move")
            if isComputer[whosTurn] {
                bestMove = findBestMove()
            }
        }
        
        
//        for tile in TileArray {
//            tile.button?.setImage(UIImage(named: "hexagon_yellow.png") , for: .normal)
//        }
//        let tile = TileArray[buttonNum]
//        tile.button?.setImage(UIImage(named: "hexagon_yellow.png") , for: .normal)
//        for i in tile.neighbors {
//            let subTile = TileArray[i]
//            subTile.button?.setImage(UIImage(named: "hexagon_purple.png") , for: .normal)
//        }
        
        UpdateUi()
    }
    
    func findBestMove() -> Int {
        
        var targetTile = -1
        
        var moveOptions: [Int] = []
        moveOptions.removeAll()
        
        //get array of possible moves
        let currentTile = TileArray[playerLoc[whosTurn]]
        for n in currentTile.neighbors {
            if TileArray[n].flipped == false {
                moveOptions.append(n)
            }
        }
        
        //if only one move is available, that is the best option
        if moveOptions.count == 1 {
            return moveOptions[0]
        }
        
        //see if anyone can be blocked in
        if moveOptions.count >= 2 && turnCount[whosTurn] > 5 {
            //see if any other players have 2 or less move options
            var limitedMovesPlayers: [Int] = []
            limitedMovesPlayers.removeAll()
            for i in 0..<6 {
                if i != whosTurn  && playerLoc[i] != -1{  //only try to block other players (those still in the game)
                    let playerTile = TileArray[playerLoc[i]]
                    var moveCount = 0
                    for n in playerTile.neighbors {
                        if TileArray[n].flipped == false {
                            moveCount += 1
                        }
                    }
                    if moveCount <= 2 {
                        limitedMovesPlayers.append(i)
                    }
                }
            }
            
            if limitedMovesPlayers.count > 0 {
                limitedMovesPlayers.shuffle()   //if there is more than one option, we will randomly pick one
                
                for i in limitedMovesPlayers {
                    let playerTile = TileArray[playerLoc[i]]
                    
                    //check for a shared neighbor
                    var sharedNeighborArray: [Int] = []
                    for n in currentTile.neighbors {
                        if playerTile.neighbors.contains(n) && TileArray[n].flipped == false {
                            sharedNeighborArray.append(n)
                        }
                    }
                    
                    if sharedNeighborArray.count == 1 && GetTileMobilityCount(val: sharedNeighborArray[0]) > 1 {
                        return sharedNeighborArray[0]   //use the only shared neighbor
                    }else if sharedNeighborArray.count > 1 {
                        //if there is more than one shared neighbor, go to the one with more mobility
                        var mostMobilityCount = 0
                        var mostMobilityValue = -1
                        
                        for val in sharedNeighborArray {
                            let moveCount = GetTileMobilityCount(val: val)
                            if moveCount > mostMobilityCount {
                                mostMobilityCount = moveCount
                                mostMobilityValue = val
                            }
                        }
                        if mostMobilityValue != -1 && GetTileMobilityCount(val: sharedNeighborArray[0]) > 1 {
                            return mostMobilityValue
                        }
                    }
                }
            }
        }
        
        if turnCount[whosTurn] < 5 {
            targetTile = 72
        }
        
        //Try to block
        if currentTile.neighbors.count > 1 {
            
        }
        
        var pathOptions: [[Int]] = [[]]
        pathOptions.removeAll()
        
        //try X random paths
        for _ in 0..<200 {   //number of paths
            pathOptions.append([])
            var currentTile = TileArray[playerLoc[whosTurn]]
            for _ in 0..<20 { //max length of path
                let val = getRandomNeighbor(tile: currentTile.buttonIndex, dontUse: pathOptions[pathOptions.count - 1])
                if val == -1 {
                    break
                }
                pathOptions[pathOptions.count - 1].append(val)
                currentTile = TileArray[val]
            }
        }
        
        if targetTile != -1 {
//            var val = 0
//            for arr in pathOptions {
//                print("\(val) \(arr)")
//                val += 1
//            }
            
            var lowest = 999
            var arrayIndex = -1
            var i = 0
            for arr in pathOptions {
                if arr.contains(targetTile) {
                    let firstIndex = arr.firstIndex(of: targetTile)
                    if firstIndex! < lowest {
                        lowest = firstIndex!
                        arrayIndex = i
                    }
                }
                i += 1
            }
            if arrayIndex > -1 {
                return pathOptions[arrayIndex][0]
            }
            
//            for i in 0..<20 {
//                for j in 0..<200 {
//                    if i >= pathOptions[j].count {
//                        //don't go past the end of the array
//                    }else if pathOptions[j][i] == 72 {
//                        return pathOptions[j][0]
//                    }
//                }
//            }
        }
        
        var maxLength = 0
        for arr in pathOptions {
            if arr.count > maxLength {
                maxLength = arr.count
            }
        }
        
        if maxLength > 0
        {
            var i = 0
            for _ in 0..<pathOptions.count {
                if pathOptions[i].count < maxLength {
                    pathOptions.remove(at: i)
                }else {
                    i += 1
                }
            }
            
            if pathOptions.count > 0 {
                pathOptions.shuffle()
                return pathOptions[0][0]
            }
        }
        
        return -1
    }
    
    func getRandomNeighbor(tile: Int, dontUse: [Int]) -> Int {
        let currentTile = TileArray[tile]
        
        var neighborArray: [Tile] = []
        neighborArray.removeAll()
        
        for n in currentTile.neighbors {
            if TileArray[n].flipped == false && dontUse.contains(n) == false {
                neighborArray.append(TileArray[n])
            }
        }
        
        if neighborArray.count == 0 {
            return -1
        }
        
        neighborArray.shuffle()
        return neighborArray[0].buttonIndex
    }
    
//    func pathRecursive(tile: Int, availableSpaces: [Int], maxSearch: Int) {
//        let currentTile = TileArray[tile]
//        if startNewArray {
//            startNewArray = false
//            pathOptions.append([])
//            pathOptions[pathOptions.count - 1].append(currentTile.buttonIndex)
//        }
//        for neighbor in currentTile.neighbors {
//            var subArray = availableSpaces
//            if subArray.contains(neighbor) {
//                pathOptions[pathOptions.count - 1].append(neighbor)
//                subArray = subArray.filter(){$0 != neighbor}
//                if subArray.count == 0 {
//                    print("done all \(pathOptions.count) \(pathOptions[pathOptions.count - 1])")
//                    startNewArray = true
//                    break
//                }
//                if pathOptions[pathOptions.count - 1].count < maxSearch {
//                    pathRecursive(tile: neighbor, availableSpaces: subArray, maxSearch: 10)
//                }else {
//                    print("done short \(pathOptions.count) \(pathOptions[pathOptions.count - 1])")
//                    startNewArray = true
//                    break
//                }
//            }
//        }
//    }
    
    func PlayerWins() -> Bool {
        if playersLeft == 1 {
            timer.invalidate()
            let alertController2 = UIAlertController(title: "\(nameArray[lastPlayerToMove]) Wins!", message: "", preferredStyle: .alert)
            whosTurn = lastPlayerToMove //to update the background to the winner's color
            NewGame_outlet.setTitle("New Game", for: .normal)
            UpdateUi()
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.UpdateUi()
            }
            alertController2.addAction(okAction)
            self.present(alertController2, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func UpdateUi () {
        WhiteStart.alpha = 1
        RedStart.alpha = 1
        BlueStart.alpha = 1
        OrangeStart.alpha = 1
        GreenStart.alpha = 1
        YellowStart.alpha = 1
        for tile in TileArray {
            tile.button?.alpha = 1
            if playerLoc[0] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_white.png") , for: .normal)
            }else if playerLoc[1] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_red.png") , for: .normal)
            }else if playerLoc[2] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_blue.png") , for: .normal)
            }else if playerLoc[3] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_orange.png") , for: .normal)
            }else if playerLoc[4] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_green.png") , for: .normal)
            }else if playerLoc[5] == tile.buttonIndex {
                tile.button?.setImage(UIImage(named: "hexagon_purple_yellow.png") , for: .normal)
            }else if tile.flipped {
                tile.button?.setImage(UIImage(named: "hexagon_purple.png") , for: .normal)
            }else {
                tile.button?.setImage(UIImage(named: "hexagon_yellow.png") , for: .normal)
            }
        }
        
        switch whosTurn {
        case 0:
            BackgroundRing.backgroundColor = UIColor.white
        case 1:
            BackgroundRing.backgroundColor = UIColor.red
        case 2:
            BackgroundRing.backgroundColor = UIColor.blue
        case 3:
            BackgroundRing.backgroundColor = UIColor.orange
        case 4:
            BackgroundRing.backgroundColor = UIColor.green
        case 5:
            BackgroundRing.backgroundColor = UIColor.yellow
        default:
            BackgroundRing.backgroundColor = UIColor.white
        }
        
    }
    
    func GetTileMobilityCount(val: Int) -> Int{
        let tile = TileArray[val]
        var moveCount = 0
        for n in tile.neighbors {
            if TileArray[n].flipped == false {
                moveCount += 1
            }
        }
        return moveCount
    }

}
