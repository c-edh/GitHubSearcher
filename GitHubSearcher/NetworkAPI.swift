//
//  NetWorkAPI.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import Foundation



protocol NetworkAPIProtocol{
    
    func retrieveUserSearchData(_ data: Any?)
    func retrieveUserDetailData(_ data: UserDetail?)
    func retrieveRepoSearchData(_ data: [Items]?)
    func failedToRetrieveData()
}



class NetworkAPI{
    
    var delegate: NetworkAPIProtocol?
    
    var searchTask: URLSessionDataTask?
    var userDetailTask: URLSessionDataTask?
    var userReposTask: URLSessionDataTask?
    
    //MARK: - When user Searches
    func getSearchData(urlString: String){
        
        //Cancels old task before starting new
        self.searchTask?.cancel()
        
        guard let url = URL(string:urlString) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(K.HeaderFields.tokenHeader, forHTTPHeaderField: K.HeaderFields.authorization)
        
        self.searchTask = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                self.delegate?.failedToRetrieveData()
                return
            }
            
            guard let data = data,let userData = self.decodeSearchData(data) else{
                self.delegate?.failedToRetrieveData()
                return
            }
            
            self.delegate?.retrieveUserSearchData(userData)
        }
        
        self.searchTask?.resume()
    }
    
    //MARK: - UserDetails
    
    func getUserDetails(urlString: String){
        self.userDetailTask?.cancel()
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue(K.HeaderFields.tokenHeader, forHTTPHeaderField: K.HeaderFields.authorization)
        
        self.userDetailTask = URLSession.shared.dataTask(with: request){ data, response, error in
            
            if error != nil{
                self.delegate?.failedToRetrieveData()
                return
            }
            
            guard let data = data, let userDetailData = self.decodeUserDetailJSON(data) else{
               // print("")
                return
            }
            
            self.delegate?.retrieveUserDetailData(userDetailData)
            
        }
        userDetailTask?.resume()
        
        
        
    }
    
    //MARK: - need to rewrite for better code
    
    func getUserDetails(urlString: String, completion: @escaping (Int?) -> ()){
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue(K.HeaderFields.tokenHeader, forHTTPHeaderField: K.HeaderFields.authorization)
        
        self.userDetailTask = URLSession.shared.dataTask(with: request){ data, response, error in
            
            if error != nil{
                self.delegate?.failedToRetrieveData()
                return
            }
            
            guard let data = data, let userDetailData = self.decodeUserDetailJSON(data) else{
            
                return
            }
            
            completion(userDetailData.repos)
            
            
        }
        userDetailTask?.resume()

        
    }
    
    //MARK: - userSearchRepos

    
    func getSearchUserRepos(urlString: String){
        self.userReposTask?.cancel()
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(K.HeaderFields.tokenHeader, forHTTPHeaderField: K.HeaderFields.authorization)
        
        userReposTask = URLSession.shared.dataTask(with: request){ data, response, error in
            
            if error != nil{
                self.delegate?.failedToRetrieveData()
            }
            
            guard let data = data, let repoData = self.decodeRepoData(data) else{
                return
            }
            
            self.delegate?.retrieveRepoSearchData(repoData)
            

            
        }
        userReposTask?.resume()
        
        
        
        
    }
    
    
    
    
    //MARK: - Decoding Data
    
    private func decodeRepoData(_ data: Data) -> [Items]?{
        let decoder = JSONDecoder()
        
        do {
            let repo = try decoder.decode(RepoSearchModel.self, from: data)
            return repo.items
        } catch {
            print("error decoding json repo data\(error)")
            return nil

        }
        
    }
    
    private func decodeUserDetailJSON(_ data: Data)-> UserDetail?{
        let decoder = JSONDecoder()
        
        do {
            let newData = try decoder.decode(UserDetail.self, from: data)
            return newData
        } catch  {
            print("Error decoding JSON:\n\(error)")
            return nil
        }
        
    }
    
    
    private func decodeSearchData(_ data: Data) -> UsersModel?{
        
        let decoder = JSONDecoder()
        
        do{
            let users = try decoder.decode(UsersModel.self, from: data)
            return users
        }catch{
            print("Error decoding JSON:\n\(error)")
            return nil
        }
        
    }

    
    
}
