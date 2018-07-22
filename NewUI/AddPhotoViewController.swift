//
//  AddPhotoViewController.swift
//  NewUI
//
//  Created by Amy Holt on 7/3/18.
//  Copyright © 2018 Amy Holt. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var emojiIcon: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Since the phone can be held in any orientation when you take the picture (sideways, upside down, etc), we have to rotate the photo to make sure it's upright:
            let fixedImage = ImageUtilities.fixImageOrientation(imageSource: selectedImage)
            newImageView.image = fixedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findPhotoTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePhotoTapped(_ sender: UIButton) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let photoToSave = Photo(entity: Photo.entity(), insertInto: context)
            photoToSave.caption = captionText.text
            photoToSave.emojiIcon = emojiIcon.text
            
            if let userImage = newImageView.image {
                if let userImageData = UIImagePNGRepresentation(userImage) {
                    photoToSave.imageData = userImageData
                }
            }

            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            
            navigationController?.popViewController(animated: true)
        }
        
    }
}
