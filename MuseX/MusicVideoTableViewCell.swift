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
        musicImage.image = UIImage (named: "imageNotAvailable")
        rank.text = String(video!.rank)
        title.text = video?.title
    }
    
}
