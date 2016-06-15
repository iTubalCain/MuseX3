//
//  Video.swift
//  MuseX
//
//  Created by Will on 6/15/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

class Videos {
    
    let NO_STRING_FOUND = "-none-"
    
    private var _title:      String
//    private var _rights:     String // rights / label
//    private var _price:      String // price / label
//    private var _imageURL:   String
//    private var _artist:     String // im:artist / label
//    private var _videoURL:   String
//    private var _id:         String //id / attributes / im:id
//    private var _genre:      String // category / attributes / term
//    private var _iTunesURL:  String // id / label
//    private var _releaseDate:String // im:releaseDate / attributes / label
    
    var title:    String { return self.title }
    var imageURL: String { return self.imageURL }
    var videoURL: String { return self.videoURL }
    
    init(data: JSONDictionary){
        
        if let name = data["im:name"] as? JSONDictionary,
            tempTitle = name["label"] as? String {
            _title = tempTitle
        } else {
            _title = NO_STRING_FOUND
        }
        
//        if let img = data["im:image"] as? JSONArray,
//            image = img[2] as? JSONDictionary,
//            immage = image["label"] as? String {
//            imageURL = immages.stringByReplacingOccurencesOfString("100x100", withString"600x600")
//                } else {
//                    imageURL = NO_STRING_FOUND
//                }
//
//        
//        if let video = data["link"] as? JSONArray,
//            url = video[1] as? JSONDictioanry,
//            attributes = url["attributes"] as? JSONDictioanry,
//            self.videoURL = attributes["href"] as? String {
//            
//            =
//        } else {
//            self.videoURL = NO_STRING_FOUND
//        }
        
        print("Title: " + _title)

    }
    
}
