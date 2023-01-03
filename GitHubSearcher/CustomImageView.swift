//
//  CustomImageView.swift
//  GitHubSearcher
//
//  Created by Corey Edh on 12/29/22.
//

import UIKit


let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView{
    
    var imageLoadingTask: URLSessionDataTask?
    
    
    
    func load(with urlString: String?){
        
        self.image = UIImage(systemName: "photo")
        
        guard let urlString = urlString, let url = URL(string: urlString) else{
            errorGettingImage()
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            DispatchQueue.main.async {
                self.image = imageFromCache

            }
            //finishLoading() adding loading indicator
            return
        }
        else{
            imageLoadingTask?.cancel()
            
            imageLoadingTask = URLSession.shared.dataTask(with: URLRequest(url:url)){ data, response, error in
                
                if error != nil{
                    self.errorGettingImage()
                    return
                }
                
                guard let data = data, let userImage = UIImage(data: data) else{
                    self.errorGettingImage()
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = userImage
                    self.layer.cornerRadius = self.layer.frame.height/2
                }
                
            }
            
            imageLoadingTask?.resume()
        }
        
    }
    
    private func errorGettingImage(){
        DispatchQueue.main.async {
            self.image = UIImage(named: "person.circle")
        }
        
        print("error retrieving image, set to default")
    }
    
    
}
