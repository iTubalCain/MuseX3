//
//  Video.swift
//  MuseX
//
//  Created by Will on 6/15/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

class Video {
    
    let NO_STRING_FOUND = "-none-"
    
    var rank = 0    // e.g. Top 10
    
    private var _title:      String
    private var _rights:     String
    private var _price:      String
    private var _imageURL:   String
    private var _artist:     String
    private var _videoURL:   String
    private var _mId:        String
    private var _genre:      String
    private var _iTunesURL:  String
    private var _releaseDate:String
    
 // Getters...
    
    var title:      String { return _title }
    var rights:     String { return _rights }
    var price:      String { return _price }
    var imageURL:   String { return _imageURL }
    var artist:     String { return _artist }
    var videoURL:   String { return _videoURL }
    var mId:        String { return _mId }
    var genre:      String { return _genre }
    var iTunesURL:  String { return _iTunesURL }
    var releaseDate:String { return _releaseDate }
    
    var imageData: NSData?  // holds downloaded image
    
/// init with JSON Dictionary
    
    init(data: JSONDictionary){
        
        if let imName = data["im:name"] as? JSONDictionary,
            label = imName["label"] as? String {
            _title = label
        } else {
            _title = NO_STRING_FOUND
        }
        
        if let rights = data["rights"] as? JSONDictionary,
            label = rights["label"] as? String {
            _rights = label
        } else {
            _rights = NO_STRING_FOUND
        }
        
        if let imPrice = data["im:price"] as? JSONDictionary,
            label = imPrice["label"] as? String {
            _price = label
        } else {
            _price = NO_STRING_FOUND
        }
        
        if let imImage = data["im:image"] as? JSONArray,
            image = imImage[2] as? JSONDictionary,
            image2 = image["label"] as? String {
                _imageURL = image2.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        } else {
            _imageURL = NO_STRING_FOUND
        }

        if let imArtist = data["im:artist"] as? JSONDictionary,
            label = imArtist["label"] as? String {
            _artist = label
        } else {
            _artist = NO_STRING_FOUND
        }
        
        if let link = data["link"] as? JSONArray,
            url = link[1] as? JSONDictionary,
            attributes = url["attributes"] as? JSONDictionary,
            href = attributes["href"] as? String {
                _videoURL = href
        } else {
            _videoURL = NO_STRING_FOUND
        }

        if let imid = data["id"] as? JSONDictionary,
            attributes = imid["attributes"] as? JSONDictionary,
            label = attributes["im:id"] as? String {
            _mId = label
        } else {
            _mId = NO_STRING_FOUND
        }
        
        if let category = data["category"] as? JSONDictionary,
            attributes = category["attributes"] as? JSONDictionary,
            term = attributes["term"] as? String {
            _genre = term
        } else {
            _genre = NO_STRING_FOUND
        }
        
        if let mid = data["id"] as? JSONDictionary,
            label = mid["label"] as? String {
            _iTunesURL = label
        } else {
            _iTunesURL = NO_STRING_FOUND
        }
        
        if let category = data["im:releaseDate"] as? JSONDictionary,
            attributes = category["attributes"] as? JSONDictionary,
            label = attributes["label"] as? String {
            _releaseDate = label
        } else {
            _releaseDate = NO_STRING_FOUND
        }

    }
    
}
