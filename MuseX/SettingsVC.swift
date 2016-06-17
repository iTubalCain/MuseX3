//
//  SettingsVC.swift
//  MuseX
//
//  Created by Will on 6/17/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var securityLabel: UILabel!
    @IBOutlet weak var securitySwitch: UISwitch!
    @IBOutlet weak var imageQualityLabel: UILabel!
    @IBOutlet weak var imageQualitySwitch: UISwitch!
    @IBOutlet weak var topXVideos: UILabel!
    @IBOutlet weak var topXVideosSlider: UISlider!
    
    @IBAction func touchIDSwitch(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool((securitySwitch.on ? true : false), forKey: "Settings: Security")
    }
    
    @IBAction func bestImageQualitySwitch(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool((imageQualitySwitch.on ? true : false), forKey: "Settings: Best Image")
    }
    
    @IBAction func topXSlider(sender: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(topXVideosSlider.value, forKey: "Settings: Top x")
        topXVideos.text = String(Int(topXVideosSlider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = false

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // set defaults
        securitySwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("Settings: Security")
        imageQualitySwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("Settings: Best Image")
//        if let sliderValue = NSUserDefaults.standardUserDefaults().objectForKey("Settings: Top x") as? Float {
//            topXVideos.text = String(Int(sliderValue))
//            topXVideosSlider.value = sliderValue
//        }
        topXVideosSlider.value = NSUserDefaults.standardUserDefaults().floatForKey("Settings: Top x")
        topXVideos.text = String(Int(topXVideosSlider.value))
   }
    
    func preferredFontChanged()  {
        aboutLabel.font     = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        feedbackLabel.font  = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        securityLabel.font  = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        imageQualityLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        topXVideos.font     = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

}
