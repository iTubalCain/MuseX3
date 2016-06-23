//
//  Video.swift
//  MuseX
//
//  Created by Will on 6/15/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import AVKit
import Foundation

class Video {
    
    private var _rank       = 0     // e.g. Top 10
    private var _songTitle  =   NO_STRING_FOUND
    private var _rights     =   NO_STRING_FOUND
    private var _price      =   NO_STRING_FOUND
    private var _imageURLs  =   [LOW_QUALITY : NO_STRING_FOUND,
                                 MEDIUM_QUALITY : NO_STRING_FOUND,
                                 HIGH_QUALITY   : NO_STRING_FOUND]
    private var _artist     =   NO_STRING_FOUND
    private var _videoURL   =   NO_STRING_FOUND
    private var _mId        =   NO_STRING_FOUND
    private var _genre      =   NO_STRING_FOUND
    private var _iTunesURL  =   NO_STRING_FOUND
    private var _releaseDate =  NO_STRING_FOUND
    
    private var _imageData  :   NSData?
    private var _image      :   UIImage?
    
 // Getters...
    
    var rank: Int {
        get {
            return _rank
            }
        set {
            if (newValue > 0) && (rank < newValue) {
                _rank = newValue
            }
        }
    }
    var songTitle:      String   { return _songTitle }
    var rights:         String   { return _rights }
    var price:          String   { return _price }
    var imageURLs:      [String : String] { return _imageURLs }
    var artist:         String   { return _artist }
    var videoURL:       String   { return _videoURL }
    var mId:            String   { return _mId }
    var genre:          String   { return _genre }
    var iTunesURL:      String   { return _iTunesURL }
    var releaseDate:    String   { return _releaseDate }

    var imageData: NSData? { // holds downloaded image data
        get {
            return _imageData
        }
        set {
            _imageData = newValue
        }
    }
    
    var image: UIImage? { // holds downloaded image
        get {
            return _image
        }
        set {
            _image = newValue
        }
    }
/// init with JSON Dictionary
    
    init(rank: Int, data: JSONDictionary){
        self.rank = rank
        if let imName = data["im:name"] as? JSONDictionary,
            label = imName["label"] as? String {
            _songTitle = label
        }
        
        if let rights = data["rights"] as? JSONDictionary,
            label = rights["label"] as? String {
            _rights = label
        }
        
        if let imPrice = data["im:price"] as? JSONDictionary,
            label = imPrice["label"] as? String {
            _price = label
        }
 
        // TODO: use 300x300 if low quality or cellular
        
        if let imImage = data["im:image"] as? JSONArray,
            image = imImage[2] as? JSONDictionary,
            imageURL = image["label"] as? String {
            _imageURLs[LOW_QUALITY]     = imageURL
            _imageURLs[MEDIUM_QUALITY]  = imageURL.stringByReplacingOccurrencesOfString("100x100", withString: "300x300")
            _imageURLs[HIGH_QUALITY]    = imageURL.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        }

    if let imArtist = data["im:artist"] as? JSONDictionary,
            label = imArtist["label"] as? String {
            _artist = label
        }
        
        if let link = data["link"] as? JSONArray,
            url = link[1] as? JSONDictionary,
            attributes = url["attributes"] as? JSONDictionary,
            href = attributes["href"] as? String {
            _videoURL = href
        }
        
        if let imid = data["id"] as? JSONDictionary,
            attributes = imid["attributes"] as? JSONDictionary,
            label = attributes["im:id"] as? String {
            _mId = label
        }
        
        if let category = data["category"] as? JSONDictionary,
            attributes = category["attributes"] as? JSONDictionary,
            term = attributes["term"] as? String {
            _genre = term
        }
        
        if let mid = data["id"] as? JSONDictionary,
            label = mid["label"] as? String {
            _iTunesURL = label
        }
        
        if let category = data["im:releaseDate"] as? JSONDictionary,
            attributes = category["attributes"] as? JSONDictionary,
            label = attributes["label"] as? String {
            _releaseDate = label
        }
        
    }
    
}
