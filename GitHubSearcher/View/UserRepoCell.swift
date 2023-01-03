//
//  UserRepoCell.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/30/22.
//

import UIKit

class UserRepoCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    
    @IBOutlet weak var repoStars: UILabel!
    @IBOutlet weak var repoForks: UILabel!
    
    var repo: Items?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(){
        
        guard let repo = repo else{
            return
        }
        
        repoName.text = repo.name
        
        repoStars.text = "Stars:\n\(repo.stars)"
        repoForks.text = "Forks:\n\(repo.forks)"
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
