//
//  OrderStatus.swift
//  Mavsim
//
//  Created by istiqlolsoft on 07/12/22.
//

import Foundation
import UIKit
import PhotosUI

class OrderStatus: UIViewController{
    var appId: Int? = nil
    
    @IBOutlet weak var selectImage: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    let vc = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
    }
    
    @IBAction func selectImageClick(_ sender: Any) {
        let alert = UIAlertController(title: "Выберите фото", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Камера", style: .default) { _ in
            self.openCamera()
        })
        
        alert.addAction(UIAlertAction(title: "Выберите из галерии", style: .default) { _ in
            self.openGallery()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func openCamera() {
        vc.sourceType = .camera
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    func openGallery() {
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
}

extension OrderStatus: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            self.image.image = image
        }
    }
}
