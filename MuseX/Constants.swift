//
//  Constants.swift
//  MuseX
//
//  Created by Will on 6/15/16.
//  Copyright © 2016 Will Wagers. All rights reserved.
//

import Foundation

// Constants

let NO_STRING_FOUND = "-none-"

let MAX_VIDEOS_DEFAULT = 10

// imageURLS array indices
let LOW_QUALITY     = "LOW_QUALITY"
let MEDIUM_QUALITY  = "MEDIUM_QUALITY"
let HIGH_QUALITY    = "HIGH_QUALITY"

// Globals

typealias JSONArray = [AnyObject]
typealias JSONDictionary = [String: AnyObject]

// Queues

let networkQueue = DispatchQueue(label: "io.xamples.network",
                                 qos: .userInitiated,
                                 target: nil)

// structs

// UserDefaults keys

let UD_EXPLICIT_CONTENT = "Settings: Explicit Content"
let UD_IMAGE_QUALITY    = "Settings: Image Quality"
let UD_TOP_X            = "Settings: Top x"


