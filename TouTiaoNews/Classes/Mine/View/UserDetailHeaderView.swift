//
//  UserDetailHeaderView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/27.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable
import SnapKit

class UserDetailHeaderView: UIView,NibLoadable {
    
    /// 背景图片
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bgImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var toutiaohaoImageView: UIImageView!
    @IBOutlet weak var sendMailButton: UIButton!
    @IBOutlet weak var concernButton: UIButton!
    @IBOutlet weak var recommendButton: AnimatableButton!
    @IBOutlet weak var recommendButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var recommendButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendViewHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabel: UILabel!
    @IBOutlet weak var verifiedAgencyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabelTop: NSLayoutConstraint!
    @IBOutlet weak var verifiedContentLabel: UILabel!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var areaButtonTop: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    fileprivate lazy var relationRecommendView: RelationRecommendView = { [unowned self] in
        let relationRecommendView = RelationRecommendView.loadViewFormNib()
        return relationRecommendView
    }()
    
    /// 点击了关注按钮
    var didSelectConcernButton: (()->())?
    /// 点击了用户名
    var didSelectUserName: ((_ uid: Int)->())?
    
    var didAvatarButtonClicked: (() -> ())?
    
    var oldHeight:CGFloat = 0
    
    var userDetail = UserDetail(){
        didSet{
            backgroundImageView.kf.setImage(with: URL(string: userDetail.bg_img_url))
            avatarImageView.kf.setImage(with: URL(string: userDetail.avatar_url))
            vImageView.isHidden = !userDetail.user_verified
            nameLabel.text = userDetail.screen_name
            if userDetail.verified_agency == ""{
                verifiedAgencyLabelHeight.constant = 0
                verifiedAgencyLabelTop.constant = 0
            }else{
                verifiedAgencyLabel.text = userDetail.verified_agency + "："
                verifiedContentLabel.text = userDetail.verified_content
            }
            concernButton.isSelected = userDetail.is_following
            concernButton.theme_backgroundColor = userDetail.is_following ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.globalRedColor"
            concernButton.layer.borderColor = userDetail.is_following ? UIColor.grayColor232().cgColor : UIColor.globalRedColor().cgColor
            concernButton.layer.borderWidth =  userDetail.is_following ? 1 : 0
            if userDetail.area != ""{
                areaButtonHeight.constant = 20
                areaButtonTop.constant = 10
                areaButton.setTitle(userDetail.area, for: .normal)
            }
            descriptionLabel.attributedText = userDetail.attributedDescription
            if userDetail.descriptionHeight > 21{
                unfoldButton.isHidden = false
                unfoldButtonWidth.constant = 40.0
            }
            
             // 推荐按钮的约束
            recommendButtonWidth.constant = 0
            recommendButtonTrailing.constant = 10.0
            followersCountLabel.text = userDetail.followersCount
            followingsCountLabel.text = userDetail.followingsCount
            layoutIfNeeded()
            
            self.oldHeight = height
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置图片顶部约束
        bgImageViewTop.constant = isIPhoneX ? -88 : -64
        layoutIfNeeded()
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        //设置主题颜色
        theme_backgroundColor = "colors.cellBackgroundColor"
        baseView.theme_backgroundColor = "colors.cellBackgroundColor"
        avatarImageView.layer.theme_borderColor = "colors.cellBackgroundColor"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        nameLabel.theme_textColor = "colors.black"
        sendMailButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
        unfoldButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
        followersCountLabel.theme_textColor = "colors.userDetailSendMailTextColor"
        followingsCountLabel.theme_textColor = "colors.userDetailSendMailTextColor"
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
        verifiedAgencyLabel.theme_textColor = "colors.verifiedAgencyTextColor"
        verifiedContentLabel.theme_textColor = "colors.black"
        descriptionLabel.theme_textColor = "colors.black"
        descriptionLabel.theme_textColor = "colors.black"
        toutiaohaoImageView.theme_image = "images.toutiaohao"
        areaButton.theme_setTitleColor("colors.black", forState: .normal)
         NotificationCenter.default.addObserver(self, selector: #selector(receivedConcernButtonClicked), name: NSNotification.Name(rawValue: NavigationBarConcernButtonClicked), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func avatarButtonClicked(_ sender: UIButton) {
        self.didAvatarButtonClicked?()
    }
    
    @IBAction func sendMailButtonClicked(_ sender: UIButton) {
        let loginVC = MoreLoginViewController.loadStoryboard()
        loginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - (isIPhoneX ? 44 : 20))))
        UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func concerButtonClicked(_ sender: UIButton) {
        let userDetailVM = UserDetailViewModel()
        if sender.isSelected{
            userDetailVM.loadRelationUnfollow(userId: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.globalRedColor"
                self.recommendButton.isHidden = true
                self.recommendButton.isSelected = false
                self.recommendButtonWidth.constant = 0
                self.recommendButtonTrailing.constant = 0
                self.recommendViewHeight.constant = 0
                //判断是否已添加
                if self.relationRecommendView.isDescendant(of: self.recommendView){
                    self.relationRecommendView.removeFromSuperview()
                }
                if self.height > self.oldHeight{
                    self.height -= 233
                }
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.recommendButton.imageView?.transform = .identity
                    self.layoutIfNeeded()
                    self.didSelectConcernButton?()
                })
                NotificationCenter.default.post(name: NSNotification.Name(UserDetailHeaderViewButtonClicked), object: nil, userInfo: ["isSelected": sender.isSelected])
            }
        }else{
            userDetailVM.loadRelationFollow(userId: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                sender.layer.borderColor = UIColor.grayColor232().cgColor
                sender.layer.borderWidth = 1
                self.recommendButton.isHidden = false
                self.recommendButton.isSelected = false
                self.recommendButtonWidth.constant = 28.0
                self.recommendButtonTrailing.constant = 15.0
                self.recommendViewHeight.constant = 233
                if self.height <= self.oldHeight{
                    self.height += 233
                }
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.layoutIfNeeded()
                    self.didSelectConcernButton?()
                }, completion: { (_) in
                    userDetailVM.loadRelationUserRecommend(userId: self.userDetail.user_id, completionHandler: { (userCards) in
                        self.recommendView.addSubview(self.relationRecommendView)
                        self.relationRecommendView.snp.makeConstraints({ (make) in
                            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
                        })
                        self.relationRecommendView.userCards = userCards
                    })
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserDetailHeaderViewButtonClicked), object: self, userInfo: ["isSelected": sender.isSelected])
                })
            }
        }
    }
    
    @IBAction func recommendButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        relationRecommendView.labelHeight.constant = sender.isSelected ? 0 : 32.0
        recommendViewHeight.constant = sender.isSelected ? 0 : 233.0
        UIView.animate(withDuration: 0.25) {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(sender.isSelected ? Double.pi : 0))
            self.layoutIfNeeded()
            self.relationRecommendView.layoutIfNeeded()
            self.didSelectConcernButton?()
        }
    }
    
    @IBAction func unfoldButtonClicked(_ sender: UIButton) {
        unfoldButton.isHidden = true
        unfoldButtonWidth.constant = 0
        relationRecommendView.labelHeight.constant = 0
        relationRecommendView.layoutIfNeeded()
        descriptionLabelHeight.constant = userDetail.descriptionHeight
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.didSelectConcernButton?()
        }
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
//        height = baseView.frame.maxY
//        print(height)
    }
}

extension UserDetailHeaderView{
    
     /// 接收到了关注按钮的点击
    @objc func receivedConcernButtonClicked(notification:NSNotification){
        let userInfo = notification.userInfo as! [String: Any]
        let isSelected = userInfo["isSelected"] as! Bool
        concernButton.isSelected = isSelected
        concernButton.theme_backgroundColor = isSelected ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.globalRedColor"
        concernButton.layer.borderColor = isSelected ? UIColor.grayColor232().cgColor : UIColor.globalRedColor().cgColor
        concernButton.layer.borderWidth = isSelected ? 1 : 0
    }
}
