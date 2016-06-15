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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}

