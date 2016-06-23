//
//  DownloadManager.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

class DownloadManager {
    
    func loadData(urlString: String, completion: [Video] -> Void) {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
//      let session = NSURLSession.sharedSession()
        let session = NSURLSession(configuration: config)
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
        
            (data, response, error) -> Void in

                if error != nil {
                        print(error!.localizedDescription)
                } else {
//                  print(data)
                    do {
                    /* .AllowFragments - top level object is NOT Array or Dictionary. Any type 
                           of string ot value. NJSONSerialization requires do-try-catch. It converts 
                           the NDData into a JSON obkect and casts it to a Dictionary.
                         */
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!,
                            options: .AllowFragments) as? JSONDictionary,
                            feed = json["feed"] as? JSONDictionary, // root record
                            entries = feed["entry"] as? JSONArray { // n entries
                            
                                var videos = [Video]()
                                for (index, entry) in entries.enumerate() {
                                    let entry = Video(rank: index + 1, data: entry as! JSONDictionary)
                                    videos.append(entry)
                                    }
                            
                                let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        completion(videos) // pass back videos array
                                    }
                                }
                            }
                    } catch {
                        print("NSJSONSerialization failed!")
                    }
                }
            }
        task.resume()  // else stays in suspended state
    }
}
