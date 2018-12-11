//
//  DongtaiOriginThreadView.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DongtaiOriginThreadView: UIView, NibLoadable {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: DongtaiCollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    let emojiManager = EmojiManager()
    var isPostSmallVideo = false
    var originthread = DongtaiOriginThread() {
        didSet{
            // 如果原内容已经删除
            if originthread.delete || !originthread.show_origin{
                contentLabel.text = originthread.show_tips != "" ? originthread.show_tips : originthread.content
                contentLabel.textAlignment = .center
                contentLabelHeight.constant = originthread.contentH
            } else {
                contentLabel.attributedText = originthread.attributedContent
                contentLabelHeight.constant = originthread.contentH
                collectionView.isDongtaiDetail = originthread.isDongtaiDetail
                collectionView.thumbImages = originthread.thumb_image_list
                collectionView.largeImages = originthread.large_image_list
                collectionViewWidth.constant = originthread.collectionViewW
                layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.grayColor247"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = originthread.height
        width = screenWidth
    }
}
