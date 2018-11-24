//
//  IConcernViewModel.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/23.
//  Copyright © 2018年 dd. All rights reserved.
//

import Foundation
import SwiftyJSON

class IConcernViewModel{
    
    lazy var iCellModels = [[ICellModel]]()
    lazy var iConcerns = [IConcern]()
    
    func loadMyCellData(completionHandler: @escaping () -> ()){
        
        let myCellUrl = BASE_URL + "/user/tab/tabs/?"
        let myCellparams = ["device_id": device_id]
        NetworkTools.requestData(.get, URLString: myCellUrl, parameters: myCellparams) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else {return}
            var mySections = [[ICellModel]]()
            mySections.append([ICellModel.deserialize(from: "{\"text\":\"我的关注\",\"grey_text\":\"\"}")!])
            if let data = json["data"].dictionary {
                if let sections = data["sections"]?.arrayObject{
                    mySections += sections.compactMap({ item in
                        (item as! [Any]).compactMap({ ICellModel.deserialize(from: $0 as? Dictionary) })
                    })
                    self.iCellModels += mySections
                    completionHandler()
                }
            }
        
        }
    }
    
    func loadMyConcernData(completionHandler: @escaping () -> ()){
        let myConcernUrl = BASE_URL + "/concern/v2/follow/my_follow/?"
        let myConcernParams = ["device_id": device_id]
        NetworkTools.requestData(.get, URLString: myConcernUrl, parameters: myConcernParams) { (result) in
            let json = JSON(result)
            guard json["message"] == "success" else{return}
            if let datas = json["data"].arrayObject{
                self.iConcerns += datas.compactMap({ IConcern.deserialize(from: $0 as? Dictionary) })
                 completionHandler()
            }
        }
    }
    
   
}
