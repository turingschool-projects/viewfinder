//
//  PhotoDetailViewController.swift
//  NewUI
//
//  Created by Amy Holt on 7/4/18.
//  Copyright © 2018 Amy Holt. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var photoDetail: UIImageView!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var photo : Photos?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let realPhoto = photo {
            title = realPhoto.caption
            emojiLabel.text = realPhoto.emojiIcon
            
            if let cellPhotoImageData = realPhoto.imageData {
                if let cellPhotoImage = UIImage(data: cellPhotoImageData) {
                    photoDetail.image = cellPhotoImage
                }
            }
            
        }
    }

}
