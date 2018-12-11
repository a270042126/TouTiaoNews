//
//  AddCategoryCell.swift
//  TouTiaoNews
//
//  Created by dd on 2018/11/29.
//  Copyright © 2018年 dd. All rights reserved.
//

import UIKit

protocol AddCategoryCellDelagate: class {
    func deleteCategoryButtonClicked(of cell: AddCategoryCell)
}

class AddCategoryCell: UICollectionViewCell, RegisterCellFromNib {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var deleteCategoryButton: UIButton!
    
    weak var delegate: AddCategoryCellDelagate?
    
    var isEdit = false {
        didSet{
            deleteCategoryButton.isHidden = !isEdit
            if titleButton.titleLabel!.text! == "推荐" || titleButton.titleLabel!.text! == "热点" {
                deleteCategoryButton.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleButton.isUserInteractionEnabled = false
    }

    @IBAction func deleteCategoryButtonClicked(_ sender: UIButton) {
        delegate?.deleteCategoryButtonClicked(of: self)
    }
}
