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
    
    var images: [UIImage] = []
    
    @IBOutlet weak var selectImage: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectStatusType: UIButton!
    
    @IBOutlet weak var sendStatus: UIButton!
    
    var selectedStatus: Status? = TemporaryData.statues?[0]
    
    var imagePicker: UIImagePickerController? = nil
    var alert: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectStatusType.setTitle(selectedStatus?.name ?? "", for: .normal)
        
        selectStatusType.layer.cornerRadius = 5
        sendStatus.layer.cornerRadius = 5
        selectImage.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var menuItems: [UIAlertAction] = []
        
        for st in TemporaryData.statues ?? [] {
            menuItems.append(UIAlertAction(
                title: st.name ?? "", style: .default, handler: { (_) in
                    self.selectStatus(status: st)
                }
            ))
        }
        
        menuItems.append(UIAlertAction(title: "Отмена", style: .cancel))
        
        alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        for item in menuItems {
            alert?.addAction(item)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        
    }
    
    func selectStatus(status: Status) {
        if (status.file_upload) {
            showToast(controller: self, message: "Для этого статуса необходимо выбрать файл/закрепить фото", seconds: 1)
        }
        selectedStatus = status
        selectStatusType.setTitle(status.name, for: .normal)
    }
    
    @IBAction func selectStatusAction(_ sender: Any) {
        self.present(alert!, animated: true)
    }
    
    
    @IBAction func sendStatusAction(_ sender: Any) {
        if selectedStatus!.file_upload && images.count == 0{
            showToast(controller: self, message: "Загрузите файл", seconds: 2)
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ActivityIndicatorViewController") as! ActivityIndicatorViewController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
        let data = KeychainHelper.standart.read(service: "access-token", account: "mavsim")
        
        if data == nil {
            return
        }
        let token = String(data: data!, encoding: .utf8)!
        NetworkingClient.standart.postPhotosAndStatus(token: token, appId: appId!, status: selectedStatus!.id, location: TemporaryData.lastLocation ?? "nil" , images: images) { (accept, error) in
            
            vc.dismiss(animated: true, completion: {[self] in
                if accept ?? false {
                    self.fileSuccessfullyUpload()
                } else {
                    self.showToast(controller: self, message: "Неизвестная ошибка", seconds: 2)
                }
            })
            
        }
    }
    
    func fileSuccessfullyUpload() {
        images = []
        tableView.reloadData()
        showToast(controller: self, message: "Успешно " + (selectedStatus!.name ?? ""), seconds: 2)
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
        imagePicker?.sourceType = .camera
        imagePicker?.allowsEditing = true
        if imagePicker != nil {
            self.present(imagePicker!, animated: true)
        }
    }
    
    func openGallery() {
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.allowsEditing = true
        if imagePicker != nil {
            self.present(imagePicker!, animated: true)
        }
    }
    
}

extension OrderStatus: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.deletePhoto(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatusImageCell", for: indexPath) as! OrderStatusImageCell
        cell.setValues(image: images[indexPath.row])
        /*cell.deleteButtonAction = { [unowned self] in
            self.deletePhoto(row: indexPath.row)
        }*/
        
        return cell
        
    }
    
    func deletePhoto(row: Int) {
        images.remove(at: row)
        self.tableView.reloadData()
    }
    
    
}

extension OrderStatus: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            self.images.insert(image, at: 0)
            self.tableView.reloadData()
        }
    }
}

extension OrderStatus {
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.7
        alert.view.layer.cornerRadius = 20
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
