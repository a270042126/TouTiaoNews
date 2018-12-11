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
    
    func loadHomeSearchSuggestInfo(_ completionHandler: @escaping (_ searchSuggest: String) -> ()) {
        let url = BASE_URL + "/search/suggest/homepage_suggest/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            if let data = json["data"].dictionary {
                completionHandler(data["homepage_search_suggest"]!.string!)
            }
        }
    }
    
    func loadHomeCategoryRecommend(completionHandler:@escaping (_ titles: [HomeNewsTitle]) -> ()) {
        let url = BASE_URL + "/article/category/get_extra/v1/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            let dataDict = json["data"].dictionary
            if let data = dataDict!["data"]!.arrayObject {
                completionHandler(data.compactMap({
                    HomeNewsTitle.deserialize(from: ($0 as! [String: Any]))
                }))
            }
        }
    }
    
    func loadVideoApiCategoies(completionHandler: @escaping (_ newsTitles: [HomeNewsTitle]) -> ()) {
        let url = BASE_URL + "/video_api/get_category/v1/?"
        let params = ["device_id": device_id,
                      "iid": iid]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            if let datas = json["data"].arrayObject {
                var titles = [HomeNewsTitle]()
                titles.append(HomeNewsTitle.deserialize(from: "{\"category\": \"video\", \"name\": \"推荐\"}")!)
                titles += datas.compactMap({ HomeNewsTitle.deserialize(from: $0 as? Dictionary) })
                completionHandler(titles)
            }
        }
    }
    
    /// 获取首页、视频、小视频的新闻列表数据
    /// - parameter category: 新闻类别
    /// - parameter ttFrom: 那个界面
    /// - parameter completionHandler: 返回新闻列表数据
    /// - parameter news: 首页新闻数据数组
    func loadApiNewsFeeds(category: NewsTitleCategory, ttFrom: TTFrom, _ completionHandler: @escaping (_ maxBehotTime: TimeInterval, _ news: [NewsModel]) -> ()) {
        // 下拉刷新的时间
        let pullTime = Date().timeIntervalSince1970
        let url = BASE_URL + "/api/news/feed/v75/?"
        let params = ["device_id": device_id,
                      "count": 20,
                      "list_count": 15,
                      "category": category.rawValue,
                      "min_behot_time": pullTime,
                      "strict": 0,
                      "detail": 1,
                      "refresh_reason": 1,
                      "tt_from": ttFrom,
                      "iid": iid] as [String: Any]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            guard let datas = json["data"].array else { return }
            completionHandler(pullTime, datas.compactMap({ NewsModel.deserialize(from: $0["content"].string) }))
        }
    }
    
    /// 获取首页、视频、小视频的新闻列表数据,加载更多
    /// - parameter category: 新闻类别
    /// - parameter ttFrom: 那个界面
    /// - parameter listCount: 数据数量
    /// - parameter completionHandler: 返回新闻列表数据
    /// - parameter news: 首页新闻数据数组
    func loadMoreApiNewsFeeds(category: NewsTitleCategory, ttFrom: TTFrom, maxBehotTime: TimeInterval, listCount: Int, _ completionHandler: @escaping (_ news: [NewsModel]) -> ()) {
        let url = BASE_URL + "/api/news/feed/v75/?"
        let params = ["device_id": device_id,
                      "count": 20,
                      "list_count": listCount,
                      "category": category.rawValue,
                      "max_behot_time": maxBehotTime,
                      "strict": 0,
                      "detail": 1,
                      "refresh_reason": 1,
                      "tt_from": ttFrom,
                      "iid": iid] as [String: Any]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { return }
            guard let datas = json["data"].array else { return }
            completionHandler(datas.compactMap({ NewsModel.deserialize(from: $0["content"].string) }))
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
    
    /// 解析头条的视频真实播放地址
    /// - [可参考这篇博客](http://blog.csdn.net/dianliang01/article/details/73163086)
    /// - parameter video_id: 视频 id
    /// - parameter completionHandler: 返回视频真实播放地址
    /// - parameter newsTitles: 视频真实播放地址
    func parseVideoRealURL(video_id: String, completionHandler: @escaping (_ realVideo: RealVideo) -> ()) {
        let r = arc4random() // 随机数
        
        let url: NSString = "/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)" as NSString
        let data: NSData = url.data(using: String.Encoding.utf8.rawValue)! as NSData
        // 使用 crc32 校验
        var crc32: UInt64 = UInt64(data.getCRC32())
        // crc32 可能为负数，要保证其为正数
        if crc32 < 0 { crc32 += 0x100000000 }
        // 拼接 url
        let realURL = "http://i.snssdk.com/video/urls/v/1/toutiao/mp4/\(video_id)?r=\(r)&s=\(crc32)"
        NetworkTools.requestData(.get, URLString: realURL) { (result) in
            completionHandler(RealVideo.deserialize(from: JSON(result)["data"].dictionaryObject)!)
        }
        
    }
    
    /// 获取用户详情一般的详情的评论数据
    /// item_type: postContent(200),postVideo(150),postVideoOrArticle(151)
    /// - parameter forumId: 用户id
    /// - parameter groupId: thread_id
    /// - parameter offset: 偏移
    /// - parameter completionHandler: 返回评论数据
    /// - parameter comments: 评论数据
    func loadUserDetailNormalDongtaiComents(groupId: Int, offset: Int, count: Int, completionHandler: @escaping (_ comments: [DongtaiComment]) -> ()) {
        
        let url = BASE_URL + "/article/v2/tab_comments/"
        let params = ["forum_id": "",
                      "group_id": groupId,
                      "count": count,
                      "offset": offset,
                      "device_id": device_id,
                      "iid": iid] as [String : Any]
        NetworkTools.requestData(.get, URLString: url, parameters: params) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else { completionHandler([]); return }
            if let datas = json["data"].arrayObject {
                completionHandler(datas.compactMap({
                    return DongtaiComment.deserialize(from: ($0 as! [String: Any])["comment"] as? Dictionary)
                }))
            }
        }
    }
    
    /// 获取图片新闻详情数据
    /// - parameter articleURL: 链接
    /// - parameter completionHandler: 返回图片数组，标题数组
    /// - parameter images: 图片数组
    /// - parameter abstracts: 标题数组
    func loadNewsDetail(articleURL: String, completionHandler:@escaping (_ images: [NewsDetailImage], _ abstracts: [String])->()) {
        // 测试数据
        //        http://toutiao.com/item/6450211121520443918/
        let url = "http://www.toutiao.com/a6450237670911852814/#p=1"
        
        NetworkTools.requestString(url: url) { (result) in
            let value = result as AnyObject
            if value.contains("BASE_DATA.galleryInfo =") {
                // 获取 图片链接数组
                let startIndex = value.range(of: ",\\\"sub_images\\\":").upperBound
                let endIndex = value.range(of: ",\\\"max_img_width\\\":").lowerBound
                let BASE_DATA = value[Range(uncheckedBounds: (lower: startIndex, upper: endIndex))] as? String
                let substring = BASE_DATA?.replacingOccurrences(of: "\\\\", with: "")
                let substring2 = substring?.replacingOccurrences(of: "\\", with: "")
                if let data = substring2?.data(using: .utf8){
                    let dicts = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [Any]
                    // 获取 子标题
                    let titleStartIndex = value.range(of: "\\\"sub_abstracts\\\":").upperBound
                    let titlEndIndex = value.range(of: ",\\\"sub_titles\\\"").lowerBound
                    let sub_abstracts = value[Range(uncheckedBounds: (lower: titleStartIndex, upper: titlEndIndex))] as? String
                    let titleSubstring1 = sub_abstracts?.replacingOccurrences(of: "\\\"", with: "\"")
                    let titleSubstring2 = titleSubstring1?.replacingOccurrences(of: "\\u", with: "u")
                    if let titleData = titleSubstring2?.data(using: String.Encoding.utf8){
                        completionHandler(dicts!.compactMap({ NewsDetailImage.deserialize(from: $0 as? [String: Any])! }), try! JSONSerialization.jsonObject(with: titleData, options: .mutableContainers) as! [String])
                    }
                }
                
            }
        }
    }
}
