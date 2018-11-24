//
//  IFirstSectionCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/23.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class IFirstSectionCell: UITableViewCell,RegisterCellFromNib {
   
    @IBOutlet fileprivate weak var leftLabel: UILabel!
    @IBOutlet fileprivate weak var rightLabel: UILabel!
    @IBOutlet fileprivate weak var rightImageView: UIImageView!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var topView: UIView!
    @IBOutlet fileprivate weak var separatorView: UIView!
    /// 点击了第几个 cell
    var iConcernSelected: ((_ iConcern: IConcern) -> ())?
    
    var iConcerns = [IConcern](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    var iCellModel = ICellModel(){
        didSet{
            leftLabel.text = iCellModel.text
            rightLabel.text = iCellModel.grey_text
        }
    }
    
    /// 当只关注一个用户的时候，需要设置
    var iConcern = IConcern() {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.collectionViewLayout = IConcernFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.ym_registerCell(cell: IConcernCell.self)
        /// 设置主题
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageView.theme_image = "images.cellRightArrow"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
        topView.theme_backgroundColor = "colors.cellBackgroundColor"
        collectionView.theme_backgroundColor = "colors.cellBackgroundColor"
        
    }

}

extension IFirstSectionCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iConcerns.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.ym_dequeueReusableCell(indexPath: indexPath) as IConcernCell
        cell.iConcern = iConcerns[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iConcernSelected?(iConcerns[indexPath.item])
    }
}

class IConcernFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        // 每个 cell 的大小
        itemSize = CGSize(width: 58, height: 74)
        // 间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // cell 上下左右的间距
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 设置水平滚动
        scrollDirection = .horizontal
    }
}
