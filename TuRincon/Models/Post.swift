//
//  Post.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import Foundation

class Post: Codable{
    var post_id: String!
    var user_id: String!
    var username: String!
    var rincon_id: String!
    var date_for_sorting_ios: String!
    var post_text_ios:String?
    var image_filenames_ios: String?
    var image_files_array: [String]?
    var video_exists:Bool?
    var video_file_name: String?
    var rincon_dir_path: URL?

//    var comments: [[String:String]]?
    var comments: [Comment]?
    var liked:Bool!
    var like_count: Int!
    var check_height_flag: Bool?
    var delete_post_permission: Bool?
}


class Comment: Codable {
    var comment_id: String!
    var date: String!
    var username: String!
    var comment_text: String!
    var delete_comment_permission: Bool!
}
