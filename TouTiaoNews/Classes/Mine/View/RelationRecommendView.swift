//
//  RelationRecommendView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class RelationRecommendView: UIView, NibLoadable{

    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userCards = [UserCard]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        collectionView.collectionViewLayout = RelationRecommendFlowLayout()
        collectionView.ym_registerCell(cell: RelationRecommendCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension RelationRecommendView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ym_dequeueReusableCell(indexPath: indexPath) as RelationRecommendCell
        cell.userCard = userCards[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class RelationRecommendFlowLayout: UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = CGSize(width: 142, height: 190)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
