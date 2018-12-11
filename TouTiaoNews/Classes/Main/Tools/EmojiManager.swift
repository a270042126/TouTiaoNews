//
//  EmojiManager.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/27.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

struct Emoji {
    var id = ""
    var name = ""
    var png = ""
    var isDelete = false
    var isEmpty = false
    
    init(id: String = "", name: String = "", png: String = "", isDelete: Bool = false, isEmpty: Bool = false) {
        self.id = id
        self.name = name
        self.png = png
        self.isDelete = isDelete
        self.isEmpty = isEmpty
    }
}

struct EmojiManager {
    var emojis = [Emoji]()
    
    init() {
         // 获取 emoji_sort.plist 的路径
        let arrayPath = Bundle.main.path(forResource: "emoji_sort.plist", ofType: nil)
        let emojiSorts = NSArray(contentsOfFile: arrayPath!) as! [String]
         // 获取 emoji_mapping.plist 的路径
        let mappingPath = Bundle.main.path(forResource: "emoji_mapping.plist", ofType: nil)
        let emojiMapping = NSDictionary(contentsOfFile: mappingPath!) as! [String: String]
        
        var temps = [Emoji]()
        
        for(index, id) in emojiSorts.enumerated(){
            if index != 0 && index % 20 == 0{temps.append(Emoji(isDelete:true))}
            temps.append(Emoji(id: id, png: "emoji_\(id)_32x32_"))
        }
        
        for temp in temps{
            var emoji = temp
            for(key, value) in emojiMapping{
                if emoji.id == value{
                    emoji.name = "\(key)"
                    emojis.append(emoji)
                }
            }
            if emoji.isDelete {emojis.append(emoji)}
        }
        
        // 判断分页是否有剩余
        let count = emojis.count & 21
        guard count != 0 else {return}
        // 添加空白表情
        for index in count..<21{
            emojis.append(index == 20 ? Emoji(isDelete: true) : Emoji(isEmpty:true))
        }
    }
    
    /// 显示 emoji 表情
    func showEmoji(content: String, font: UIFont) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: content)
        // emoji 表情的正则表达式
        let emojiPattern = "\\[.*?\\]"
        // 创建正则表达式对象，匹配 emji 表情
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        // 开始匹配，返回结果
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        
        if results.count != 0{
            for index in stride(from: results.count - 1, to: 0, by: -1){
                let result = results[index]
                // 取出 emoji 的名字
                let emojiName = (content as NSString).substring(with: result.range)
                let attachment = NSTextAttachment()
                 // 取出对应的 emoji 模型
                guard let emoji = emojis.filter({$0.name == emojiName}).first else{return attributedString}
                // 设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attributedImageStr = NSAttributedString(attachment: attachment)
                // 将图片替换为文字
                attributedString.replaceCharacters(in: result.range, with: attributedImageStr)
            }
        }
        
        return attributedString
    }
}
