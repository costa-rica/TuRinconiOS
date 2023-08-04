//
//  Rincon.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import Foundation

//class Rincon:Codable {
//    var id: String!
//    var name: String!
//    var name_no_spaces: String!
//    var public_status:Bool?
//    var permission_view=true
//    var permission_like=false
//    var permission_comment=false
//    var permission_post=false
//    var permission_admin=false
//
//}

// Source ChatGPT
// purpose for this one instead of above is in case the "permission" vars are not send we have default values.
class Rincon: Codable {
    var id: String
    var name: String
    var name_no_spaces: String
    var public_status: Bool?
    var member: Bool?
    var permission_view: Bool?
    var permission_like: Bool?
    var permission_comment: Bool?
    var permission_post: Bool?
    var permission_admin: Bool?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RinconCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        name_no_spaces = try container.decode(String.self, forKey: .name_no_spaces)
        public_status = try container.decodeIfPresent(Bool.self, forKey: .public_status)
        
        member = try container.decodeIfPresent(Bool.self, forKey: .member) ?? false
        
        permission_view = try container.decodeIfPresent(Bool.self, forKey: .permission_view) ?? true
        permission_like = try container.decodeIfPresent(Bool.self, forKey: .permission_like) ?? false
        permission_comment = try container.decodeIfPresent(Bool.self, forKey: .permission_comment) ?? false
        permission_post = try container.decodeIfPresent(Bool.self, forKey: .permission_post) ?? false
        permission_admin = try container.decodeIfPresent(Bool.self, forKey: .permission_admin) ?? false
    }

    init(id: String, name: String, name_no_spaces: String) {
        self.id = id
        self.name = name
        self.name_no_spaces = name_no_spaces
        self.permission_view = true
    }
    
    private enum RinconCodingKeys: String, CodingKey {
        case id, name, name_no_spaces, public_status, member, permission_view, permission_like, permission_comment, permission_post, permission_admin
    }
}

