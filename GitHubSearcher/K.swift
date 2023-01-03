//
//  GitHubURLs.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import Foundation

struct K{
    
    struct GitHubURLs{
        static let searchURL = "https://api.github.com/search/users?q="
        static let userRepoURL = "https://api.github.com/users/"
        static let githubHomeURL = "https://github.com/"
        static let userRepoSearchURL = "https://api.github.com/search/repositories?q="
        
    }
    
    static let token = "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"

    struct HeaderFields{
        static let tokenHeader = "token \(token)"
        static let authorization = "Authorization"
        
    }
    
    
}
