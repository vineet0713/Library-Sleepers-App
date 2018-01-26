//
//  ViewController.swift
//  Library Sleepers
//
//  Created by Vineet Joshi on 1/24/18.
//  Copyright © 2018 Vineet Joshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    var currentImageIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        photoTitleLabel.text = ""
    }
    
    @IBAction func grabNewImage(_ sender: Any) {
        setUIEnabled(enabled: false)
        // testEscapedParameters()
        getImageFromFlickr()
    }
    
    func setUIEnabled(enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        grabImageButton.isEnabled = enabled
        grabImageButton.alpha = (enabled) ? 1.0 : 0.5
        /*
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
        */
    }
    
    private func getImageFromFlickr() {
        let keys = Constants.FlickrParameterKeys.orderedValues
        let values = Constants.FlickrParameterValues.orderedValues
        
        var methodParameters: [String:String] = [:]
        for i in 0..<keys.count {
            methodParameters[keys[i]] = values[i]
        }
        
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(parameters: methodParameters)
        let url = URL(string: urlString)!
        
        // create a URLRequest from a URL (which allows us to have access to more request options)
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("There was an error with your request.")
                return
            }
            
            // check for HTTP response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (statusCode >= 200 && statusCode <= 299) else {
                print("Your request returned a status code other than 2xx.")
                return
            }
            
            guard let data = data else {
                print("No data was returned.")
                return
            }
            
            var parsedResult: [String:Any]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            } catch {
                print("Could not parse the data as JSON: \(data)")
                return
            }
            
            // check if Flickr returned an error
            guard let flickrStatus = parsedResult[Constants.FlickrResponseKeys.Status] as? String, flickrStatus == Constants.FlickrResponseValues.OKStatus else {
                print("Flickr API returned an error.")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:Any] else {
                print("Could not find key \(Constants.FlickrResponseKeys.Photos).")
                return
            }
            
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:Any]] else {
                print("Could not find key \(Constants.FlickrResponseKeys.Photo).")
                return
            }
            
            // makes sure that the newly displayed image will be different than current one:
            var randomPhotoIndex = self.currentImageIndex
            while randomPhotoIndex == self.currentImageIndex {
                randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            }
            self.currentImageIndex = randomPhotoIndex
            
            let photoDictionary = photoArray[randomPhotoIndex] as [String:Any]
            
            guard let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
                print("Could not find key \(Constants.FlickrResponseKeys.MediumURL).")
                return
            }
            
            guard let imageTitleString = photoDictionary[Constants.FlickrResponseKeys.Title] as? String else {
                print("Could not find key \(Constants.FlickrResponseKeys.Title).")
                return
            }
            
            let imageURL = URL(string: imageURLString)
            guard let imageData = try? Data(contentsOf: imageURL!) else {
                print("Could not get image data.")
                return
            }
            
            performUIUpdatesOnMain {
                self.photoImageView.image = UIImage(data: imageData)
                self.photoTitleLabel.text = imageTitleString
                self.setUIEnabled(enabled: true)
            }
        }
        
        task.resume()
    }
    
    func testEscapedParameters() {
        let exampleParameters: [String:String] = ["course": "networking",
                                                  "nanodegree": "iOS",
                                                  "quiz": "escaping parameters"]
        print(escapedParameters(parameters: exampleParameters))
    }
    
    func escapedParameters(parameters: [String:Any]) -> String {
        if parameters.isEmpty {
            return ""
        }
        
        var keyValuePairs: [String] = []
        
        for (key, value) in parameters {
            // assume that 'key' will always have safe ASCII characters
            
            // convert 'value' to a String (if it isn't already)
            let stringValue = "\(value)"
            
            // convert stringValue to an ASCII-compliant version of that String
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            // append this to the array
            keyValuePairs.append(key + "=" + escapedValue!)
        }
        
        let allKeyValuePairs = keyValuePairs.joined(separator: "&")
        return ("?" + allKeyValuePairs)
    }
    
}

