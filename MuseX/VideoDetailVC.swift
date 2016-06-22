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
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
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
        let asset = AVURLAsset(URL: NSURL(string: musicVideo.videoURL)!)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        let playerVC = AVPlayerViewController()
        
//        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(URL: NSURL(string: musicVideo.videoURL)!)
        self.presentViewController(playerVC, animated: true) {
            playerVC.player?.play()
            playerVC.player?.replaceCurrentItemWithPlayerItem(playerItem)
        }
    }
    
    var musicVideo: Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)

        //      title = musicVideo.artist
        title = "#\(musicVideo.rank) on iTunes"
        detailTitleLabel.text = "\"\(musicVideo.title)\""
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
