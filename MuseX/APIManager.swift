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
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
        
            (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    completion(result: (error!.localizedDescription))
                } else {
                    completion(result: "NSURLSession successful!")
                    print(data)
                }
            }
        }
        task.resume()  // else stays in suspended state
    }
}
