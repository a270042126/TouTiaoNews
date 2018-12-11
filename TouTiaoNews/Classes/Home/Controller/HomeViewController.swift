//
//  HomeViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/20.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    /// 标题和内容

    private lazy var navigationBar = HomeNavigationView.loadViewFormNib()
    
    private lazy var disposeBag = DisposeBag()
    private lazy var homeVM = HomeViewModel()
    
     /// 添加频道按钮
    private lazy var addChannelButton: UIButton = {
        let addChannelButton = UIButton(frame: CGRect(x: 0, y: 0, width: newsTitleHeight, height: newsTitleHeight))
         addChannelButton.theme_setImage("images.add_channel_titlbar_thin_new_16x16_", forState: .normal)
        let separatorView = UIView(frame: CGRect(x: 0, y: newsTitleHeight - 1, width: newsTitleHeight, height: 1))
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        addChannelButton.addSubview(separatorView)
        return addChannelButton
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.theme_backgroundColor = "colors.windowColor"
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .black
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background" + (UserDefaults.standard.bool(forKey: isNight) ? "_night" : "")), for: .default)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置 UI
        setupUI()
        // 点击事件
        clickAction()
    }
}

extension HomeViewController{
    
    private func setupUI(){
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        // 设置自定义导航栏
        navigationItem.titleView = navigationBar
        // 添加频道
        view.addSubview(addChannelButton)
        
        // 首页顶部新闻标题的数据
        homeVM.loadHomeNewsTitleData { [unowned self] in
            let titles = self.homeVM.homeNewsTitles
            // 向数据库中插入数据
            NewsTitleTable().insert(titles)
            
            var chilViewControllers = [UIViewController]()
             // 设置子控制器
            _ = titles.compactMap({ (newsTitle) -> () in
                switch newsTitle.category {
                case .video:            // 视频
                    let videoTableVC = VideoTableViewController()
                    videoTableVC.newsTItle = newsTitle
                    videoTableVC.setupRefresh(with: .video)
                    self.addChild(videoTableVC)
                    chilViewControllers.append(videoTableVC)
                case .essayJoke:        // 段子
                    let essayJokeVC = HomeJokeViewController()
                    essayJokeVC.isJoke = true
                    essayJokeVC.setupRefresh(with: .essayJoke)
                    self.addChild(essayJokeVC)
                     chilViewControllers.append(essayJokeVC)
                case .imagePPMM:        // 街拍
                    let imagePPMMVC = HomeJokeViewController()
                    imagePPMMVC.isJoke = false
                    imagePPMMVC.setupRefresh(with: .imagePPMM)
                    self.addChild(imagePPMMVC)
                case .imageFunny:        // 趣图
                    let imagePPMMVC = HomeJokeViewController()
                    imagePPMMVC.isJoke = false
                    imagePPMMVC.setupRefresh(with: .imageFunny)
                    self.addChild(imagePPMMVC)
                case .photos:           // 图片,组图
                    let homeImageVC = HomeImageViewController()
                    homeImageVC.setupRefresh(with: .photos)
                    self.addChild(homeImageVC)
                     chilViewControllers.append(homeImageVC)
                case .jinritemai:       // 特卖
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.randomColor()
                    self.addChild(vc)
                     chilViewControllers.append(vc)
                default :
                    let vc = HomeRecommendController()
                    vc.setupRefresh(with: newsTitle.category)
                    self.addChild(vc)
                     chilViewControllers.append(vc)
                }
            })
            

            let config = DGSegmentConfiguration()
            config.isAddChannelEnabled = true
            let pageView = DGSegmentView(frame: self.view.bounds, configuration: config)
            pageView.titleArray = titles.compactMap({ $0.name })
            pageView.controllerArray = chilViewControllers
            pageView.channelView.addSubview(self.addChannelButton)
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
        // 相机按钮点击
        navigationBar.didSelectCameraButton = {
            
        }
        
        /// 添加频道点击
        addChannelButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                
                let homeAddCategoryVC = HomeAddCategoryController()
                self.present(homeAddCategoryVC, animated: true, completion: nil)
                
        }).disposed(by: disposeBag)
    }
}


