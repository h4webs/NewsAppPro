//
//  SlideMenuCustomCell.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 26/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class SlideMenuCustomCell: UITableViewCell
{
    @IBOutlet weak var imgview:UIImageView!
    @IBOutlet weak var lblname:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
