//
//  ChannelRecommendCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit



class ChannelRecommendCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleButton.theme_backgroundColor = "colors.cellBackgroundColor"
        titleButton.theme_setImage("images.add_channel_titlbar_thin_new_16x16_", forState: .normal)
        layer.cornerRadius = 3
        titleButton.layer.shadowColor = UIColor(r: 240, g: 240, b: 240).cgColor
        //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        titleButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleButton.layer.shadowOpacity = 1 //阴影透明度，默认0
        titleButton.layer.shadowRadius = 1 //阴影半径，默认3
        titleButton.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        titleButton.isUserInteractionEnabled = false
    }

    
}
