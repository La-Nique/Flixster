//
//  MoviesViewController.swift
//  Flixster
//
//  Created by ピタソン・ラニク / Lanique Peterson on 2/7/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() // created a var of an array of array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! // url is important, within this api there is an array of dictionaries or "hashes"
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movies = dataDictionary["results"] as! [[String:Any]] // hey dictionary, i want you to look in that dataDictionary and get out results
            
            //how to make the table view update:
            self.tableView.reloadData() // this will call the functions (tableviews) below again 20 times after the screen loads and populate the screen with titles movies/data we want.
            
            print(dataDictionary)

           }
        }
        task.resume()

    }
    
    //functions can be in any order
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // example of casting "hey, this (title) is a string, so i would like this to be a string"
        
        cell.textLabel?.text = title
        
        return cell
    }
    // TODO: Get the array of movies
    // TODO: Store the movies in a property to use elsewhere
    // TODO: Reload your table view data
    
}
