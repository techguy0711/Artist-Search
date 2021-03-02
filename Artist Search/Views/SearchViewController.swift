//
//  ViewController.swift
//  Artist Search
//
//  Created by Kristhian De Oliveira on 3/2/21.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var albumsCollection: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var results = [Track]()
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollection.delegate = self
        albumsCollection.dataSource = self
        setupSpinner()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)

    }
    func handleEmptyTable() {
        if results.count == 0 {
            
        }
    }
    func setupSpinner() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true
        albumsCollection.addSubview(activityIndicator)
    }
    @IBAction func onSearchButtonTapped(_ sender: Any) {
        if !(searchBar.text?.isEmpty ?? true) {
            results = searchItunesController().FetchAlbums(forArtistName: searchBar.text ?? "")
            activityIndicator.startAnimating()
            DispatchQueue.main.async {
                self.albumsCollection.reloadData()
            }
        } else {
            Toast(Title: "Field cannot be empty", Text: "Please enter valid artist name in the search field!", delay: 3)
        }
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    ///Used to display non interactive messages on the screen
    func Toast(Title:String ,Text:String, delay:Int) -> Void {
            let alert = UIAlertController(title: Title, message: Text, preferredStyle: .alert)
            self.present(alert, animated: true)
            let deadlineTime = DispatchTime.now() + .seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsCollection.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell") as! SearchResultsTableViewCell
        let albumAtRow = results[indexPath.row]
        cell.trackName.text = albumAtRow.trackName
        cell.artistName.text = albumAtRow.artistName
        cell.Genre.text = albumAtRow.primaryGenreName
        cell.releaseDate.text = albumAtRow.releaseDate
        cell.albumArtwork.load(url: URL(string: albumAtRow.artworkUrl60 ?? "")!)
        activityIndicator.stopAnimating()
        return cell
    }
}
