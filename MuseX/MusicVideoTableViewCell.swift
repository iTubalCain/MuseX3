
//  MusicVideoTableViewCell.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var songTitle:  UILabel!
    @IBOutlet weak var rankNumber: UILabel!
    
    var musicVideo: Video? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        preferredFontChanged()
        rankNumber.text = "#\(musicVideo!.rank)"
        songTitle.text = "\(musicVideo!.songTitle)"
//        musicImage.image = musicVideo!.image
        musicVideo?.queueImageFetch(imageView: musicImage)
    }
    
    private func preferredFontChanged() {
        rankNumber.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        songTitle.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
    }
     
}
