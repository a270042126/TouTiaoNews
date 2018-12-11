//
//  UserDetailCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell,RegisterCellFromNib {
    
    @IBOutlet weak var scrollView: UIScrollView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
