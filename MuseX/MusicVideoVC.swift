//
//  MusicVideoVC.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        tableView.tableHeaderView = searchResultsController.searchBar
    }
    
    @IBAction func refreshControl(_ sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        if searchResultsController.isActive {
            refreshControl?.attributedTitle = NSAttributedString(string: "Refresh not available while searching")
        } else {
            runAPI()
        }
    }
    
    fileprivate struct StoryBoard {
        static let cellReuseIdentifier = "customCell"
        static let segueIdentifier =  "videoDetail"
    }

    var videos = [Video]()
    
    var maxSongs = 10 // upper limit = 200
    
    func getMaxSongs() {
        maxSongs = Int(UserDefaults.standard.float(forKey: "Settings: Top x"))
        if maxSongs < 1 {
            maxSongs = MAX_SONGS
            UserDefaults.standard.set(Float(maxSongs), forKey: "Settings: Top x")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = dateFormatter.string(from: Date())
        refreshControl?.attributedTitle = NSAttributedString(string: String(refreshDate))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observers
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        reachabilityStatusChanged()
        // print(reachabilityStatus)
            }
    
    func preferredFontChanged() {
        
    }
    
    func runAPI() {
        getMaxSongs()
        let api = DownloadManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(maxSongs)/json", completion: didLoadData)
    }
    
    func didLoadData(_ videos: [Video]) {
        self.videos = videos
        
//        for (index, video) in videos.enumerate() {
//            print("\(index + 1): \(video.releaseDate)")
//        }
        
        title = "MuseX" // NavVC title appears on all nav pages as back link

        // set up search controller
        
        definesPresentationContext = true
        searchResultsController.dimsBackgroundDuringPresentation = false
        searchResultsController.hidesNavigationBarDuringPresentation = true
        searchResultsController.searchBar.barTintColor = UIColor.black
        searchResultsController.searchBar.placeholder = "Search"
//        searchResultsController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        searchResultsController.searchBar.tintColor = UIColor.white
        searchResultsController.searchBar.scopeButtonTitles = ["All", "Artist", "Genre", "Song"]
        searchResultsController.searchBar.delegate = self
        searchResultsController.searchResultsUpdater = self     // delegate
       
        tableView.reloadData()  // refresh tableView
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NO_ACCESS:
            // view.backgroundColor = UIColor.orangeColor()
            // Hack to avoid warning: "Presenting view controllers on detached view controllers is discouraged"
            DispatchQueue.main.async {
            let alert = UIAlertController(title: NO_ACCESS, message: "Check your Internet connection", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) {
                action -> Void in print("Ok")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                action -> Void in print("Cancel")
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .default) {
                action -> Void in print("Delete")
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
            } // end Hack
            
        default:
            if videos.count > 0 {
                print("Do not refresh API") // data already loaded
            } else {
                runAPI()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchResultsController.isActive { // in searchBar
            return searchResults.count
        }
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.cellReuseIdentifier, for: indexPath) as! MusicVideoTableViewCell

        if searchResultsController.isActive {         // in searchBar
            cell.video = searchResults[(indexPath as NSIndexPath).row]
        } else {
            cell.video = videos[(indexPath as NSIndexPath).row]
        }
        return cell
    }

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoard.segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let musicVideo: Video
                if searchResultsController.isActive { // in searchBar
                    musicVideo = searchResults[(indexPath as NSIndexPath).row]
                } else {
                    musicVideo = videos[(indexPath as NSIndexPath).row]
                }
                let destinationVC = segue.destination as! VideoDetailVC
                destinationVC.musicVideo = musicVideo
            }
        }
    }
    
    // MARK: - Search
    
    var searchResults = [Video]()
    
    let searchResultsController = UISearchController(searchResultsController: nil)
    // nil means display search results in same view
    
    // UISearchResultsUpdating protocol method
    func updateSearchResults(for searchController: UISearchController) {
        let scope =  searchResultsController.searchBar.scopeButtonTitles![searchResultsController.searchBar.selectedScopeButtonIndex]
        searchFiltered(searchResultsController.searchBar.text!, scope: scope)
    }
    
    func searchFiltered(_ searchText: String, scope: String = "All") {
        searchResults = videos.filter { video in
            switch scope {
                case "All":
                    return searchText == "" || video.artist.lowercased().contains(searchText.lowercased()) || video.genre.lowercased().contains(searchText.lowercased()) || video.songTitle.lowercased().contains(searchText.lowercased())
                case "Artist":
                    return searchText == "" || video.artist.lowercased().contains(searchText.lowercased())
                case "Genre":
                    return searchText == "" || video.genre.lowercased().contains(searchText.lowercased())
                case "Song":
                    return searchText == "" || video.songTitle.lowercased().contains(searchText.lowercased())
                default:
                    return searchText == ""
            }
        }
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchFiltered(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // MARK: - Clean up

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
} // end MusicVideoVC
