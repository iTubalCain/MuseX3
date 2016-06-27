//
//  SettingsVC.swift
//  MuseX
//
//  Created by Will on 6/17/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

// TODO: fix iPad format and landscape view size classes
// TODO: font size changes failing

import MessageUI
import UIKit

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var imageQualityLabel: UILabel!
    
    @IBOutlet weak var imageQualityOutlet: UISegmentedControl!
    @IBAction func imageQualitySegmentedControl(sender: UISegmentedControl) {
        NSUserDefaults.standardUserDefaults().setInteger(imageQualityOutlet.selectedSegmentIndex, forKey: "Settings: Image Quality")
        print("\(imageQualityOutlet.selectedSegmentIndex)")
    }

    @IBOutlet weak var topXVideos: UILabel!
    @IBOutlet weak var topXVideosSlider: UISlider!
    
//    @IBAction func bestImageQualitySwitch(sender: UISwitch) {
//        NSUserDefaults.standardUserDefaults().setBool((imageQualitySwitch.on ? true : false), forKey: "Settings: Best Image")
//    }
    
    @IBAction func topXSlider(sender: UISlider) {
        NSUserDefaults.standardUserDefaults().setFloat(topXVideosSlider.value, forKey: "Settings: Top x")
        topXVideos.text = String(Int(topXVideosSlider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = false

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // set defaults
        imageQualityOutlet.selectedSegmentIndex = NSUserDefaults.standardUserDefaults().integerForKey("Settings: Image Quality")
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
        imageQualityLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        topXVideos.font     = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 { // Feedback row
            let mailComposeVC = configureMail()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeVC, animated: true, completion: nil)
            } else {
            mailAlert() // no email acct set up on device
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // TODO: Test Feedback Mail functions, part of Model??????
    // MARK: - EMail
    
    func configureMail() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject("MuseX App Feedback")
        mailComposeVC.setToRecipients(["myMail@me.com"])
        mailComposeVC.setMessageBody("Hello!\n\nI would like to share this feedback on the Musex App...\n", isHTML: true)
        return mailComposeVC
    }
    
    func mailAlert() {
        let alertController = UIAlertController(title: "Alert", message: "No email account set up on this device.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            // add action performance here
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue: print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:     print("Mail saved")
        case MFMailComposeResultSent.rawValue:      print("Mail sent")
        case MFMailComposeResultFailed.rawValue:    print("Mail failed")
        default: print("Unknown mail issue")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

}
