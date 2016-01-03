//
//  Comments.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 17-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import Foundation

class Comment {
    
    var id: String
    var text: String
    var author: String
    
    init(id: String, text: String, author: String){
        self.id = id
        self.text = text
        self.author = author
    }
    
    
    internal class func xmlCommentParse(data: NSData){
        let xml = SWXMLHash.parse(data)
        
        if(xml["comments"]){
            for video in xml["videos"]["video"] {
                if(!video["nsfw"]){
                    Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                        
                        let id = video["id"].element!.text!
                        let thumb = image
                        let title = video["title"].element!.text!
                        let brief = video["brief"].element!.text!
                        let date = Functions.convertDateFormater(video["date"].element!.text!)
                        let videoLinkLow = NSURL(string: video["videoLinkLow"].element!.text!)
                        let videoLink = NSURL(string: video["videoLink"].element!.text!)
                        
                        var tags = ""
                        
                        if(video["tags"]){
                            tags = video["tags"].element!.text!
                        }
                        
                        var views = video["views"].element!.text!
                        let kudos = video["kudos"].element!.text!
                        
                        // If more then 1.000 views switch to K.
                        if(Double(views) >= 10000){
                            views = String(round(Double(views)!/1000.0)/10.0) + "K"
                        }
                        
//                        videoCount++
                        videos.append(Video(id: id, thumb: thumb!, title: title, brief: brief, date: date, videoLinkLow: videoLinkLow!, videoLink: videoLink!, tags: tags, views: views, kudos: kudos))
                        videos.sort { $0.id < $1.id }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                    })
                } else {
//                    videoCount = videoCount - 1
                }
            }
            
        }
    }
    
}