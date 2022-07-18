//
//  ImageDetailCollectionViewCell.swift
//  ImageGallery
//
//  Created by Venkat on 28/04/2022.
//

import UIKit

class ImageDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgDesc: UILabel!
    @IBOutlet weak var imageCollectionCell: UIImageView!
    
    override func prepareForReuse() {
        self.imageCollectionCell.image = nil
    }
    
    func setData(_ photoDetail: PhotoRecord) {
        imgDesc.text = photoDetail.name
    }
    
}
