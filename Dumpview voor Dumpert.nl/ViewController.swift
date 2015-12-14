//
//  ViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var parser = NSXMLParser()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(DumpertApi.getRecentVideos(30))
        //print(DumpertApi.getRecentImages(30))
        //print(DumpertApi.getRelated("6702966_7955f767", paramInt: 10))
        //print(DumpertApi.getItemMetaUrl("6702966_7955f767"))
        
        let data = DumpertApi.getXML(DumpertApi.getRecentVideos(30))
        
        //XmlParser.beginParsing()
        //print(XmlParser.posts)
        
        let xml = SWXMLHash.parse(data!)
        
        //print(xml)
        //print(xml["videos"]["video"][0]["id"].element?.text)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

