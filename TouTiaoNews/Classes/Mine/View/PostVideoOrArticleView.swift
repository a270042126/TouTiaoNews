//
//  PostVideoOrArticleView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class PostVideoOrArticleView: UIView, NibLoadable {
    
   
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 原内容是否已经删除
    var delete = false {
        didSet {
            originContentHasDeleted()
        }
    }
    
    var group = DongtaiOriginGroup(){
        didSet{
            titleLabel.text = " " + group.title
            if group.thumb_url != "" {
                iconButton.kf.setBackgroundImage(with: URL(string: group.thumb_url), for: .normal)
            }else if group.user.avatar_url != "" {
                iconButton.kf.setBackgroundImage(with: URL(string: group.user.avatar_url)!, for: .normal)
            } else if group.delete {
                originContentHasDeleted()
            }
            switch group.media_type {
            case .postArticle:
                iconButton.setImage(nil, for: .normal)
            case .postVideo:
                iconButton.theme_setImage("images.smallvideo_all_32x32_", forState: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleLabel.theme_textColor = "colors.black"
        titleLabel.theme_backgroundColor = "colors.grayColor247"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        width = screenWidth - 30
    }
    
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 原内容已经删除
    func originContentHasDeleted() {
        titleLabel.text = "原内容已经删除"
        titleLabel.textAlignment = .center
        iconButtonWidth.constant = 0
        layoutIfNeeded()
    }
}
