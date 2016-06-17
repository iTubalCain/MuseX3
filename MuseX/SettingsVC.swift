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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = false

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)

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
