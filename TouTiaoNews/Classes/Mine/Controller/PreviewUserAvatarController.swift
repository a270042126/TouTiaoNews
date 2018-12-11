//
//  PreviewUserAvatarController.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/28.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

class PreviewUserAvatarController: UIViewController,StoryboardLoadable {
    /// 头像 URL
    var avatar_url = ""
    
    var avatarRect: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        let avatarImageView = UIImageView()
        avatarImageView.kf.setImage(with: URL(string: avatar_url))
        view.addSubview(avatarImageView)
        
        UIView.animate(withDuration: 0.25, animations: {
            avatarImageView.frame = self.avatarRect
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                avatarImageView.frame = CGRect(x: 0, y: (self.view.height - screenWidth) * 0.5, width: screenWidth, height: screenWidth)
            })
        }
    }
    

    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        ImageDownloader.default.downloadImage(with: URL(string: avatar_url)!, progressBlock: { (receivedSize, totalSize) in
            let progress = Float(receivedSize) / Float(totalSize)
            SVProgressHUD.showProgress(progress)
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.setForegroundColor(UIColor.white)
        }) { (image, error, imageURL, data) in
            // 调用系统相册，保存到相册
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: { (success, error) in
                if success { SVProgressHUD.showSuccess(withStatus: "保存成功!") }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
    
}
