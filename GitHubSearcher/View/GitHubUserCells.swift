//
//  GitHubUserCells.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import UIKit

class GitHubUserCells: UITableViewCell {

    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    var user: UserItems?
    var repoCount: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(){
        guard let user = user else{
            return
        }
        profileImage.load(with: user.avatar)

        profileImage.layer.cornerRadius = profileImage.layer.frame.height/2
        
        userLabel.text = user.userName
        repoLabel.text = "Repos: " + String(repoCount ?? 0)
        
        
        
    }
    
    override func prepareForReuse() {
        repoLabel.text = ""
        userLabel.text = ""
        profileImage.image = nil
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
