//
//  UserModel.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import Foundation



//MARK: - Users list model
class UsersModel : Codable {
    var items : [UserItems]?
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}


class UserItems : Codable{
    var userName : String?
    var avatar : String?
    var userDetail : UserDetail?
    
    private enum CodingKeys : String, CodingKey{
        case userName = "login"
        case avatar = "avatar_url"
    }
}


//MARK: - User detail model
class UserDetail : Codable{
    
    var name : String?
    var avatar : String?
    var repos : Int?
    var bio : String?
    var email : String?
    var location : String?
    var joiningDate : String?
    var followers : Int?
    var following : Int?
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case avatar = "avatar_url"
        case repos = "public_repos"
        case bio = "bio"
        case email = "email"
        case location = "location"
        case joiningDate = "created_at"
        case followers = "followers"
        case following = "following"
    }
}


struct ReposModel : Codable{
    
    var name : String?
    var stars : Int?
    var forks : Int?
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case stars = "stargazers_count"
        case forks  = "forks_count"
    }
}




//MARK: - User repo search model
struct RepoSearchModel : Codable{
    var items : [Items]?
}

struct Items : Codable{
    var name : String?
    var stars : Int?
    var forks : Int?
    
    private enum CodingKeys : String, CodingKey{
        case name = "name"
        case stars = "stargazers_count"
        case forks  = "forks_count"
    }
}
