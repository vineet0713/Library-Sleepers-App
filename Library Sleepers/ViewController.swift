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
            if error == nil {
                // print(data!)
                if let data = data {
                    do {
                        let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        
                        if let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:Any] {
                            if let photoArray = photosDictionary ["photo"] as? [[String:Any]] {
                                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                                let photoDictionary = photoArray[randomPhotoIndex] as [String:Any]
                                
                                if let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String,
                                    let imageTitleString = photoDictionary[Constants.FlickrResponseKeys.Title] as? String {
                                    
                                    let imageURL = URL(string: imageURLString)
                                    if let imageData = try? Data(contentsOf: imageURL!) {
                                        performUIUpdatesOnMain {
                                            self.photoImageView.image = UIImage(data: imageData)
                                            self.photoTitleLabel.text = imageTitleString
                                            self.setUIEnabled(enabled: true)
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    } catch {
                        print("Could not parse the data as JSON: \(data)")
                        return
                    }
                }
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

