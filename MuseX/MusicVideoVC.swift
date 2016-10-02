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
            refreshControl?.attributedTitle = NSAttributedString(string: "Refresh unavailable while searching")
        } else {
            getVideos()
        }
    }
    
    var videos = [Video]()
    
    fileprivate struct StoryBoard {
        static let cellReuseIdentifier  = "customCell"
        static let segueIdentifier      = "videoDetail"
    }

    fileprivate var maxVideos: Int {
        get {
            // Set up refresh control text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
            let refreshDate = dateFormatter.string(from: Date())
            refreshControl?.attributedTitle = NSAttributedString(string: String(refreshDate))

            var maxVideos = Int(UserDefaults.standard.float(forKey: UD_TOP_X))
            if maxVideos < 1 || maxVideos > 199 { // iTunes API upper limit = 200
                maxVideos = MAX_VIDEOS_DEFAULT
                UserDefaults.standard.set(Float(maxVideos), forKey: UD_TOP_X)
            }
            return maxVideos
        }
    }

    fileprivate func initSearchController() {
        self.definesPresentationContext = true
        self.searchResultsController.dimsBackgroundDuringPresentation = false
        self.searchResultsController.hidesNavigationBarDuringPresentation = true
        self.searchResultsController.searchBar.barTintColor = UIColor.black
        self.searchResultsController.searchBar.placeholder = "Search"
        self.searchResultsController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        self.searchResultsController.searchBar.tintColor = UIColor.white
        self.searchResultsController.searchBar.scopeButtonTitles = ["All", "Artist", "Genre", "Song"]
        self.searchResultsController.searchBar.delegate = self
        self.searchResultsController.searchResultsUpdater = self     // delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchController()
        
        // Observers
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredFontChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        }
    
    func preferredFontChanged() {
        
    }
    
    fileprivate func getVideos() {
        
        JSONTask().deserializeVideos(
            "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(maxVideos)/json")
                { videos, errorMessage in
                
                    if errorMessage != "" {
                        let alert = UIAlertController(title: "Network problem", message: errorMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.videos = videos
                        self.tableView.reloadData()  // refresh tableView
                        self.title = "MuseX" // NavVC title appears on all nav pages as back link
                        //        for (index, video) in videos.enumerated() {
                        //            print("====> \(index + 1): \(video.artist)")
                        //        }
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
            cell.musicVideo = searchResults[(indexPath as NSIndexPath).row]
        } else {
            cell.musicVideo = videos[(indexPath as NSIndexPath).row]
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
    
    fileprivate var searchResults = [Video]()
    
    fileprivate let searchResultsController = UISearchController(searchResultsController: nil)
    // nil means display search results in same view
    
    // UISearchResultsUpdating protocol method
    func updateSearchResults(for searchController: UISearchController) {
        let scope =  searchResultsController.searchBar.scopeButtonTitles![searchResultsController.searchBar.selectedScopeButtonIndex]
        searchFiltered(searchResultsController.searchBar.text!, scope: scope)
    }
    
    fileprivate func searchFiltered(_ searchText: String, scope: String = "All") {
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
} // end MusicVideoVC
