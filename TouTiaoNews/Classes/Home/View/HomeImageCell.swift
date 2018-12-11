//
//  HomeImageCell.swift
//  News
//
//

import UIKit
import Kingfisher

class HomeImageCell: UICollectionViewCell, RegisterCellFromNib {

    var image = ImageList() {
        didSet {
            imageView.kf.setImage(with: URL(string: image.urlString)!)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

}
