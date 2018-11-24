//
//  OfflineDownlaodCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class OfflineDownlaodCell: UITableViewCell,RegisterCellFromNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleLabel.theme_textColor = "colors.black"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
