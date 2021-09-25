//
//  ViewController.swift
//  JsonDecodableSwift
//
//  Created by Raj on 21/06/17.
//  Copyright © 2017 Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // struct starting
    struct MyGitHub: Codable {
        let name: String?
        let location: String?
        let blog: URL?
        let followers: Int?
        let avatarUrl: URL?
        let repos: Int?
        // to decode constants and url
        private enum CodingKeys: String, CodingKey {
            case name
            case location
            case blog
            case followers
            case repos = "public_repos"
            case avatarUrl = "avatar_url"
        }
    } // end
    
    var imageUrl: URL?
    var newImage: UIImage?
    
    @IBOutlet weak var gname: UILabel!
    @IBOutlet weak var gituname: UITextField!
    @IBOutlet weak var glocation: UILabel!
    @IBOutlet weak var gfollowers: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var grepos: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var blog: UILabel!
    @IBOutlet weak var gravatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelStatus(value: true)
    }
    
    @IBAction func showGithubInfo(_ sender: Any) {
        let userText = gituname.text?.lowercased()
        guard let gitUrl = URL(string: "https://api.github.com/users/" + userText!) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
                                                    , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(MyGitHub.self, from: data)
                DispatchQueue.main.sync {
                    if let gimage = gitData.avatarUrl {
                        let data = try? Data(contentsOf: gimage)
                        let image: UIImage = UIImage(data: data!)!
                        self.gravatarImage.image = image
                    }
                    if let gname = gitData.name {
                        self.name.text = gname
                    }
                    if let glocation = gitData.location {
                        self.location.text = glocation
                    }
                    if let gfollowers = gitData.followers {
                        self.followers.text = String(gfollowers)
                    }
                    if let grepos = gitData.repos {
                        self.blog.text = String(grepos)
                    }
                    self.setLabelStatus(value: false)
                }
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    func setLabelStatus(value: Bool) {
        name.isHidden = value
        location.isHidden = value
        followers.isHidden = value
        blog.isHidden = value
        gname.isHidden = value
        glocation.isHidden = value
        gfollowers.isHidden = value
        grepos.isHidden = value
        
    }
}

