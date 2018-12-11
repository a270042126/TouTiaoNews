//
//  RelationRecommendCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable

class RelationRecommendCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recomendReasonLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var baseView: UIView!
    
    var userCard = UserCard(){
        didSet{
            nameLabel.text = userCard.user.info.name
            avatarImageView.kf.setImage(with: URL(string: userCard.user.info.avatar_url)!)
            vImageView.isHidden = userCard.user.info.user_auth_info.auth_info == ""
            recomendReasonLabel.text = userCard.recommend_reason
        }
    }
    
    private lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 1.5
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        nameLabel.theme_textColor = "colors.black"
        recomendReasonLabel.theme_textColor = "colors.black"
        theme_backgroundColor = "colors.cellBackgroundColor"
        baseView.theme_backgroundColor = "colors.cellBackgroundColor"
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
    }

    @IBAction func concerButtonClicked(_ sender: UIButton) {
        print("concerButtonClicked")
        loadingImageView.isHidden = false
        loadingImageView.layer.add(animation, forKey: nil)
        
        let userDetailVM = UserDetailViewModel()
        if sender.isSelected{// 已经关注，点击则取消关注
            // 已关注用户，取消关注
            userDetailVM.loadRelationUnfollow(userId: userCard.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.globalRedColor"
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                sender.layer.borderWidth = 0
            }
        }else{
            userDetailVM.loadRelationFollow(userId: userCard.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                sender.layer.borderColor = UIColor.grayColor232().cgColor
                sender.layer.borderWidth = 1
            }
            
        }
    }
    
}
