//
//  TableViewCell.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 16-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    @IBOutlet var kudos: UILabel!
    @IBOutlet var views: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var thumb: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
