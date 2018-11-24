//
//  IConcernCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/23.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import Kingfisher

class IConcernCell: UICollectionViewCell,RegisterCellFromNib {

    @IBOutlet weak var tipsBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var iConcern = IConcern(){
        didSet{
            avatarImageView.kf.setImage(with: URL(string: (iConcern.icon)))
            nameLabel.text = iConcern.name
            vipImageView.isHidden = !iConcern.is_verify
            tipsBtn.isHidden = !iConcern.tips
            vipImageView.image = iConcern.user_auth_info.auth_type == 1 ? UIImage(named: "all_v_avatar_star_16x16_") : UIImage(named: "all_v_avatar_18x18_")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tipsBtn.layer.cornerRadius = 1
        tipsBtn.layer.theme_borderColor = "colors.cellBackgroundColor"
        self.theme_backgroundColor = "colors.cellBackgroundColor"
        tipsBtn.theme_backgroundColor = "colors.globalRedColor"
        nameLabel.theme_textColor = "colors.black"
    }

}
