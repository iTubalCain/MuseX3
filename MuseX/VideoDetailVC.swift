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
    
    @IBAction func socialMedia(_ sender: UIBarButtonItem) {
        let messageArray = ["Have you seen this music video called \"\(musicVideo.songTitle)\" by \(musicVideo.artist) yet? You can watch it and tell me what you think of it.\n",
                          musicVideo.videoURL]
        
        let activityVC = UIActivityViewController(activityItems: messageArray, applicationActivities: nil)
        activityVC.title = "Share with friends"
        activityVC.excludedActivityTypes = [UIActivityType.postToFlickr]  // exclude whatever
        
        activityVC.completionWithItemsHandler = { // post processing
            (activity, items, success, error) in
            if activity == UIActivityType.mail { // can't email on simulator
                print("email selected")
            } else {
                print("Popped over!")
            }
        }

        // iPad requires popover as container
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.barButtonItem = sender
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func playVideo(_ sender: UIBarButtonItem) {
        let asset = AVURLAsset(url: URL(string: musicVideo.videoURL)!)
        let playerItem = AVPlayerItem(asset: asset)
//        let player = AVPlayer()
//        let playerLayer = AVPlayerLayer(player: player)
        let playerVC = AVPlayerViewController()
        
//        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: URL(string: musicVideo.videoURL)!)
        self.present(playerVC, animated: true) {
            playerVC.player?.play()
            playerVC.player?.replaceCurrentItem(with: playerItem)
        }
    }
    
    var musicVideo: Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)

//        title = musicVideo.artist
        title = "#\(musicVideo.rank)"
        detailTitleLabel.text = "\"\(musicVideo.songTitle)\""
        artistLabel.text = musicVideo.artist
        genreLabel.text  = musicVideo.genre
        priceLabel.text  = musicVideo.price
        rightsLabel.text = musicVideo.rights
//        videoImage.image = musicVideo.image
        musicVideo?.queueImageFetch(imageView: videoImage)


    }

    func preferredFontChanged() {
        // title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        artistLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        detailTitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        genreLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        priceLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        rightsLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
}

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }

}
