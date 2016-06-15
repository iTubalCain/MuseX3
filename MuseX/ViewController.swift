//
//  ViewController.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var videos = [Video]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
//      print(reachabilityStatus)

        let api = APIManager()
        api.loadData("http://itunes.apple.com/us/rss/topmusicvideos/limit=50/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Video]) {
        self.videos = videos
//        for video in videos {
//            print("Title: \(video.title)")
//        }
        for (index, video) in videos.enumerate() {
            print("\(index + 1): \(video.releaseDate)")
        }
        tableView.reloadData()
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
            default:
                return
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let video = videos[indexPath.row]
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.title
        return cell
    }
  
    
}

