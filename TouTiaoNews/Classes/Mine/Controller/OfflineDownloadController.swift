//
//  OfflineDownloadController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class OfflineDownloadController: UITableViewController {
    private var titles = [HomeNewsTitle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "离线下载"
        tableView.ym_registerCell(cell: OfflineDownlaodCell.self)
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 44
        tableView.theme_separatorColor = "colors.separatorViewColor"
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        titles = NewsTitleTable().selectAll()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension OfflineDownloadController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return OfflineSectionHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as OfflineDownlaodCell
        let newsTitle = titles[indexPath.row]
        cell.titleLabel.text = newsTitle.name
        cell.rightImageView.theme_image = newsTitle.selected ? "images.air_download_option_press" : "images.air_download_option"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var homeNewsTitle = titles[indexPath.row]
        homeNewsTitle.selected = !homeNewsTitle.selected
        let cell = tableView.cellForRow(at: indexPath) as! OfflineDownlaodCell
        cell.rightImageView.theme_image = homeNewsTitle.selected ? "images.air_download_option_press" : "images.air_download_option"
        titles[indexPath.row] = homeNewsTitle
        
        NewsTitleTable().update(homeNewsTitle)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
