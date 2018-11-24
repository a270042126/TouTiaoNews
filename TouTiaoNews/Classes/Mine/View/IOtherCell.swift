//
//  IOtherCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/23.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class IOtherCell: UITableViewCell,RegisterCellFromNib {
    
    @IBOutlet fileprivate weak var leftLabel: UILabel!
    @IBOutlet fileprivate weak var rightLabel: UILabel!
    @IBOutlet fileprivate weak var separatorView: UIView!
    @IBOutlet fileprivate weak var rightImageView: UIImageView!
    
    var cellModel:ICellModel?{
        didSet{
            leftLabel.text = cellModel?.text
            rightLabel.text = cellModel?.grey_text
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageView.theme_image = "images.cellRightArrow"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
