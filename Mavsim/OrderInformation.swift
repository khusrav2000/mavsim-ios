//
//  OrderInformation.swift
//  Mavsim
//
//  Created by istiqlolsoft on 06/12/22.
//

import Foundation
import UIKit

class OrderInformation: UIViewController {
    
    var order: Order? = nil
    
    
    @IBOutlet weak var orderInfoView: UIView!
    @IBOutlet weak var senderInfoView: UIView!
    @IBOutlet weak var recipientInfoView: UIView!
    @IBOutlet weak var orderInfoBackground: UIView!
    @IBOutlet weak var recieperInfoBackground: UIView!
    @IBOutlet weak var senderInfoBackground: UIView!
    
    @IBOutlet weak var appId: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var dcId: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var isHazard: UILabel!
    @IBOutlet weak var hazzardPasswort: UILabel!
    @IBOutlet weak var isFood: UILabel!
    @IBOutlet weak var foodTemperature: UILabel!
    @IBOutlet weak var dataReg: UILabel!
    @IBOutlet weak var appIdTwo: UILabel!
    @IBOutlet weak var package: UILabel!
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var method: UILabel!
    
    @IBOutlet weak var senderInfo: UILabel!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var senderAddress: UILabel!
    @IBOutlet weak var senderContact: UILabel!
    @IBOutlet weak var senderPhone: UILabel!
    
    @IBOutlet weak var recieperInfo: UILabel!
    @IBOutlet weak var receiver: UILabel!
    @IBOutlet weak var receiverAddress: UILabel!
    @IBOutlet weak var receiverContact: UILabel!
    @IBOutlet weak var receiverPhone: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewBorder(vw: orderInfoView)
        setViewBorder(vw: orderInfoBackground)
        setViewBorder(vw: senderInfoView)
        setViewBorder(vw: senderInfoBackground)
        setViewBorder(vw: recipientInfoView)
        setViewBorder(vw: recieperInfoBackground)
        
        orderInfoView.backgroundColor = .white
        senderInfoView.backgroundColor = .white
        recipientInfoView.backgroundColor = .white
        
        setValues()
        
    }
    
    
    func setViewBorder(vw: UIView) {
        vw.layer.cornerRadius = 5
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowRadius = 2
        vw.layer.shadowOffset = .zero
    }
    
    func setValues() {
        appId.text = "Данные заказа № \(order?.AppId ?? 0)"
        cargoType.text = "Наименование груза: \(order?.CargoType ?? "")"
        quantity.text = "Объем (м^3): \(order?.quantity ?? "")"
        weight.text = "Вес (кг): \(order?.weight ?? "")"
        dcId.text = "Товарный код: \(order?.dcId ?? 0)"
        size.text = "Размер (ДхШхВ): \(order?.size ?? "")"
        isHazard.text = "Опасный груз: \(order?.is_hazard ?? "Нет")"
        hazzardPasswort.text = "Паспорт безопасносты: \(order?.hazard_passport ?? "")"
        isFood.text = "Продовольсвенный товар: \((order?.is_food ?? false) ? "Да" : "Нет" )"
        foodTemperature.text = "Режим температуры: \(order?.food_temperature ?? "")"
        dataReg.text = "Дата регистрации: \(order?.date_reg ?? "")"
        appIdTwo.text = "ИД заявки: \(order?.AppId ?? 0)"
        package.text = "Тип упаковки: \(order?.Package ?? "")"
        Country.text = "Страна: \(order?.Country ?? "")"
        method.text = "Метод погрузки: \(order?.Method ?? "")"
        
        senderInfo.text = "Данные отправителя"
        sender.text = "Имя: \(order?.Sender ?? "")"
        senderAddress.text = "Адрес: \(order?.SenderAddress ?? "")"
        senderContact.text = "Контакт: \(order?.SenderContact ?? "")"
        senderPhone.text = "Тел: \(order?.SenderPhone ?? "")"
        
        recieperInfo.text = "Данные получателя"
        receiver.text = "Имя: \(order?.Receiver ?? "")"
        receiverAddress.text = "Адрес: \(order?.ReceiverAddress ?? "")"
        receiverContact.text = "Контак: \(order?.ReceiverContact ?? "")"
        receiverPhone.text = "Тел: \(order?.ReceiverPhone ?? "")"
        
    }
}
