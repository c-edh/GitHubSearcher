//
//  ViewModel.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import Foundation

protocol UserViewModelProtocol{
    func updateUI(_ data: Any?)
}


class UsersViewModel{

    
    let networkAPI = NetworkAPI()
    var delegate: UserViewModelProtocol?
    
    var page = 1
    var pageAmount = 30
    
    private var users : [UserItems] = []
    private var userDetail: UserDetail?
    private var userSearchRepos: [Items]?
    
    init(){
        networkAPI.delegate = self
    }
    
    
    //MARK: - ViewController
    
    func getSearchData(searchText: String){
   
            let onPage = "&page=\(page)"
            
            print(page)
            
            let urlString = K.GitHubURLs.searchURL + searchText + onPage
            
            print(urlString)
            networkAPI.getSearchData(urlString: urlString)
            

    }
    
    func newUserSearch(){
        self.users = []
        self.page = 1
        self.pageAmount = 30
    }
    

    
    
    func getUserDetail(userName: String?){
        guard let userName = userName else{
            return
        }
        let urlString = K.GitHubURLs.userRepoURL + userName.lowercased()
        networkAPI.getUserDetails(urlString: urlString)
        
    }
    

    func getRowCountForUsers() -> Int{
        return users.count
    }
    
    
    func getUserForRow(_ indexPath: IndexPath) -> UserItems?{
        return users[indexPath.row]
    }
    
    func getRepoCount(user: String?, completion: @escaping (Int?) -> ()){
        guard let user = user else{
            return
        }
        let urlString = K.GitHubURLs.userRepoURL + user.lowercased()
        
        networkAPI.getUserDetails(urlString: urlString) { repoCount in
            completion(repoCount)
        }
        
    }
    
    
    //MARK: - Search User Repos
    func getUserRepos(user: String?, searchText: String?){
        guard let user = user else{
            print("failed at user unwrap")
            return
        }

        let urlString = K.GitHubURLs.userRepoSearchURL + "\(searchText!.replacingOccurrences(of: " ", with: "+").lowercased())+user:" + user.lowercased()
        
        
        print(urlString)
        
        networkAPI.getSearchUserRepos(urlString: urlString)
    
    }
    
    func getUserRepoRowCount() -> Int{
        guard let userSearchRepos = userSearchRepos else{
            return 0
        }
        return userSearchRepos.count
    }
    
    func getRepoForCell(indexPath: IndexPath) -> Items?{
        guard let userSearchRepos = userSearchRepos else{
            return nil
        }
        
        return userSearchRepos[indexPath.row]
    }
    
    
    func newRepoSearch(){
        self.userSearchRepos = []
        self.page = 1
        self.pageAmount = 30
        
    }
    
    
}

//MARK: - NetworkProtocol

extension UsersViewModel: NetworkAPIProtocol{

    

    
    
    func retrieveUserSearchData(_ data: Any?) {
        guard let userData = data as? UsersModel else{
            print("error retrieving data, failed on viewmodel")
            return
        }
        
       // self.users = []

            for user in userData.items{
                users.append(user)
            }
            
        
        //self.users = userData
        
        print(userData.items.count)
        delegate?.updateUI(nil)
    }
    
    func retrieveUserDetailData(_ data: UserDetail?) {
        guard let userDetail = data else{
            print("this ran derera;")
            return
        }
        
        print("this retrieve")
        self.userDetail = userDetail
        
        delegate?.updateUI(userDetail)
        
    }
    
    
    func retrieveRepoSearchData(_ data: [Items]?) {
        guard let userSearchRepos = data else{
            return
        }
        self.userSearchRepos = userSearchRepos
        
        self.delegate?.updateUI(self.userSearchRepos)
    }
    
    func failedToRetrieveData() {
        print("Failed")
    }
    
    
}
