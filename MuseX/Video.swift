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
    
    fileprivate var _rank       = 0     // e.g. Top 10
    fileprivate var _songTitle  =   NO_STRING_FOUND
    fileprivate var _rights     =   NO_STRING_FOUND
    fileprivate var _price      =   NO_STRING_FOUND
    fileprivate var _imageURLs  =   [LOW_QUALITY    : NO_STRING_FOUND,
                                     MEDIUM_QUALITY : NO_STRING_FOUND,
                                     HIGH_QUALITY   : NO_STRING_FOUND]
    fileprivate var _artist     =   NO_STRING_FOUND
    fileprivate var _videoURL   =   NO_STRING_FOUND
    fileprivate var _mId        =   NO_STRING_FOUND
    fileprivate var _genre      =   NO_STRING_FOUND
    fileprivate var _iTunesURL  =   NO_STRING_FOUND
    fileprivate var _releaseDate =  NO_STRING_FOUND
    fileprivate var _image : UIImage?
    
 // Getters...
    
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

    var image: UIImage? { // holds downloaded image
        get {
//            if _image == nil {
//                return UIImage(contentsOfFile: "imageNotAvailable.jpeg")
//            }
            return _image
        }
    }
    
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

    // init with JSON Dictionary
    
    init(rank: Int, data: JSONDictionary) {
        self.rank = rank
        if let imName = data["im:name"] as? JSONDictionary,
            let label = imName["label"] as? String {
            _songTitle = label
        }
        
        if let rights = data["rights"] as? JSONDictionary,
            let label = rights["label"] as? String {
            _rights = label
        }
        
        if let imPrice = data["im:price"] as? JSONDictionary,
            let label = imPrice["label"] as? String {
            _price = label
        }
 
        if let imImage = data["im:image"] as? JSONArray,
            let image = imImage[2] as? JSONDictionary,
            let imageURL = image["label"] as? String {
            _imageURLs[LOW_QUALITY]     = imageURL
            _imageURLs[MEDIUM_QUALITY]  = imageURL.replacingOccurrences(of: "100x100", with: "300x300")
            _imageURLs[HIGH_QUALITY]    = imageURL.replacingOccurrences(of: "100x100", with: "600x600")
            queueImageFetch(imageView: nil)
        }

        if let imArtist = data["im:artist"] as? JSONDictionary,
            let label = imArtist["label"] as? String {
            _artist = label
        }
        
        if let link = data["link"] as? JSONArray,
            let url = link[1] as? JSONDictionary,
            let attributes = url["attributes"] as? JSONDictionary,
            let href = attributes["href"] as? String {
            _videoURL = href
        }
        
        if let imid = data["id"] as? JSONDictionary,
            let attributes = imid["attributes"] as? JSONDictionary,
            let label = attributes["im:id"] as? String {
            _mId = label
        }
        
        if let category = data["category"] as? JSONDictionary,
            let attributes = category["attributes"] as? JSONDictionary,
            let term = attributes["term"] as? String {
            _genre = term
        }
        
        if let mid = data["id"] as? JSONDictionary,
            let label = mid["label"] as? String {
            _iTunesURL = label
        }
        
        if let category = data["im:releaseDate"] as? JSONDictionary,
            let attributes = category["attributes"] as? JSONDictionary,
            let label = attributes["label"] as? String {
            _releaseDate = label
        }
        
    } // end init
    
    /**
     
     queueImageFetch
    
    */
    
    func queueImageFetch(imageView: UIImageView?) {
        
        if self._image == nil {
            networkQueue.async { [unowned self] in // download image data
                
                var imageQuality : String
                switch UserDefaults.standard.integer(forKey: UD_IMAGE_QUALITY) {
                    case 0: imageQuality = LOW_QUALITY
                    case 1: imageQuality = MEDIUM_QUALITY
                    case 2: imageQuality = HIGH_QUALITY
                    default:imageQuality = LOW_QUALITY
                }
                
                let data = NSData(contentsOf: NSURL(string: self.imageURLs[imageQuality]!)! as URL)
                if data != nil {
                    self._image = UIImage(data: data! as Data)
                } else {
                    self._image = UIImage(contentsOfFile: "imageNotAvailable.jpeg")
                }
            }
        }
        if imageView != nil {
            DispatchQueue.main.async(qos: .userInitiated) { [unowned self] in
                imageView?.image = self._image   // update UI
            }
        }
    }

}
