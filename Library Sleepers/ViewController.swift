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
        
        //photoTitleLabel.text = ""
    }
    
    @IBAction func grabNewImage(_ sender: Any) {
        setUIEnabled(enabled: false)
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
        //let url = URL(string: )
    }
    /*
    func escapedParameters(parameters: [String:Any]) -> String {
        
    }
    */
}

