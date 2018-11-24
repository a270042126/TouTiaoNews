//
//  SettingCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import Kingfisher

class SettingCell: UITableViewCell,RegisterCellFromNib {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var subtitleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomLine: UIView!
    
    var setting = SettingModel(){
        didSet{
            titleLabel.text = setting.title
            subtitleLabel.text = setting.subtitle
            rightLabel.text = setting.rightTitle
            arrowImageView.isHidden = setting.isHiddenRightArraw
            switchView.isHidden = setting.isHiddenSwitch
            if !setting.isHiddenSwitch{
                subtitleLabelHeight.constant = 20
                layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        bottomLine.theme_backgroundColor = "colors.separatorViewColor"
        titleLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        arrowImageView.theme_image = "images.cellRightArrow"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SettingCell{
    func calculateDiskCashSize(){
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { (size) in
            let sizeM = Double(size) / 1024.0 / 1024.0
            self.rightLabel.text = String(format: "%.2fM", sizeM)
        }
    }
    
    func setupPlayNoticeAlertController(){
        let alertController = UIAlertController(title:"非 WiFi 网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let everyAction = UIAlertAction(title: "每次提醒", style: .default, handler: { (_) in
            self.rightLabel.text = "每次提醒"
        })
        let onceAction = UIAlertAction(title: "提醒一次", style: .default, handler: { (_) in
            self.rightLabel.text = "提醒一次"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(everyAction)
        alertController.addAction(onceAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// 非 WiFi 网络流量
    func setupNetworkAlertController() {
        let alertController = UIAlertController(title: "非 WiFi 网络流量", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestAction = UIAlertAction(title: "最小效果(下载大图)", style: .default, handler: { (_) in
            self.rightLabel.text = "最小效果(下载大图)"
        })
        let betterAction = UIAlertAction(title: "较省流量(智能下图)", style: .default, handler: { (_) in
            self.rightLabel.text = "较省流量(智能下图)"
        })
        let leastAction = UIAlertAction(title: "极省流量(智能下图)", style: .default, handler: { (_) in
            self.rightLabel.text = "极省流量(智能下图)"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(bestAction)
        alertController.addAction(betterAction)
        alertController.addAction(leastAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    /// 设置字体大小
    func setupFontAlertController() {
        let alertController = UIAlertController(title: "设置字体大小", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default, handler: { (_) in
            self.rightLabel.text = "小"
        })
        let middleAction = UIAlertAction(title: "中", style: .default, handler: { (_) in
            self.rightLabel.text = "中"
        })
        let bigAction = UIAlertAction(title: "大", style: .default, handler: { (_) in
            self.rightLabel.text = "大"
        })
        let largeAction = UIAlertAction(title: "特大", style: .default, handler: { (_) in
            self.rightLabel.text = "特大"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(largeAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func clearCacheAlertController(){
        let alertController = UIAlertController(title: "确定清除所有缓存？问答草稿、离线下载及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            self.rightLabel.text = "0.00M"
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
}
