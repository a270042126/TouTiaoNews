//
//  VideoTableViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/12/5.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa
import SnapKit


class VideoTableViewController: HomeTableViewController {
    
    private lazy var disponseBag = DisposeBag()
    
     /// 视频真实地址
    private var realVideo = RealVideo()
     /// 当前播放的时间
    private var currentTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = screenWidth * 0.67
        tableView.ym_registerCell(cell: VideoCell.self)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.displayView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.state) {
        case .error:
             self.player.pause()
            break
        case .paused:
            self.player.play()
            break
        case .playing:
            self.player.pause()
            break
        case .playFinished:
            self.player.pause()
            break
        case .none:
            self.player.pause()
            break
        }
    }
    
}

extension VideoTableViewController{
    
     /// 把播放器添加到 cell 上
    private func addPlayer(on cell: VideoCell){
        // 视频播放时隐藏 cell 的部分子视图
        cell.hideSubviews()
        // 解析头条的视频真实播放地址
        homeVM.parseVideoRealURL(video_id: cell.video.video_detail_info.video_id) { [unowned self] in
            self.realVideo = $0
            cell.bgImageButton.addSubview(self.player.displayView)
            self.player.displayView.snp.makeConstraints({ (make) in
                make.edges.equalTo(cell.bgImageButton)
            })
            if let url = URL(string: $0.video_list.video_1.mainURL){
                  self.player.replaceVideo(url)
                self.player.play()
            }
            self.priorCell = cell
        }
    }
    
   
}

extension VideoTableViewController{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 找到 VideoViewController
        for viewController in navigationController!.viewControllers {
            if viewController is VideoViewController {
                // 说明有视频正在播放
                if player.state == .playing{
                    let imageButton = player.displayView.superview
                    let contentView = imageButton?.superview
                    let cell = contentView?.superview as! VideoCell
                    let rect = tableView.convert(cell.frame, to: viewController.view)
                    // 判断是否滑出屏幕
                    if (rect.origin.y <= -cell.height) || (rect.origin.y >= screenHeight - tabBarController!.tabBar.height) {
                        removePlayer()
                        // 设置当前 cell 的属性
                        cell.showSubviews()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as VideoCell
        cell.video = news[indexPath.row]
        cell.avatarButton.rx.tap.subscribe(onNext:{[unowned self] in
            let userDetailVC = UserDetailViewController.loadStoryboard()
            userDetailVC.userId = cell.video.user_info.user_id
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }).disposed(by: disponseBag)
        // 评论按钮点击
        cell.commetButton.rx.tap.subscribe(onNext:{
            
        }).disposed(by: disponseBag)
        // 背景图片按钮点击
        cell.bgImageButton.rx.tap.subscribe(onNext:{[unowned self] in
             // 如果有值，说明当前有正在播放的视频
            if let priorCell = self.priorCell{
                if cell != priorCell{
                     // 设置当前 cell 的属性
                    priorCell.showSubviews()
                    if self.player.state == .playing {
                        self.player.pause()
                        self.player.displayView.removeFromSuperview()
                    }
                    self.addPlayer(on: cell)
                }
            }else{
                self.addPlayer(on: cell)
            }
        }).disposed(by: disponseBag)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 当前点击的 cell
        let currentCell = tableView.cellForRow(at: indexPath) as! VideoCell
        // 如果播放器正在播放，则停止播放
        if player.state == .playing {removePlayer()}
        // 跳转到详情控制器
         let videoDetailVC = VideoDetailViewController.loadStoryboard()
         videoDetailVC.video = currentCell.video
        videoDetailVC.delegate = self
        videoDetailVC.currentTime = currentTime
        videoDetailVC.currentIndexPath = indexPath
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
    
}

// MARK: - VideoDetailViewControllerDelegate
extension VideoTableViewController: VideoDetailViewControllerDelegate {
    
    func VideoDetailViewControllerViewWillDisappear(_ realVideo: RealVideo, _ currentTime: TimeInterval, _ currentIndexPath: IndexPath) {
        
    }
}
