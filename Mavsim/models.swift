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
