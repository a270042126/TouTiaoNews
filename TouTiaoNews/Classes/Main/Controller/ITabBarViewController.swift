//
//  ITabBarViewController.swift
//  TouTiaoNews
//

import UIKit
import SwiftTheme

class ITabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        addChildViewControllers()
        
         NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ITabBarViewController{
    
    private func setTabBar(){
        let tabBar = UITabBar.appearance()
        tabBar.theme_tintColor = "colors.tabbarTintColor"
        tabBar.theme_barTintColor = "colors.cellBackgroundColor"
        tabBar.tintColor = UIColor(r: 245, g: 90, b: 93)
        tabBar.isTranslucent = false
    }
    
    private func addChildViewControllers() {
        setChildViewController(HomeViewController(), title: "首页", imageName: "home")
        setChildViewController(VideoViewController(), title: "西瓜视频", imageName: "video")
        //setChildViewController(RedPackageViewController(), title: "", imageName: "redpackage")
        setChildViewController(WeitoutiaoViewController(), title: "微头条", imageName: "weitoutiao")
        setChildViewController(MineViewController(), title: "小视频", imageName: "huoshan")
        setValue(ITabBar(), forKey: "tabBar")
    }
    
    private func setChildViewController(_ childController: UIViewController, title: String, imageName: String){
        if UserDefaults.standard.bool(forKey: isNight){
            setNightChildController(controller: childController, imageName: imageName)
        }else{
            setDayChildController(controller: childController, imageName: imageName)
        }
        childController.title = title
        addChild(INavigationController(rootViewController:childController))
    }
    
    /// 设置夜间控制器
    private func setNightChildController(controller: UIViewController, imageName:String){
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_night_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_night_32x32_")
    }
    
    /// 设置日间控制器
    private func setDayChildController(controller: UIViewController, imageName:String){
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_32x32_")
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_press_32x32_")
    }
    
    /// 接收到了按钮点击的通知
    @objc func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        if selected { // 设置为夜间
            for childController in children {
                switch childController.title! {
                case "首页":
                    setNightChildController(controller: childController, imageName: "home")
                case "西瓜视频":
                    setNightChildController(controller: childController, imageName: "video")
                case "小视频":
                    setNightChildController(controller: childController, imageName: "huoshan")
                case "微头条":
                    setNightChildController(controller: childController, imageName: "weitoutiao")
                case "":
                    setNightChildController(controller: childController, imageName: "redpackage")
                default:
                    break
                }
            }
        } else { // 设置为日间
            for childController in children {
                switch childController.title! {
                case "首页":
                    setDayChildController(controller: childController, imageName: "home")
                case "西瓜视频":
                    setDayChildController(controller: childController, imageName: "video")
                case "小视频":
                    setDayChildController(controller: childController, imageName: "huoshan")
                case "微头条":
                    setDayChildController(controller: childController, imageName: "weitoutiao")
                case "":
                    setDayChildController(controller: childController, imageName: "redpackage")
                default:
                    break
                }
            }
        }
    }
}
