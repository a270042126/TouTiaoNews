//
//  HomeViewController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/20.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.orange
        let homeVM = HomeViewModel()
        homeVM.loadHomeNewsTitleData {
           let titles = homeVM.homeNewsTitles
            NewsTitleTable().insert(titles)
        }
        
    }
    

  

}
