//
//  MoreLoginViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable

class MoreLoginViewController: AnimatableModalViewController,StoryboardLoadable {

    @IBOutlet weak var loginCloseBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mobileView: AnimatableView!
    @IBOutlet weak var passwordView: AnimatableView!
    @IBOutlet weak var sendVerifyView: UIView!
    @IBOutlet weak var findPasswordView: UIView!
    @IBOutlet weak var sendVerifyBtn: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var findPasswordBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var middleTipLabel: UILabel!
    @IBOutlet weak var enterTouTiaoBtn: AnimatableButton!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var loginModeBtn: UIButton!
    @IBOutlet weak var wechatLoginBtn: UIButton!
    @IBOutlet weak var qqLoginBtn: UIButton!
    @IBOutlet weak var tianyiLoginBtn: UIButton!
    @IBOutlet weak var mailLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        loginModeBtn.setTitle("免密码登录", for: .selected)
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        topLabel.theme_textColor = "colors.black"
        middleTipLabel.theme_textColor = "colors.cellRightTextColor"
        readLabel.theme_textColor = "colors.black"
        enterTouTiaoBtn.theme_backgroundColor = "colors.enterToutiaoBackgroundColor"
        enterTouTiaoBtn.theme_setTitleColor("colors.enterToutiaoTextColor", forState: .normal)
        readBtn.theme_setImage("images.loginReadButton", forState: .selected)
        readBtn.theme_setImage("images.loginReadButtonSelected", forState: .normal)
        mobileView.theme_backgroundColor = "colors.loginMobileViewBackgroundColor"
        passwordView.theme_backgroundColor = "colors.loginMobileViewBackgroundColor"
        loginCloseBtn.theme_setImage("images.loginCloseButtonImage", forState: .normal)
        wechatLoginBtn.theme_setImage("images.moreLoginWechatButton", forState: .normal)
        qqLoginBtn.theme_setImage("images.moreLoginQQButton", forState: .normal)
        tianyiLoginBtn.theme_setImage("images.moreLoginTianyiButton", forState: .normal)
        mailLoginBtn.theme_setImage("images.moreLoginMailButton", forState: .normal)
    }
    
    
    @IBAction func loginModeBtnClicked(_ sender: UIButton) {
        loginModeBtn.isSelected = !sender.isSelected
        sendVerifyView.isHidden = sender.isSelected
        findPasswordView.isHidden = !sender.isSelected
        middleTipLabel.isHidden = sender.isSelected
        passwordTextField.placeholder = sender.isSelected ? "密码" : "请输入验证码"
        topLabel.text = sender.isSelected ? "帐号密码登录" : "登录你的头条，精彩永不消失"
    }
    
    @IBAction func readBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func loginCloseBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
