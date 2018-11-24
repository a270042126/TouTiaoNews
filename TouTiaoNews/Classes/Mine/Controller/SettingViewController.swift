//
//  SettingViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    fileprivate var sections = [[SettingModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SettingViewController{
    fileprivate func setupUI(){
        let path = Bundle.main.path(forResource: "settingPlist", ofType: "plist")
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
        sections = cellPlist.compactMap({ section in
            (section as! [Any]).compactMap({ SettingModel.deserialize(from: $0 as? [String: Any]) })
        })
        
        tableView.sectionHeaderHeight = 10
        tableView.ym_registerCell(cell: SettingCell.self)
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
    }
}

extension SettingViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as SettingCell
        cell.setting = sections[indexPath.section][indexPath.row]
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0: cell.calculateDiskCashSize()
            case 2: cell.selectionStyle = .none
            default: break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: cell.clearCacheAlertController()         // 清理缓存
            case 1: cell.setupFontAlertController()          // 设置字体大小
            case 3: cell.setupNetworkAlertController()       // 非 WiFi 网络流量
            case 4: cell.setupPlayNoticeAlertController()    // 非 WiFi 网络播放提醒
            default: break
            }
        case 1:
            if indexPath.row == 0 {  // 离线下载
                navigationController?.pushViewController(OfflineDownloadController(), animated: true)
            }
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
}
