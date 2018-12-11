//
//  DongtaiCollectionViewCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

class DongtaiCollectionViewCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var gifLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    
    var isPostSmallVideo = false {
        didSet {
            iconButton.theme_setImage(isPostSmallVideo ? "images.smallvideo_all_32x32_" : nil, forState: .normal)
        }
    }
    
    var thumbImage = ThumbImage() {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage.urlString)!)
            gifLabel.isHidden = !(thumbImage.type == .gif)
        }
    }
    
    var largeImage = LargeImage() {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: largeImage.urlString), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                let progress = Float(receivedSize) / Float(totalSize)
                SVProgressHUD.showProgress(progress)
                SVProgressHUD.setBackgroundColor(.clear)
                SVProgressHUD.setForegroundColor(UIColor.white)
            }) { (image, error, cacheType, url) in
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.theme_borderColor = "colors.grayColor230"
        thumbImageView.layer.borderWidth = 1
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

}
