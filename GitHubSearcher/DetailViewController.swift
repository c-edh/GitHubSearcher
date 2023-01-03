//
//  DetailViewController.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import UIKit


class DetailViewController: UIViewController,UserViewModelProtocol{

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: CustomImageView!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userFollowersLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = UsersViewModel()
    
    var user: UserItems?
    var userRepos: RepoSearchModel?
    
    var searchRepos: RepoSearchModel?

    
    override func viewDidLoad() {
        viewModel.delegate = self
        guard let user = user?.userName else{
            return
        }
        viewModel.getUserDetail(userName: user)
        viewModel.getUserRepos(user: user,searchText: "")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "UserRepoCell", bundle: nil), forCellReuseIdentifier: "UserRepoCell")

    }
    
    
    
    private func setUPDetailView(_ detail:UserDetail){
        
        guard let user = user else{
            return
        }
        
        if let name = detail.name{
            userNameLabel.text = name
            
            userName.text = "Github:\n" + (user.userName ?? "NA")
            userName.numberOfLines = 2
            userName.isHidden = false

        }else{
            userNameLabel.text = user.userName
            userName.isHidden = true
        }
        
        userFollowingLabel.text = "Following:\n\(detail.following ?? 0)"
        userFollowingLabel.numberOfLines = 2
        
        userFollowersLabel.text = "Followers:\n\(detail.followers ?? 0)"
        userFollowersLabel.numberOfLines = 2

        bioLabel.text = detail.bio
        bioLabel.numberOfLines = 0
        

        userProfileImage.load(with: user.avatar)
        userProfileImage.layer.cornerRadius = self.userProfileImage.frame.height/2
        
        

        
        
        
    }
    
    
    func updateUI(_ data: Any?) {
        if let userDetail = data as? UserDetail{
            print("this ran")
            
            DispatchQueue.main.async {
                self.setUPDetailView(userDetail)
            }
        }else {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
    }
    
    
}



extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getUserRepoRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserRepoCell") as? UserRepoCell else {
            return UITableViewCell()
        }
        

        cell.repo = viewModel.getRepoForCell(indexPath: indexPath)
        cell.setUpCell()
        return cell
    }
    
    
    
    
    
    
}

extension DetailViewController: UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        
        guard let user = user?.userName else{
            return
        }
        
        guard let text = searchBar.text else{
            return
        }
        
        print(text)
        
        viewModel.newRepoSearch()

        viewModel.getUserRepos(user: user, searchText: text)
    }
}
