//
//  Const.swift
//  TouTiaoNews
//
//
import UIKit

/// emoji 宽度
let emojiItemWidth = screenWidth / 7

let DayOrNightButtonClicked = "dayOrNightButtonClicked"

let isNight = "isNight"

/// 服务器地址
//let BASE_URL = "http://lf.snssdk.com"
//let BASE_URL = "http://ib.snssdk.com"
let BASE_URL = "https://is.snssdk.com"

let device_id: Int = 6096495334
let iid: Int = 5034850950

let kMyHeaderViewHeight: CGFloat = 280
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let isIPhoneX: Bool = screenHeight == 812 ? true : false

let newsTitleHeight: CGFloat = 40
let kUserDetailHeaderBGImageViewHeight: CGFloat = 146

let UserDetailHeaderViewButtonClicked = "UserDetailHeaderViewButtonClicked"
let MyPresentationControllerDismiss = "MyPresentationControllerDismiss"
let NavigationBarConcernButtonClicked = "NavigationBarConcernButtonClicked"

/// 关注的用户详情界面 topTab 的按钮的宽度
let topTabButtonWidth: CGFloat = screenWidth * 0.2
/// 关注的用户详情界面 topTab 的指示条的宽度 和 高度
let topTabindicatorWidth: CGFloat = 40
let topTabindicatorHeight: CGFloat = 2


/// 动态图片的宽高
// 图片的宽高
// 1        screenWidth * 0.5
// 2        (screenWidth - 35) / 2
// 3,4,5-9    (screenWidth - 40) / 3
let image1Width: CGFloat = screenWidth * 0.5
let image2Width: CGFloat = (screenWidth - 35) * 0.5
let image3Width: CGFloat = (screenWidth - 40) / 3


/// 从哪里进入头条
enum TTFrom: String {
    case pull = "pull"
    case loadMore = "load_more"
    case auto = "auto"
    case enterAuto = "enter_auto"
    case preLoadMoreDraw = "pre_load_more_draw"
}
