//
//  UserDetailViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/26.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailTableView: UITableView, UIGestureRecognizerDelegate{
    // 底层 tableView 实现这个 UIGestureRecognizerDelegate 代理方法，就可以响应上层 tableView 的滑动手势，
    // otherGestureRecognizer 就是它上层的 view 持有的手势，这里的话，上层应该是 scrollView 和 顶层 tabelview
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 保证其他手势的存在
        guard let otherView = otherGestureRecognizer.view else { return false }
        // 如果其他手势的 view 是 UIScrollView，就不能让 UserDetailTableView 响应
        if otherView.isMember(of: UIScrollView.self) { return false }
        // 其他手势是 tableView 的 pan 手势，就让他响应
        let isPan = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        if isPan && otherView.isKind(of: UIScrollView.self) { return true }
        return false
    }
}

class UserDetailViewController: UIViewController,StoryboardLoadable {

  
    
    @IBOutlet weak var tableView: UserDetailTableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    private lazy var headerView: UserDetailHeaderView = { [unowned self] in 
        let userDetailHeadeView = UserDetailHeaderView.loadViewFormNib()
        userDetailHeadeView.didAvatarButtonClicked = {
            let pVC = PreviewUserAvatarController.loadStoryboard()
            pVC.avatar_url = self.userDetail.big_avatar_url
            self.present(pVC, animated: true, completion: nil)
        }
        return userDetailHeadeView
    }()
    private lazy var navigationBar = UserDetailNavigationBar.loadViewFormNib()
    private lazy var topTabScrollView = TopTabScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
    private lazy var myBottomView: UserDetailBottomView = {
        let myBottomView = UserDetailBottomView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        myBottomView.delegate = self
        return myBottomView
    }()
    
    private let disposeBag = DisposeBag()
    var userId: Int = 0
    var userDetail = UserDetail()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        selectedAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_clear"), for: .default)
    }

}

extension UserDetailViewController{
    
    fileprivate func setupUI(){
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = navigationBar
        tableView.ym_registerCell(cell: UserDetailCell.self)
        tableView.tableFooterView = UIView()
        
        let userDetailVM = UserDetailViewModel()
        userDetailVM.loadUserDetail(userId: userId) { (userDetail) in
               // 获取用户详情的动态列表数据
            userDetailVM.loadUserDetailDongtaiList(userId: self.userId, maxCursor: 0, completionHandler: { (cursor, dongtai) in
                if userDetail.bottom_tab.count != 0{
                    // 底部 view 的高度
                    self.bottomViewHeight.constant = isIPhoneX ? 78 : 44
                    self.view.layoutIfNeeded()
                    self.myBottomView.bottomTabs = userDetail.bottom_tab
                    self.bottomView.addSubview(self.myBottomView)
                }
                self.userDetail = userDetail
                self.headerView.userDetail = userDetail
                self.tableView.tableHeaderView = self.headerView
                
                self.navigationBar.userDetail = userDetail
                self.topTabScrollView.topTabs = userDetail.top_tab
                let navigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0
                let rowHeight = screenHeight - navigationBarHeight - self.tableView.sectionHeaderHeight - self.bottomViewHeight.constant
                self.tableView.rowHeight = rowHeight
                // 一定要先 reload 一次，否则不能刷新数据，也不能设置行高
                self.tableView.reloadData()
                if userDetail.top_tab.count == 0 { return }
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
                // 遍历
                for(index, topTab) in userDetail.top_tab.enumerated(){
                    let dongtaiVC = DongtaiTableViewController()
                    self.addChild(dongtaiVC)
                    if index == 0{dongtaiVC.currentTopTabType = topTab.type}
                    dongtaiVC.tableView.frame =  CGRect(x: CGFloat(index) * screenWidth, y: 0, width: screenWidth, height: rowHeight)
                    cell.scrollView.addSubview(dongtaiVC.tableView)
                    if index == userDetail.top_tab.count - 1{
                        cell.scrollView.contentSize = CGSize(width: CGFloat(userDetail.top_tab.count) * screenWidth, height: cell.scrollView.height)
                    }
                }
            })
        }
    }
    
    fileprivate func selectedAction(){
        headerView.didSelectConcernButton = { [unowned self] in
            self.tableView.tableHeaderView = self.headerView
        }
        
        // 返回按钮点击
        navigationBar.returnButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in // 需要加 [weak self] 防止循环引用
            self!.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
         // 当前的 topTab 类型
        topTabScrollView.currentTopTab = {[unowned self] (topTab, index) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
            let dongtaiVC = self.children[index] as! DongtaiTableViewController
            dongtaiVC.currentTopTabType = topTab.type
            cell.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: 0), animated: true)
        }
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as UserDetailCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        view.addSubview(topTabScrollView)
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let navigationBarHeight:CGFloat = isIPhoneX ? -88.0 : -64.0
        
        if offsetY < navigationBarHeight{
            let totalOffset = kUserDetailHeaderBGImageViewHeight + abs(offsetY)
            let f = totalOffset / kUserDetailHeaderBGImageViewHeight
            headerView.backgroundImageView.frame = CGRect(x: -screenWidth * (f - 1) * 0.5, y: offsetY, width: screenWidth * f, height: totalOffset)
            navigationBar.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        }else{
            var alpha: CGFloat = (offsetY + 44) / 58
            alpha = min(alpha, 1.0)
            navigationBar.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: alpha)
            if alpha == 1.0 {
                navigationController?.navigationBar.barStyle = .default
                navigationBar.returnButton.theme_setImage("images.personal_home_back_black_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_more_titlebar_24x24_", forState: .normal)
            } else {
                navigationController?.navigationBar.barStyle = .black
                navigationBar.returnButton.theme_setImage("images.personal_home_back_white_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_morewhite_titlebar_22x22_", forState: .normal)
            }
            // 14 + 15 + 14
            var alpha1: CGFloat = offsetY / 57
            if offsetY >= 43 {
                alpha1 = min(alpha1, 1.0)
                navigationBar.nameLabel.isHidden = false
                navigationBar.concernButton.isHidden = false
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            } else {
                alpha1 = min(0.0, alpha1)
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            }
        }
    }
  
    
}

extension UserDetailViewController: UserDetailBottomViewDelegate{
    
     // bottomView 底部按钮的点击
    func bottomView(clicked button: UIButton, bottomTab: BottomTab) {
        let bottomPushVC = UserDetailBottomPushController()
         bottomPushVC.navigationItem.title = "网页浏览"
        if bottomTab.children.count == 0{
            bottomPushVC.url = bottomTab.value
            navigationController?.pushViewController(bottomPushVC, animated: true)
        }else{
            // 创建 Storyboard
           let popoverVC = UserDetailBottomPopController.loadStoryboard()
            popoverVC.tabChildren = bottomTab.children
            popoverVC.modalPresentationStyle = .custom
            popoverVC.didSelectedChild = { [weak self] in
                bottomPushVC.url = $0.value
                self?.navigationController?.pushViewController(bottomPushVC, animated: true)
            }
            let popoverAnimator = PopoverAnimator()
            // 转化 frame
            let rect = myBottomView.convert(button.frame, to: view)
            let popWidth = (screenWidth - CGFloat(userDetail.bottom_tab.count + 1) * 20) / CGFloat(userDetail.bottom_tab.count)
            let popX = CGFloat(button.tag) * (popWidth + 20) + 20
            let popHeight = CGFloat(bottomTab.children.count) * 40 + 25
            popoverAnimator.presetnFrame = CGRect(x: popX, y: rect.origin.y - popHeight, width: popWidth, height: popHeight)
            popoverVC.transitioningDelegate = popoverAnimator
            present(popoverVC, animated: true, completion: nil)
        }
    }
}
