//
//  LatestCustoCell.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 31/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class LatestCustoCell: UICollectionViewCell
{
    @IBOutlet var imgView : UIImageView?
    @IBOutlet var lbltitle : UILabel?
    @IBOutlet var lbldesc : UILabel?
    @IBOutlet var lbldate : UILabel?
    @IBOutlet var lblviews : UILabel?
    @IBOutlet var lblshare : UILabel?
    @IBOutlet var txtdesc : UITextView?
    @IBOutlet var btnplay : UIButton?
    @IBOutlet var btnfavourite : UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
