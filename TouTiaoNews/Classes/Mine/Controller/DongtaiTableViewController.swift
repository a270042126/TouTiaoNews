//
//  DongtaiTableViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import RxCocoa
import RxSwift

class DongtaiTableViewController: UITableViewController {
    
    fileprivate lazy var userDetailVM = UserDetailViewModel()
    /// 刷新的指示器
    var maxCursor = 0
    var wendaCursor = ""
    
    /// 动态数据 数组
    var dongtais = [UserDetailDongtai]()
    var articles = [UserDetailDongtai]()
    var videos = [UserDetailDongtai]()
    var wendas = [UserDetailWenda]()
    var iesVideos = [UserDetailDongtai]()
    /// 记录当前的数据是否刷新过
    var isDongtaisShown = false
    var isArticlesShown = false
    var isVideosShown = false
    var isWendasShown = false
    var isIesVideosShown = false
    
    /// 用户编号
    var userId = 0
    
    /// 点击了 用户名
    var didSelectHeaderUserID: ((_ uid: Int)->())?
    /// 点击了 话题
    var didSelectHeaderTopicID: ((_ cid: Int)->())?
    /// 当前的 toptab 的类型
    var currentTopTabType: TopTabType = .dongtai{
        didSet{
            switch currentTopTabType {
                 // 如果已经显示过了，就不再刷新数据了
            case .dongtai:
                if !isDongtaisShown{
                    isDongtaisShown = true
                    // 设置 footer
                    setupFooter(tableView) {
                        self.dongtais += $0
                        self.tableView.reloadData()
                    }
                     tableView.mj_footer.beginRefreshing()
                }
            case .article:      // 文章
                if !isArticlesShown {
                    isArticlesShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: {
                        self.articles += $0
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .video:        // 视频
                if !isVideosShown {
                    isVideosShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: {
                        self.videos += $0
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .wenda: // 问答
                if !isWendasShown{
                    isWendasShown = true
                    tableView.ym_registerCell(cell: UserDetailWendaCell.self)
                    tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: {[weak self] in
                        self?.userDetailVM.loadUserDetailLoadMoreWendaList(userId: self!.userId, cursor: self!.wendaCursor, completionHandler: {
                            if self!.tableView.mj_footer.isRefreshing{
                                self!.tableView.mj_footer.endRefreshing()
                            }
                            self!.tableView.mj_footer.pullingPercent = 0.0
                            if $1.count == 0{
                                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                                SVProgressHUD.showInfo(withStatus: "没有更多数据！")
                                return
                            }
                            self!.wendaCursor = $0
                            self!.wendas += $1
                            self!.tableView.reloadData()
                        })
                    })
                }
                tableView.mj_footer.beginRefreshing()
            case .iesVideo:     // 小视频
                if !isIesVideosShown {
                    isIesVideosShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: {
                        self.iesVideos += $0
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.configuration()
        if isIPhoneX { tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0) }
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.bouncesZoom = false
        if currentTopTabType == .wenda {tableView.ym_registerCell(cell: UserDetailWendaCell.self)}
        else{tableView.ym_registerCell(cell: UserDetailDongTaiCell.self)}
    }
}

extension DongtaiTableViewController{
    
    private func setupFooter(_ tableView: UITableView, completionHandler:@escaping ((_ datas: [UserDetailDongtai])->())) {
        
        self.tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: {[unowned self] in
            self.userDetailVM.loadUserDetailDongtaiList(userId: self.userId, maxCursor: self.maxCursor, completionHandler: {
                if tableView.mj_footer.isRefreshing{tableView.mj_footer.endRefreshing()}
                tableView.mj_footer.pullingPercent = 0.0
                if $1.count == 0{
                    tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                }else{
                    self.maxCursor = $0
                    completionHandler($1)
                }
            })
        })
    }
}

extension DongtaiTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return dongtais.count
        case .article:   // 文章
            return articles.count
        case .video:     // 视频
            return videos.count
        case .wenda:     // 问答
            return wendas.count
        case .iesVideo:  // 小视频
            return iesVideos.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentTopTabType {
        case .dongtai:   // 动态
            return cellFor(tableView, at: indexPath, with: dongtais)
        case .article:   // 文章
            return cellFor(tableView, at: indexPath, with: articles)
        case .video:     // 视频
            return cellFor(tableView, at: indexPath, with: videos)
        case .wenda:     // 问答
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as UserDetailWendaCell
            cell.wenda = wendas[indexPath.row]
            return cell
        case .iesVideo:  // 小视频
            return cellFor(tableView, at: indexPath, with: iesVideos)
        }
    }
    
    /// 设置 cell
    private func cellFor(_ tableView: UITableView, at indexPath: IndexPath, with datas: [UserDetailDongtai]) -> UserDetailDongTaiCell {
        
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as UserDetailDongTaiCell
        cell.dongtai = datas[indexPath.row]
        cell.didSelectDongtaiUserName = {[weak self] in
            self!.didSelectHeaderUserID?($0)
        }
        cell.didSelectDongtaiTopic = { [weak self] in
            self!.didSelectHeaderTopicID?($0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return dongtais[indexPath.row].cellHeight
        case .article:   // 文章
            return articles[indexPath.row].cellHeight
        case .video:     // 视频
            return videos[indexPath.row].cellHeight
        case .wenda:     // 问答
            let wenda = wendas[indexPath.row]
            return wenda.cellHeight
        case .iesVideo:  // 小视频
            return iesVideos[indexPath.row].cellHeight
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 { tableView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}
