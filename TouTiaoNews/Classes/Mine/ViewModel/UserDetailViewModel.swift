//
//  UserDetailViewMode.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/27.
//  Copyright © 2018年 dd. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDetailViewModel{

    /// 获取用户详情数据
    /// - parameter userId: 用户id
    /// - parameter completionHandler: 返回用户详情数据
    /// - parameter userDetail:  用户详情数据
    func loadUserDetail(userId: Int, completionHandler: @escaping (_ userDetail: UserDetail) -> ()){
        
        let url = BASE_URL + "/user/profile/homepage/v4/?"
        let params = ["user_id": userId,
                      "device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            completionHandler(UserDetail.deserialize(from: json["data"].dictionaryObject)!)
        }
    }
    
    /// 获取用户详情的动态列表数据
    /// - parameter userId: 用户id
    /// - parameter maxCursor: 刷新时间
    /// - parameter completionHandler: 返回动态数据
    /// - parameter dongtais:  动态数据的数组
    func loadUserDetailDongtaiList(userId: Int, maxCursor: Int, completionHandler: @escaping (_ cursor: Int,_ dongtais: [UserDetailDongtai]) -> ()) {
        let url = BASE_URL + "/dongtai/list/v15/?"
        let params = ["user_id": userId,
                      "max_cursor": maxCursor,
                      "device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { completionHandler(maxCursor, []); return }
            if let data = json["data"].dictionary {
                let max_cursor = data["max_cursor"]!.int
                if let datas = data["data"]!.arrayObject {
                    completionHandler(max_cursor!, datas.compactMap({
                        UserDetailDongtai.deserialize(from: $0 as? Dictionary)
                    }))
                }
            }
        }
    }
    
    
    /// 已关注用户，取消关注
    /// - parameter userId: 用户id
    /// - parameter completionHandler: 返回用户
    /// - parameter user:  用户信息（暂时不用）
    func loadRelationUnfollow(userId: Int, completionHandler: @escaping (_ user: ConcernUser) -> ()) {
        let url = BASE_URL + "/2/relation/unfollow/?"
        let params = ["user_id": userId,
                      "device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            if let data = json["data"].dictionaryObject {
                completionHandler(ConcernUser.deserialize(from: data["user"] as? Dictionary)!)
            }
        }
    }
    
    /// 点击关注按钮，关注用户
    /// - parameter userId: 用户id
    /// - parameter completionHandler: 返回用户
    /// - parameter user:  用户信息（暂时不用）
    func loadRelationFollow(userId: Int, completionHandler: @escaping (_ user: ConcernUser) -> ()) {
        let url = BASE_URL + "/2/relation/follow/v2/?"
        let params = ["user_id": userId,
                      "device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            if let data = json["data"].dictionaryObject {
                completionHandler(ConcernUser.deserialize(from: data["user"] as? Dictionary)!)
            }
        }
    }
    
    /// 点击了关注按钮，就会出现相关推荐数据
    /// - parameter userId: 用户id
    /// - parameter completionHandler: 返回推荐关注数据
    /// - parameter concerns:  推荐关注数组
    func loadRelationUserRecommend(userId: Int, completionHandler: @escaping (_ concerns: [UserCard]) -> ()) {
        let url = BASE_URL + "/user/relation/user_recommend/v1/supplement_recommends/?"
        let params = ["device_id": device_id,
                      "follow_user_id": userId,
                      "iid": iid,
                      "scene": "follow",
                      "source": "follow"] as [String : Any]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["err_no"] == 0 else { return }
            if let user_cards = json["user_cards"].arrayObject {
                completionHandler(user_cards.compactMap({ UserCard.deserialize(from: $0 as? Dictionary) }))
            }
        }
    }
    
    func loadUserDetailLoadMoreWendaList(userId: Int, cursor: String, completionHandler: @escaping (_ cursor: String,_ wendas: [UserDetailWenda]) -> ()) {
        let url = BASE_URL + "/wenda/profile/wendatab/loadmore/?"
        let params = ["other_id": userId,
                      "format": "json",
                      "cursor": cursor,
                      "count": 10,
                      "offset": "undefined",
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["err_no"] == 0 else { completionHandler(cursor, []); return }
            if let answerQuestions = json["answer_question"].arrayObject {
                if answerQuestions.count == 0 { completionHandler(cursor, []) }
                else {
                    completionHandler(json["cursor"].string!, answerQuestions.compactMap({
                        UserDetailWenda.deserialize(from: $0 as? Dictionary)
                    }))
                }
            }
        }
    }
    
}
