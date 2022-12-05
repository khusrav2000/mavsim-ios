//
//  NewOrdersCell.swift
//  Mavsim
//
//  Created by istiqlolsoft on 02/12/22.
//

import Foundation
import UIKit

class NewOrdersCell: UITableViewCell {
    
    @IBOutlet weak var appID: UILabel!
    @IBOutlet weak var transportType: UILabel!
    @IBOutlet weak var entryPoint: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderAddress: UILabel!
    @IBOutlet weak var senderContact: UILabel!
    @IBOutlet weak var senderPhone: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var acceptButtom: UIButton!
    
    
    func setValues(order: Order) {
        setDesign()
        
        appID.text = "Заявка № \(order.AppId ?? 0)"
        transportType.text = "Вид траспорта: \(order.Transport ?? "nil")"
        entryPoint.text = "Въезд в страну получателя: \(order.entry_point ?? "nil")"
        senderName.text = "Имя: \(order.Sender ?? "nil")"
        senderAddress.text = "Адрес: \(order.SenderAddress ?? "nil")"
        senderContact.text = "Контакт: \(order.SenderContact ?? "nil")"
        senderPhone.text = "Тел: \(order.SenderPhone ?? "nil")"
    }

    
    func setDesign() {
        acceptButtom.tintColor = Colors.yellow
        
        headerView.layer.cornerRadius = 10
        headerView.backgroundColor = Colors.yellow
        
        bodyView.addBorder(toSide: .Left, withColor: Colors.yellow.cgColor, andThickness: 3)
        bodyView.layer.cornerRadius = 10
        bodyView.backgroundColor = .white
        
    }
}
