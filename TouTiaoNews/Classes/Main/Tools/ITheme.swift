//
//  File.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/23.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit
import SwiftTheme

enum ITheme:Int{
    case day = 0
    case night = 1
    
    static var before = ITheme.day
    static var current = ITheme.day
    
    static func switchTo(_ theme: ITheme){
        before = current
        current = theme
        
        switch theme{
            case .day: ThemeManager.setTheme(plistName: "default_theme", path: .mainBundle)
            case .night: ThemeManager.setTheme(plistName: "night_theme", path: .mainBundle)
        }
    }
    
    static func switchNight(_ isNight: Bool){
        switchTo(isNight ? .night : .day)
    }
    
    static func isNight() -> Bool{
        return current == .night
    }
}

struct IThemeStyle {
    
    static func setupNavigationBarStyle(_ viewController:UIViewController, _ isNight: Bool){
        if isNight{
            viewController.navigationController?.navigationBar.barStyle = .black
            viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white_night"), for: .default)
            viewController.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.grayColor113()]
        }else{
            viewController.navigationController?.navigationBar.barStyle = .default
            viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white"), for: .default)
        }
    }
}
