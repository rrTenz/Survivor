//
//  Defaults.swift
//  Puzzles from Survivor
//
//  Created by Ryan Tensmeyer on 3/13/19.
//  Copyright © 2019 Ryan Tensmeyer. All rights reserved.
//

import Foundation
import UIKit

internal class Defaults {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let key_preset_version = "key_version"
    
    func load_Defaults() {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: key_preset_version) == nil {
            print("Version has not been saved")
        }else {
            appDelegate.version = defaults.string(forKey: key_preset_version)!
        }
    }
    
    func save_Defaults() {
        let defaults = UserDefaults.standard
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            defaults.set(version, forKey: key_preset_version)
        }
    }

}
