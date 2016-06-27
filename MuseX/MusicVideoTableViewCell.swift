
//  MusicVideoTableViewCell.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    
    var video: Video? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        preferredFontChanged()
        songTitle.text = "\(video!.songTitle) @ No. \(video!.rank)"
        
        // TODO: check .image available
        if video?.imageData != nil {
            musicImage.image = UIImage(data: video!.imageData!) // already have image data
            video?.image = musicImage.image
        } else {
            queueVideoImageFetch(video!, imageView: musicImage)
        }
    }
    
    private func preferredFontChanged() {
        songTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
//TODO: Part of model!!!
    
    private func queueVideoImageFetch(video: Video, imageView: UIImageView) {
        // TODO: check imageQuality, save image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.imageURLs[HIGH_QUALITY]!)!)
            var image: UIImage?
            
            if data != nil {
//                save image / test quality
                video.imageData = data
                image = UIImage(data: data!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
                video.image = image
            }
        }
    }
 
}
