//
//  PhotoTableViewController.swift
//  NewUI
//
//  Created by Amy Holt on 7/3/18.
//  Copyright © 2018 Amy Holt. All rights reserved.
//

import UIKit

class PhotoTableViewController: UITableViewController {

    var photos : [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPhotos()
    }

    func getPhotos() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            if let coreDataPhotos = try? context.fetch(Photo.fetchRequest()) as? [Photo] {
                if let unwrappedPhotos = coreDataPhotos {
                    photos = unwrappedPhotos
                    tableView.reloadData()
                }
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moveToDetail", sender: photos[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let photoDetailView = segue.destination as? PhotoDetailViewController {
                if let photoToSend = sender as? Photo {
                    photoDetailView.photo = photoToSend
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create a reusable cell 
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as UITableViewCell

        let cellPhoto = photos[indexPath.row]
            
        cell.textLabel?.text = cellPhoto.caption
        
        if let cellPhotoImageData = cellPhoto.imageData {
            if let cellPhotoImage = UIImage(data: cellPhotoImageData) {
                cell.imageView?.image = cellPhotoImage.createThumbnail()
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let photoToDelete = photos[indexPath.row]
            context.delete(photoToDelete)
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            getPhotos()
          }
        }
    }
}
