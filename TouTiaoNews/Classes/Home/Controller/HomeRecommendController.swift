//
//  HomeRecommendController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class HomeRecommendController: HomeTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.ym_registerCell(cell: HomeUserCell.self)
        tableView.ym_registerCell(cell: TheyAlsoUseCell.self)
        tableView.ym_registerCell(cell: HomeCell.self)
    }
}

extension HomeRecommendController{

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aNews = news[indexPath.row]
        switch aNews.cell_type {
        case .user:
            return aNews.contentH
        case .relatedConcern:
            return 290
        default:
            return aNews.cellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNew = news[indexPath.row]
        switch aNew.cell_type  {
        case .user:
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as HomeUserCell
            cell.aNews = aNew
        case .relatedConcern:
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as TheyAlsoUseCell
            cell.theyUse = aNew.raw_data
            return cell
        case .none:
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as HomeCell
            cell.aNews = aNew
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var aNews = news[indexPath.row]
        if indexPath.row == 0{
            let newsDetailImageVC = NewsDetailImageController.loadStoryboard()
            newsDetailImageVC.isSelectedFirstCell = true
            aNews.item_id = 6450240420034118157
            aNews.group_id = 6450237670911852814
            newsDetailImageVC.aNews = aNews
            present(newsDetailImageVC, animated: true, completion: nil)
        } else if aNews.source == "悟空问答"{
            
        } else if aNews.has_video {
            
        }
    }
}
