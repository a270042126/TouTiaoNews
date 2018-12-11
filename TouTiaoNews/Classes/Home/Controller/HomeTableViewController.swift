//
//  HomeTableViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/30.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import SVProgressHUD
import VGPlayer

class HomeTableViewController: UITableViewController {
    
    lazy var homeVM = HomeViewModel()
    
    lazy var player: VGPlayer = VGPlayer()
    /// 标题
    var newsTItle = HomeNewsTitle()
    /// 新闻数据
    var news = [NewsModel]()
    /// 刷新时间
    var maxBehotTime: TimeInterval = 0.0
    /// 上一次播放的 cell
    var priorCell: VideoCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        tableView.theme_separatorColor = "colors.separatorViewColor"
        tableView.tableFooterView = UIView()
    }

    /// 设置刷新控件
    func setupRefresh(with category: NewsTitleCategory = .recommend){
        // 刷新头部
        let header = RefreshHeader {[unowned self] in
            // 获取视频的新闻列表数据
            self.homeVM.loadApiNewsFeeds(category: category, ttFrom: .pull, {
                if self.tableView.mj_header.isRefreshing{
                    self.tableView.mj_header.endRefreshing()
                }
                self.player.displayView.removeFromSuperview()
                self.maxBehotTime = $0
                self.news = $1
                self.tableView.reloadData()
            })
        }
        
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
        // 底部刷新控件
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: {[unowned self] in
            // 获取视频的新闻列表数据，加载更多
            self.homeVM.loadMoreApiNewsFeeds(category: category, ttFrom: .loadMore, maxBehotTime: self.maxBehotTime, listCount: self.news.count, {
                if self.tableView.mj_footer.isRefreshing{
                    self.tableView.mj_footer.endRefreshing()
                }
                self.tableView.mj_footer.pullingPercent = 0.0
                self.player.displayView.removeFromSuperview()
                if $0.count == 0 {
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦！")
                    return
                }
                self.news += $0
                self.tableView.reloadData()
            })
        })
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
    }
    
}

extension HomeTableViewController{
    
    /// 移除播放器
    func removePlayer() {
        player.pause()
        self.player.displayView.removeFromSuperview()
        priorCell = nil
    }
}

extension HomeTableViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension HomeTableViewController: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}
