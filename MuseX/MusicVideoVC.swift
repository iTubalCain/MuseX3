//
//  MusicVideoVC.swift
//  MuseX
//
//  Created by Will on 6/16/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class MusicVideoVC: UITableViewController {

    var videos = [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
        //      print(reachabilityStatus)
        
    }
    
    func runAPI() {
        let api = APIManager()
        api.loadData(ITUNES_URL, completion: didLoadData)
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
            
////            displayLabel.text = NO_ACCESS
//        case WIFI:
//            view.backgroundColor = UIColor.greenColor()
////            displayLabel.text = WIFI
//        case WWAN:
//            view.backgroundColor = UIColor.yellowColor()
////            displayLabel.text = WWAN
        default:
            view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("Do not refresh API") // data already loaded
            } else {
                runAPI()
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...

        let video = videos[indexPath.row]
        cell.textLabel?.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.title

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
