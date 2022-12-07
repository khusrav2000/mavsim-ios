//
//  NewOrdersCell.swift
//  Mavsim
//
//  Created by istiqlolsoft on 02/12/22.
//

import Foundation
import UIKit

class CompletedOrdersCell: UITableViewCell {

    
    @IBOutlet weak var appID: UILabel!
    @IBOutlet weak var transportType: UILabel!
    @IBOutlet weak var entryPoint: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderAddress: UILabel!
    @IBOutlet weak var senderContact: UILabel!
    @IBOutlet weak var senderPhone: UILabel!
    
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var orderInfoBody: UIView!
    
    @IBOutlet weak var orderInfoBackground: UIView!
    
    
    var bodyViewAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(bodyViewTrapped(_:)))
        orderInfoBody.addGestureRecognizer(gesture)
        
    }
    
    @IBAction func bodyViewTrapped(_ sender: UITapGestureRecognizer) {
        bodyViewAction?()
    }
    
    
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
        
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = Colors.yellow.cgColor
        headerView.layer.cornerRadius = 10
        headerView.backgroundColor = Colors.yellow_300
        headerView.layer.shadowOpacity = 0.2
        headerView.layer.shadowOffset = .zero
        headerView.layer.shadowRadius = 2
        
        // bodyView.addBorder(toSide: .Left, withColor: Colors.yellow.cgColor, andThickness: 3)
        /* let border = CALayer()
        print("Height = ", orderInfoBody.frame.height)
        border.backgroundColor = Colors.yellow.cgColor
        border.frame = CGRect(x: orderInfoBody.frame.minX, y: orderInfoBody.frame.minY, width: 3, height: orderInfoBody.frame.height)
        orderInfoBody.layer.addSublayer(border)
         */
        
        orderInfoBody.layer.cornerRadius = 10
        orderInfoBody.backgroundColor = .white
        orderInfoBody.layer.shadowOpacity = 0.2
        orderInfoBody.layer.shadowOffset = .zero
        orderInfoBody.layer.shadowRadius = 2
        
        orderInfoBackground.layer.cornerRadius = 10
        orderInfoBackground.layer.shadowOpacity = 0.2
        orderInfoBackground.layer.shadowOffset = .zero
        orderInfoBackground.layer.shadowRadius = 2
        
        
    }
}
