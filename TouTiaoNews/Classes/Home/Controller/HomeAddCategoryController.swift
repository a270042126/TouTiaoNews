//
//  HomeAddCategoryController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable

class HomeAddCategoryController: DGColumnMenuViewController {

    private let homeMV = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsArray = NewsTitleTable().selectAll()
        
        homeMV.loadHomeCategoryRecommend {
            self.otherArray = $0
            self.collectionView.reloadData()
        }
    }
}

extension HomeAddCategoryController{
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! DGColumnMenuCell
        if indexPath.section == 0 {
            cell.title = (tagsArray[indexPath.item] as! HomeNewsTitle).name
        }else{
            cell.title = (otherArray[indexPath.item] as! HomeNewsTitle).name
        }
        return cell
    }
}
