//
//  ViewController.swift
//  OpenNews
//
//  Created by Taeyoung Son on 2022/10/09.
//

import UIKit

class ArticleListVC: UIViewController {

    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        if let url = URL(string: "https://6343b75cb9ab4243cad5ec9e.mockapi.io/articles"){
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard let data = data else {return}
                print("data  \(data)")
                do {
                    let articles = try JSONDecoder().decode([Article].self, from: data)
                    print(articles)
                } catch {
                    print(error)
                }
                
            }.resume()
        }
    }
}

