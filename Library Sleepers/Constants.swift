//
//  Constants.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

// MARK: - Constants

struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let orderedValues = [Method, APIKey, GalleryID, Extras, Format, NoJSONCallback]
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let APIKey = "91106059e4adb221703c6b0a1326a5ae" /*"YOUR API KEY HERE"*/
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let orderedValues = [GalleryPhotosMethod, APIKey, GalleryID, MediumURL, ResponseFormat, DisableJSONCallback]
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
