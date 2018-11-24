//
//  SettingModel.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/24.
//  Copyright © 2018年 dd. All rights reserved.
//

import Foundation
import HandyJSON

struct SettingModel: HandyJSON {
    
    var title: String = ""
    var subtitle: String = ""
    var rightTitle: String = ""
    var isHiddenSubtitle: Bool = false
    var isHiddenRightTitle: Bool = false
    var isHiddenSwitch: Bool = false
    var isHiddenRightArraw: Bool = false
}
