//
//  NoLoginHeaderView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/22.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class NoLoginHeaderView: UIView,NibLoadable{

    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var mobileBtn: UIButton!
    @IBOutlet private weak var wechatBtn: UIButton!
    @IBOutlet private weak var qqBtn: UIButton!
    @IBOutlet private weak var sinaBtn: UIButton!
    @IBOutlet private weak var moreLoginBtn: UIButton!
    @IBOutlet private weak var favoriteBtn: UIButton!
    @IBOutlet private weak var historyBtn: UIButton!
    @IBOutlet private weak var dayOrNightBtn: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

extension NoLoginHeaderView{
    
    fileprivate func setupUI(){
        dayOrNightBtn.isSelected = UserDefaults.standard.bool(forKey: isNight)
        
        let offectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        offectX.maximumRelativeValue = 20
        offectX.minimumRelativeValue = -20
        stackView.addMotionEffect(offectX)
        
        mobileBtn.theme_setImage("images.loginMobileButton", forState: .normal)
        wechatBtn.theme_setImage("images.loginWechatButton", forState: .normal)
        qqBtn.theme_setImage("images.loginQQButton", forState: .normal)
        sinaBtn.theme_setImage("images.loginSinaButton", forState: .normal)
        favoriteBtn.theme_setImage("images.mineFavoriteButton", forState: .normal)
        historyBtn.theme_setImage("images.mineHistoryButton", forState: .normal)
        dayOrNightBtn.theme_setImage("images.dayOrNightButton", forState: .normal)
        dayOrNightBtn.setTitle("夜间", for: .normal)
        dayOrNightBtn.setTitle("日间", for: .selected)
        moreLoginBtn.theme_backgroundColor = "colors.moreLoginBackgroundColor"
        moreLoginBtn.theme_setTitleColor("colors.moreLoginTextColor", forState: .normal)
        favoriteBtn.theme_setTitleColor("colors.black", forState: .normal)
        historyBtn.theme_setTitleColor("colors.black", forState: .normal)
        dayOrNightBtn.theme_setTitleColor("colors.black", forState: .normal)
        bottomView.theme_backgroundColor = "colors.cellBackgroundColor"
    }
    
    @IBAction func dayOrNightBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: isNight)
        ITheme.switchNight(sender.isSelected)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DayOrNightButtonClicked), object: sender.isSelected)
    }
}
