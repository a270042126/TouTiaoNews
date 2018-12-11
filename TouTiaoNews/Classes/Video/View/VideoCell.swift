//
//  ViewCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/12/5.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import IBAnimatable

class VideoCell: UITableViewCell, RegisterCellFromNib {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bgImageButton: UIButton!
    @IBOutlet weak var avatarButton: AnimatableButton!
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var pyqButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var concernButton: UIButton!
    @IBOutlet weak var commetButton: UIButton!
    @IBOutlet weak var shareStackView: UIStackView!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var pyqButtonWidth: NSLayoutConstraint!
    
    var homeVM: HomeViewModel?
    
    /// 视频数据
    var video = NewsModel() {
        didSet{
            titleLabel.text = video.title
            playCountLabel.text = video.video_detail_info.videoWatchCount + "次播放"
            avatarButton.kf.setImage(with: URL(string: video.user_info.avatar_url), for: .normal)
            vImageView.isHidden = !video.user_info.user_verified
            concernButton.isSelected = video.user_info.follow
            bgImageButton.kf.setBackgroundImage(with: URL(string: video.video_detail_info.detail_video_large_image.urlString), for: .normal)
            timeLabel.text = video.videoDuration
            commetButton.setTitle(video.commentCount, for: .normal)
            commetButton.theme_setTitleColor("colors.black", forState: .normal)
            commetButton.theme_setImage("images.comment_24x24_", forState: .normal)
            concernButton.isHidden = video.label_style == .ad
            commetButton.isHidden = video.label_style == .ad
            adButton.setTitle((video.ad_button.button_text == "" ? "查看详情" : video.ad_button.button_text), for: .normal)
            nameLabel.text = video.user_info.name
            if video.label_style == .ad {
                nameLabel.text = video.app_name != "" ? video.app_name : video.ad_button.app_name
                descriptionLabel.text = video.ad_button.description == "" ? video.sub_title : video.ad_button.description
                descriptionLabelHeight.constant = 20
                layoutIfNeeded()
            }
            adButton.isHidden = video.label_style != .ad
            adLabel.isHidden = video.label_style != .ad
        }
    }
   

    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        bgImageButton.setImage(UIImage(named: "video_play_icon_44x44_"), for: .normal)
        shareLabel.theme_textColor = "colors.black"
        titleLabel.theme_textColor = "colors.moreLoginTextColor"
        nameLabel.theme_textColor = "colors.black"
        playCountLabel.theme_textColor = "colors.moreLoginTextColor"
        concernButton.theme_setImage("images.video_add_24x24_", forState: .normal)
        concernButton.setImage(nil, for: .selected)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.black", forState: .normal)
        concernButton.theme_setTitleColor("colors.grayColor210", forState: .selected)
        moreButton.theme_setImage("images.More_24x24_", forState: .normal)
        adButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
        adButton.theme_setImage("images.view detail_ad_feed_15x13_", forState: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func adButtonClicked(_ sender: UIButton) {
        let downloadURL = video.ad_button.download_url != "" ? video.ad_button.download_url : video.download_url
        print("app 下载地址 - \(downloadURL)")
    }
    
    @IBAction func concerButtonClicked(_ sender: UIButton) {
        if sender.isSelected {
            homeVM?.loadRelationUnfollow(userId: video.user.user_id, completionHandler: { (_) in
                sender.isSelected = !sender.isSelected
            })
        }else{
            homeVM?.loadRelationFollow(userId: video.user_info.user_id, completionHandler: { (_) in
                sender.isSelected = !sender.isSelected
            })
        }
    }
    
}

extension VideoCell{
    /// 视频播放时隐藏 cell 的部分子视图
    func hideSubviews() {
        titleLabel.isHidden = true
        playCountLabel.isHidden = true
        timeLabel.isHidden = true
        vImageView.isHidden = true
        avatarButton.isHidden = true
        nameLabel.isHidden = true
        shareStackView.isHidden = false
    }
    
    /// 设置当前 cell 的属性
    func showSubviews() {
        titleLabel.isHidden = false
        playCountLabel.isHidden = false
        timeLabel.isHidden = false
        avatarButton.isHidden = false
        vImageView.isHidden = !video.user_verified
        nameLabel.isHidden = false
        shareStackView.isHidden = true
    }
}
