//
//  Models.swift
//  Mavsim
//
//  Created by istiqlolsoft on 01/12/22.
//

import Foundation

struct User: Codable {
    var Username: String
    var Password: String?
    var FullName: String
    var UserId: Int
    var ParentId: Int
    var Enabled: Bool
    var TransportNo: String
    var TransportType: String
    var TrailerNo: String
    var ParentName: String
}

struct Order: Codable {
    var id: Int
    var quantity: String?
    var weight: String?
    var code: String?
    var size: String?
    var country_id: Int?
    var is_hazard: String?
    var hazard_passport: String?
    var is_food: Bool?
    var food_temperature: String?
    var date_reg: String?
    var type_id: Int?
    var package_id: Int?
    var loading_method: Int?
    var Sender: String?
    var SenderAddress: String?
    var SenderContact: String?
    var SenderPhone: String?
    var Receiver: String?
    var ReceiverAddress: String?
    var ReceiverContact: String?
    var ReceiverPhone: String?
    var AppId: Int?
    var entry_point: String?
    var transport_id: Int?
    var dcId: Int?
    var CargoType: String?
    var Package: String?
    var Country: String?
    var Transport: String?
    var Method: String?
    var status: String?
}

struct Status: Codable {
    var id: Int
    var name: String?
    var file_upload: Bool
}






