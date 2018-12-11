//
//  HomeJokeViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/12/11.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class HomeJokeViewController: HomeTableViewController {
    
    /// 是否是段子
    var isJoke = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HomeJokeCell.self, forCellReuseIdentifier: "\(HomeJokeCell.self)")
    }
}

extension HomeJokeViewController{
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aNews = news[indexPath.row]
        return isJoke ? aNews.jokeCellHeight : aNews.girlCellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as HomeJokeCell
        cell.isJoke = isJoke
        cell.joke = news[indexPath.row]
        return cell
    }
    
}
