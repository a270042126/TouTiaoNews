//
//  UserDetailNavigationBar.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/27.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable
import RxSwift
import RxCocoa

class UserDetailNavigationBar: UIView,NibLoadable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var concernButton: AnimatableButton!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationBarTop: NSLayoutConstraint!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var userDetail = UserDetail(){
        didSet{
            nameLabel.text = userDetail.screen_name
            concernButton.isSelected = userDetail.is_following
            concernButton.theme_backgroundColor = userDetail.is_following ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.globalRedColor"
            concernButton.borderColor = userDetail.is_following ? .grayColor232() : .globalRedColor()
            concernButton.borderWidth = userDetail.is_following ? 1 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        returnButton.theme_setImage("images.personal_home_back_white_24x24_", forState: .normal)
        moreButton.theme_setImage("images.new_morewhite_titlebar_22x22_", forState: .normal)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedConcernButtonClicked), name: NSNotification.Name(rawValue: UserDetailHeaderViewButtonClicked), object: nil)
        navigationBarTop.constant = isIPhoneX ? -44 : -20
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize{
        return UIView.layoutFittingExpandedSize
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        navigationBar.width = screenWidth
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        moreButton.x = screenWidth - 35
    }
    
    @IBAction func concernButtonClicked(_ sender: UIButton) {
        let userDetailVM = UserDetailViewModel()
        if sender.isSelected {
            userDetailVM.loadRelationUnfollow(userId: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.globalRedColor"
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: NavigationBarConcernButtonClicked), object: self, userInfo: ["isSelected": sender.isSelected])
            }
        }else{
            userDetailVM.loadRelationFollow(userId: userDetail.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                sender.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NavigationBarConcernButtonClicked), object: self, userInfo: ["isSelected": sender.isSelected])
            }
        }
    }
    
}

extension UserDetailNavigationBar{
    
    @objc func receivedConcernButtonClicked(notification: Notification){
        let userInfo = notification.userInfo as! [String: Any]
        let isSelected = userInfo["isSelected"] as! Bool
        concernButton.isSelected = isSelected
        concernButton.theme_backgroundColor = isSelected ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.globalRedColor"
        concernButton.borderColor = isSelected ? .grayColor232() : .globalRedColor()
        concernButton.borderWidth = isSelected ? 1 : 0
    }
}
