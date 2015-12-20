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
    
}