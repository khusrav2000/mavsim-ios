//
//  Data.swift
//  Mavsim
//
//  Created by mac on 23/11/22.
//

import Foundation


struct IncLoadData {
    static var inCorrectLogOrPass = false
    static var serverNotResponse = false
    static var errorOnLoadData = false
    
}

struct TemporaryData {
    static var user: User? = nil
    static var statues: [Status]? = nil
    static var lastLocation: String? = nil
    static var trackPermission = false
}
