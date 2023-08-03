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

//class UserRegisterResponse: Codable {
//    var id: String?
//    var email: String?
//    var password: String?
//    var username: String?
//    var token: String?
//    var admin: Bool?
//    var time_stamp_utc: String?
//    var user_rincons: [Rincon]?
//    var existing_emails: [String]?
//}

class UserRegisterResponse:Codable {
    var id: String?
    var email: String?
    var password: String?
    var username: String?
    var token: String?
    var admin: Bool?
    var time_stamp_utc: String?
    var user_rincons: [Rincon]?
    var existing_emails: [String]?
    
}

//class UserToRincon:Codable{
//    var rincon_id:String!
//    var permission_view:Bool!
//    var permission_like:Bool!
//    var permission_comment:Bool!
//    var permission_post:Bool!
//    var permission_admin:Bool!
//    
//}
