//
//  VideoViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/20.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    
    private lazy var navigationBar = HomeNavigationView.loadViewFormNib()
    private var topMenu:CKSlideMenu?
    private lazy var homeMV = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        clickAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background" + (UserDefaults.standard.bool(forKey: isNight) ? "_night" : "")), for: .default)
    }
   
    

}

extension VideoViewController{
    
    private func setupUI(){
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        // 设置自定义导航栏
        navigationItem.titleView = navigationBar
        var childrenVCs = [UIViewController]()
        // 视频顶部新闻标题的数据
        homeMV.loadVideoApiCategoies {
            _ = $0.compactMap({ (newsTitle)  in
                let videoTableVC = VideoTableViewController()
                videoTableVC.setupRefresh(with: newsTitle.category)
                self.addChild(videoTableVC)
                childrenVCs.append(videoTableVC)
            })
            
            let config = DGSegmentConfiguration()
            //config.sliderType = DGSliderType.cover
            //config.titleWidth = self.view.bounds.width / CGFloat(($0 as [Any]).count)
            let pageView = DGSegmentView(frame: self.view.bounds, configuration: config)
            pageView.titleArray = $0.compactMap({ $0.name })
            pageView.controllerArray = childrenVCs
            self.view.addSubview(pageView)
        }
    }
    
    private func clickAction(){
        // 搜索按钮点击
        navigationBar.didSelectSearchButton = {
            
        }
        // 头像按钮点击
        navigationBar.didSelectAvatarButton = { [weak self] in
            self!.navigationController?.pushViewController(MineViewController(), animated: true)
        }
    }
}
