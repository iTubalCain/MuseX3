//
//  ViewController.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var videos = [Video]()

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
//      print(reachabilityStatus)

        let api = APIManager()
        api.loadData("http://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Video]) {
        self.videos = videos
//        for video in videos {
//            print("Title: \(video.title)")
//        }
        for (index, video) in videos.enumerate() {
            print("\(index + 1): \(video.releaseDate)")
        }
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
            case NO_ACCESS:
                view.backgroundColor = UIColor.orangeColor()
                displayLabel.text = NO_ACCESS
            case WIFI:
                view.backgroundColor = UIColor.greenColor()
                displayLabel.text = WIFI
            case WWAN:
                view.backgroundColor = UIColor.yellowColor()
                displayLabel.text = WWAN
            default: return
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }

}

