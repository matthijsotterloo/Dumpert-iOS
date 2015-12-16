//
//  Video.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import Foundation
import UIKit

class Video {
    
    var id: String
    var thumb: UIImage
    var title: String
    var brief: String
    var date: String
    var videoLinkLow: NSURL
    var videoLink: NSURL
    var tags = [String]()
    var views: Int
    var kudos: Int
    
    init(id: String, thumb: UIImage, title: String, brief: String, date: String, videoLinkLow: NSURL, videoLink: NSURL, tags: String, views: Int, kudos: Int){
        self.id = id
        self.thumb = thumb
        self.title = title
        self.brief = brief
        self.date = date
        self.videoLinkLow = videoLinkLow
        self.videoLink = videoLink
        self.tags = tags.componentsSeparatedByString(" ")
        self.views = views
        self.kudos = kudos
        
    }
    
}