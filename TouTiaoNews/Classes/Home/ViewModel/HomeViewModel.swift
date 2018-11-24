//
//  HomeViewModel.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewModel {

    lazy var homeNewsTitles = [HomeNewsTitle]()

    func loadHomeNewsTitleData(completionHandler: @escaping () -> ()){
        let url = BASE_URL + "/article/category/get_subscribed/v1/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            if let dataDict = json["data"].dictionary{
                if let datas = dataDict["data"]?.arrayObject {
                    self.homeNewsTitles.append(HomeNewsTitle.deserialize(from: "{\"category\": \"\", \"name\": \"推荐\"}")!)
                    self.homeNewsTitles += datas.compactMap({HomeNewsTitle.deserialize(from: $0 as? Dictionary)})
                    completionHandler()
                }
            }
        }
    }
}
