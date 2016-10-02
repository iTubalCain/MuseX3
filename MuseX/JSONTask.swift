//
//  JSONSerializationTask.swift
//  MuseX
//
//  Created by Will on 6/14/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import UIKit

class JSONTask {
    
    enum JSON_Error: Error {
        case invalid (String, Any)
        case missing (String)
    }
    
/**
     
     Deserialize JSON from iTunes URL inot music video objects.
 
 */
    
    func deserializeVideos(_ iTunesURL: String, completion: @escaping ([Video], String) -> Void) {
        
        var videos = [Video]()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        let task = session.dataTask(with: URL(string: iTunesURL)!) { // define task
        
            (data, response, error) -> Void in

                if error != nil { // reports only client side errors
                    DispatchQueue.main.async(qos: .userInitiated) {
                        completion(videos, "URLSession task failed!")
                    }
                }
                else { // no error
                    // JSONSerialization requires do-try-catch. Converts NSData to a JSON object cast to a Dictionary.
                    do { // define task
                        if let json = try JSONSerialization.jsonObject(with: data!,
                                    options: .allowFragments) as? JSONDictionary,
                           let feed = json["feed"] as? JSONDictionary, // root record
                           let entries = feed["entry"] as? JSONArray { // get n entries
                            
//                                var videos = [Video]()
                                for (index, entry) in entries.enumerated() {
                                    let entry = Video(rank: index + 1, data: entry as! JSONDictionary)
                                    videos.append(entry)
                                    }
                            
                                DispatchQueue.main.async(qos: .userInitiated) { // [unowned self] in
                                    completion(videos, "") // pass back videos array into calling completion handler
                                }
                            }
                    }
                    catch {
                        DispatchQueue.main.async(qos: .userInitiated) {
                            completion(videos, "JSONSerialization failed!")
                        }
                    }
                }
            }
        task.resume()  // run task (else it remains in suspended state)
    }
    
}
