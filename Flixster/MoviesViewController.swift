//
//  MoviesViewController.swift
//  Flixster
//
//  Created by ピタソン・ラニク / Lanique Peterson on 2/7/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() // created a var of an array of array
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.isScrollEnabled = true // forces scroll
        
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
        // let cell = UITableViewCell() // <--- this is a stock cell that no one ever uses and we are going to create our own !!!
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // so that it doesn't automatically flood with thousands of movies
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // example of casting "hey, this (title) is a string, so i would like this to be a string"
        let synopsis = movie["overview"] as! String // we are pulling the API movie synopsis as a string and storing it into cell.synopsisLabel?.text = synopsis (below)
        
        //cell.textLabel!.text = title // no longer needed
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    // TODO: Get the array of movies
    // TODO: Store the movies in a property to use elsewhere
    // TODO: Reload your table view data
    // ALL TASKS COMPLETE^
}
