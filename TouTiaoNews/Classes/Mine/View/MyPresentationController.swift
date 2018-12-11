//
//  MyPresentationController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/27.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class MyPresentationController: UIPresentationController {

    var presentFrame: CGRect?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPresentedViewController), name: NSNotification.Name(rawValue: MyPresentationControllerDismiss), object: nil)
    }
    
    /// 即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews() {
        /// 修改弹出视图的大小
        presentedView?.frame = presentFrame!
        
        let coverView = UIView(frame: UIScreen.main.bounds)
        coverView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedViewController))
        coverView.addGestureRecognizer(tap)
        // 在容器视图上添加一个蒙版，插入到展现的视图下面
        containerView?.insertSubview(coverView, at: 0)
    }
    
    @objc func dismissPresentedViewController(){
        presentedViewController.dismiss(animated: false, completion: nil)
    }
}
