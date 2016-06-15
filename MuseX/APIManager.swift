//
//  APIManager.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString: String, completion: (result: String) -> Void) {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
//      let session = NSURLSession.sharedSession()
        let session = NSURLSession(configuration: config)
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
        
            (data, response, error) -> Void in

                if error != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: (error!.localizedDescription))
                    }
                } else {
//                  print(data)
                    do {
                        /* .AllowFragments - top level object is NOT Array or Dictionary. Any type of string ot value. NJSONSerialization requires do-try-catch. It converts the NDData into a JSON obkect and casts it to a Dcitoinary.
                         */
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!,
                            options: .AllowFragments) as? [String: AnyObject] {
                            print(json)
                            let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                            dispatch_async(dispatch_get_global_queue(priority, 0)) { 
                                dispatch_async(dispatch_get_main_queue()) {
                                    completion(result: ("NSJSONSerialization successful!"))
                                    }
                                }
                            }
                    } catch {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(result: ("NSJSONSerialization failed!"))
                        }
                    }
                }
        }
        task.resume()  // else stays in suspended state
    }
}
