//
//  MusicVideoVC.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoVC: UITableViewController {

    @IBAction func refreshControl(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        runAPI()
    }
    
    private struct StoryBoard {
        static let cellReuseIdentifier = "customCell"
        static let segueIdentifier =  "videoDetail"
    }

    var videos = [Video]()
    
    var filterSearch = [Video]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    // nil means display search results in same view
    
    var maxSongs = 10 // upper limit = 200
    
    func getMaxSongs() {
        maxSongs = Int(NSUserDefaults.standardUserDefaults().floatForKey("Settings: Top x"))
        if maxSongs < 1 {
            maxSongs = MAX_SONGS
            NSUserDefaults.standardUserDefaults().setFloat(Float(maxSongs), forKey: "Settings: Top x")
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = dateFormatter.stringFromDate(NSDate())
        refreshControl?.attributedTitle = NSAttributedString(string: String(refreshDate))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observers
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        reachabilityStatusChanged()
        // print(reachabilityStatus)
        
        // TODO: Fix title prepend prob title=...
    }
    
    func preferredFontChanged() {
        
    }
    
    func runAPI() {
        getMaxSongs()
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(maxSongs)/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Video]) {
        self.videos = videos
        
//        for (index, video) in videos.enumerate() {
//            print("\(index + 1): \(video.releaseDate)")
//        }
        
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
//        title = "MuseX: Top \(maxSongs) Songs" // ADDS TO ALL TITLES!

        // set up search controller
        // resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = true
        resultSearchController.searchBar.placeholder = "Search for Artist"
        // resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.reloadData()  // refresh tableView
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NO_ACCESS:
            // view.backgroundColor = UIColor.orangeColor()
            // Hack to avoid warning: "Presenting view controllers on detached view controllers is discouraged"
            dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: NO_ACCESS, message: "Check your Internet connection", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Default) {
                action -> Void in print("Ok")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
                action -> Void in print("Cancel")
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .Default) {
                action -> Void in print("Delete")
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            } // end Hack
            
        default:
            // view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("Do not refresh API") // data already loaded
            } else {
                runAPI()
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resultSearchController.active { // in searchBar
            return filterSearch.count
        }
        return videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell

        if resultSearchController.active { // in searchBar
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        return cell
    }

    // MARK: - Navigation

     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let musicVideo: Video
                if resultSearchController.active { // in searchBar
                    musicVideo = filterSearch[indexPath.row]
                } else {
                    musicVideo = videos[indexPath.row]
                }
                let destinationVC = segue.destinationViewController as! VideoDetailVC
                destinationVC.musicVideo = musicVideo
            }
            
        }
    }

}
