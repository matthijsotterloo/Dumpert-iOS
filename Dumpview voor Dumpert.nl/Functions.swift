//
//  Functions.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 21-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import Foundation

class Functions {
    
    internal class func convertDateFormater(date: String) -> String
    {
        
        //print(date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        //dateFormatter.timeZone = NSTimeZone(name: "+1")
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
        //print(date)
        //return date
    }
    
}