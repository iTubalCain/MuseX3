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
    @IBOutlet weak var explicitContentLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var imageQualityLabel: UILabel!
    @IBOutlet weak var imageQualityOutlet: UISegmentedControl!
    
    @IBOutlet weak var explicitContentSwitch: UISwitch!
    @IBAction func imageQualitySegmentedControl(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(imageQualityOutlet.selectedSegmentIndex, forKey: UD_IMAGE_QUALITY)
    }

    @IBOutlet weak var topXVideos: UILabel!
    @IBOutlet weak var topXVideosSlider: UISlider!
    
    @IBAction func explicitContentAllowed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UD_EXPLICIT_CONTENT)
    }
    
    @IBAction func topXSlider(_ sender: UISlider) {
        UserDefaults.standard.set(topXVideosSlider.value, forKey: UD_TOP_X)
        topXVideos.text = String(Int(topXVideosSlider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = false

        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        // set defaults
        explicitContentSwitch.isOn = UserDefaults.standard.bool(forKey: UD_EXPLICIT_CONTENT)

        imageQualityOutlet.selectedSegmentIndex = UserDefaults.standard.integer(forKey: UD_IMAGE_QUALITY)

        topXVideosSlider.value = UserDefaults.standard.float(forKey: UD_TOP_X)
        topXVideos.text = String(Int(topXVideosSlider.value))
   }
    
    func preferredFontChanged()  {
        aboutLabel.font             = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        explicitContentLabel.font   = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        feedbackLabel.font          = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        imageQualityLabel.font      = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        topXVideos.font             = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1 { // Feedback row
            let mailComposeVC = configureMail()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeVC, animated: true, completion: nil)
            } else {
            mailAlert() // no email acct set up on device
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
        let alertController = UIAlertController(title: "Alert", message: "No email account set up on this device.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            // add action performance here
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue: print("Mail cancelled")
            case MFMailComposeResult.saved.rawValue:     print("Mail saved")
            case MFMailComposeResult.sent.rawValue:      print("Mail sent")
            case MFMailComposeResult.failed.rawValue:    print("Mail failed")
            default: print("Unknown mail issue")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }

}
