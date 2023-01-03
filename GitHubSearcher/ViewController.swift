//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import UIKit

class ViewController: UIViewController, UserViewModelProtocol{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = UsersViewModel()
    
    
    func updateUI(_ data:Any?) {
        
 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            

        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GitHubUserCells", bundle: nil), forCellReuseIdentifier: "GitHubUserCells")
        
        viewModel.delegate = self
    }


}

//MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCountForUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubUserCells") as? GitHubUserCells else{
            return UITableViewCell()
        }


        cell.user = viewModel.getUserForRow(indexPath)
        
        viewModel.getRepoCount(user: viewModel.getUserForRow(indexPath)?.userName) { repoCount in
            cell.repoCount = repoCount
            
            DispatchQueue.main.async {
                cell.setUpCell()
            }
          
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.pageAmount - 1{
            viewModel.page += 1
            viewModel.pageAmount += 30
            guard let searchText = searchBar.text else{
                print("failed")
                return
            }
            viewModel.getSearchData(searchText: searchText)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.getUserForRow(indexPath)
        
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else{
            return
        }
        
        detailViewController.user = user
        
        navigationController?.pushViewController(detailViewController, animated: true)
        
        
        
    }
    
    
    
}


extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.newUserSearch()

        viewModel.getSearchData(searchText: searchText)
    }
}
