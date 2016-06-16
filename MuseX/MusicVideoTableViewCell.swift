//
//  MusicVideoTableViewCell.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var title: UILabel!
    
    var video: Video? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)

        rank.text = String(video!.rank)
        title.text = video?.title
        
        if video?.imageData != nil {
            musicImage.image = UIImage(data: video!.imageData!) // already have image data
        } else {
            getVideoImage(video!, imageView: musicImage)
        }
        
    }
    
    func getVideoImage(video: Video, imageView: UIImageView) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.imageURL)!)
            var image: UIImage?
            
            if data != nil {
                video.imageData = data
                image = UIImage(data: data!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
    
}
