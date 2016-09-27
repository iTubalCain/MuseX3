//
//  DownloadManager.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

class DownloadManager {
    
    func loadData(_ urlString: String, completion: @escaping ([Video]) -> Void) {
        let config = URLSessionConfiguration.ephemeral
//      let session = NSURLSession.sharedSession()
        let session = URLSession(configuration: config)
        let url = URL(string: urlString)!
        
        let task = session.dataTask(with: url, completionHandler: {
        
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
                        if let json = try JSONSerialization.jsonObject(with: data!,
                            options: .allowFragments) as? JSONDictionary,
                            let feed = json["feed"] as? JSONDictionary, // root record
                            let entries = feed["entry"] as? JSONArray { // n entries
                            
                                var videos = [Video]()
                                for (index, entry) in entries.enumerated() {
                                    let entry = Video(rank: index + 1, data: entry as! JSONDictionary)
                                    videos.append(entry)
                                    }
                            
//                                  let priority = DispatchQueue.GlobalQueuePriority.high
//                                  DispatchQueue.global(priority: priority).async
                            DispatchQueue.global(qos: .utility).async
                                {
                                    DispatchQueue.main.async {
                                        completion(videos) // pass back videos array
                                    }
                                }
                            }
                    } catch {
                        print("NSJSONSerialization failed!")
                    }
                }
            }) 
        task.resume()  // else stays in suspended state
    }
}
