//
//  User.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import Foundation

class User:Codable {
    var id: String?
    var email: String?
    var password: String?
    var username: String?
    var token: String?
    var admin: Bool?
    var time_stamp_utc: String?
//    var user_rincons: [[String]]?
    var user_rincons: [Rincon]?
    
}

class UserLoginResponse: Codable {
    var token: String!
    var user_id: String!
//    var user_rincons: [[String]]
    var user_rincons: [Rincon]?
}
