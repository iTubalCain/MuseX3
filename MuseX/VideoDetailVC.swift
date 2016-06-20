//
//  VideoDetailVC.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import AVFoundation
import AVKit
import LocalAuthentication
import UIKit

class VideoDetailVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var securitySwitch = false

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("Settings: Security")
        switch  securitySwitch {
        case true:
          checkTouchID(sender)
//            shareMedia(sender)
        default:
            shareMedia(sender)
        }
    }
    
    func checkTouchID(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Cancel, handler: nil))
        
        let context = LAContext()   // create Local Authentication Context
        var touchIDerror : NSError?
        
        // Does device support Touch ID?
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIDerror) {
            // Check auth response
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason:  "Touch ID is required for sharing via social media", reply: { (success, policyError) -> Void in
                if success {
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.shareMedia(sender)
                    }
                } else {  // Device has Touch ID but there is an issue
                    alert.title = "Unsuccessful!"
                    switch LAError(rawValue: policyError!.code)! {
                    case .AppCancel:
                        alert.message = "Application cancelled authentication"
                    case .AuthenticationFailed:
                        alert.message = "User credentials invalid"
                    case .PasscodeNotSet:
                        alert.message = "Passcode not set on device"
                    case .SystemCancel:
                        alert.message = "System cancelled authentication"
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts"
                    case .UserCancel:
                        alert.message = "User cancelled authentication"
                    case .UserFallback:
                        alert.message = "Password not accepted. Use Touch ID"
                    default:
                        alert.message = "Unable to authenticate"
                    }
                    // show alert
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {    // Unable to access device authentication, e.g. no Touch ID
            alert.title = "Error"
            
            switch LAError(rawValue: touchIDerror!.code)! {
                case .TouchIDNotEnrolled:
                    alert.message = "Touch ID not enrolled"
                case .TouchIDNotAvailable:
                    alert.message = "Touch ID unavailable on this device"
                case .PasscodeNotSet:
                    alert.message = "Passcode has not been set"
                case .InvalidContext:
                    alert.message = "Context invalid"
                default:
                    alert.message = "Local authentication unavailable"
            }
        }
    } // end checkTouchID
    
    func shareMedia(sender: UIBarButtonItem) {
        let messageArray = ["Have you seen this music video called \"\(musicVideo.title)\" by \(musicVideo.artist) yet? You can watch it and tell me what you think of it.\n",
                          musicVideo.videoURL]
        
        let activityVC = UIActivityViewController(activityItems: messageArray, applicationActivities: nil)
        activityVC.title = "Share with friends"
        activityVC.excludedActivityTypes = [UIActivityTypePostToFlickr]  // exclude whatever
        
        activityVC.completionWithItemsHandler = { // post processing
            (activity, items, success, error) in
            if activity == UIActivityTypeMail { // can't email on simulator
                print("email selected")
            } else {
                print("Popped over!")
            }
        }

        // iPad requires popover as container
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.barButtonItem = sender
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(URL: NSURL(string: musicVideo.videoURL)!)
        self.presentViewController(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    var musicVideo: Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        //      title = musicVideo.artist
        title = "#\(musicVideo.rank) on iTunes"
        detailTitleLabel.text = musicVideo.title
        artistLabel.text = musicVideo.artist
        genreLabel.text = musicVideo.genre
        priceLabel.text = musicVideo.price
        rightsLabel.text = musicVideo.rights
        if musicVideo.imageData != nil {
            videoImage.image = UIImage(data: musicVideo.imageData!)
        } else {
            videoImage.image = UIImage(contentsOfFile: "imageNotAvailable")
        }
    }

    func preferredFontChanged() {
        // title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        artistLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        detailTitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        genreLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        priceLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        rightsLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
}

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

}
