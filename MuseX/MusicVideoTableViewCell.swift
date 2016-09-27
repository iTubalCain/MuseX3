
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
    @IBOutlet weak var rankNumber: UILabel!
    
    var video: Video? {
        didSet {
            updateCell()
        }
    }
    
    private func updateCell() {
        preferredFontChanged()
        rankNumber.text = "#\(video!.rank)"
        songTitle.text = "\(video!.songTitle)"
        
        // TODO: check .image available
        if video?.imageData != nil {
            musicImage.image = UIImage(data: video!.imageData!) // already have image data
            video?.image = musicImage.image
        } else {
            queueVideoImageFetch(video: video!, imageView: musicImage)
        }
    }
    
    private func preferredFontChanged() {
        rankNumber.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        songTitle.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    }
    
//TODO: Part of model!!!
    
    private func queueVideoImageFetch(video: Video, imageView: UIImageView) {
        // TODO: check imageQuality, save image
//        dispatch_async(DispatchQueue.global (DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        DispatchQueue.global(qos: .userInitiated).async
        {
            let data = NSData(contentsOf: NSURL(string: video.imageURLs[HIGH_QUALITY]!)! as URL)
            var image: UIImage?
            
            if data != nil {
//                save image / test quality
                video.imageData = data as Data?
                image = UIImage(data: data! as Data)
            }
            
//            dispatch_get_main_queue().asynchronously()
            DispatchQueue.main.async
                {
                imageView.image = image
                video.image = image
            }
        }
    }
 
}
