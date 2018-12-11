//
//  DongtaiCollectionView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DongtaiCollectionView: UICollectionView, NibLoadable {

    var didSelect: ((_ selectedIndex: Int)->())?
    /// 是否发布了小视频
    var isPostSmallVideo = false
    /// 是否是动态详情
    var isDongtaiDetail = false
    
    var isWeitoutiao = false
    
    var thumbImages = [ThumbImage]() {
        didSet {
            reloadData()
        }
    }
    
    var largeImages = [LargeImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        backgroundColor = UIColor.clear
        collectionViewLayout = DongtaiCollectionViewFlowLayout()
        ym_registerCell(cell: DongtaiCollectionViewCell.self)
        isScrollEnabled = false
    }
}

extension DongtaiCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ym_dequeueReusableCell(indexPath: indexPath) as DongtaiCollectionViewCell
        cell.thumbImage = thumbImages[indexPath.item]
        cell.isPostSmallVideo = isPostSmallVideo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isDongtaiDetail ? Calculate.detailCollectionViewCellSize(thumbImages) : Calculate.collectionViewCellSize(thumbImages.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class DongtaiCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
}

