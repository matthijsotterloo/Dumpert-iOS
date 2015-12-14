//
//  Image.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import Foundation
import UIKit

class Image {
    
    internal class func downloadImage(url: NSURL, completion: ((image: UIImage?) -> Void)){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                
                //Check if data contains image
                if UIImage(data: data!) != nil {
                    
                    completion(image: UIImage(data: data!)!)
                    
                } else {
                    
                    completion(image: UIImage(named: "Default.jpg")!)
                    //completion(image: "default")
                    
                }
                
                
            }
        }

    }
    
    private class func getDataFromUrl(fileUrl:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(fileUrl) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
}