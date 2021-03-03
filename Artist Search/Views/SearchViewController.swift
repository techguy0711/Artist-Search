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
    lazy var results = [Track]()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegate and datasource for tableView
        albumsCollection.delegate = self
        albumsCollection.dataSource = self
        //Setup spinner indicator
        setupSpinner()
        //Add gesture to dismiss keyboarrd when tapping outside of keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        //Search button design
        setupSearchButtonDesign()
        setupSwipeDownToRefresh()
    }
    func setupSearchButtonDesign() {
        searchButton.backgroundColor = .green
        searchButton.layer.cornerRadius = searchButton.frame.height / 2
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.green.cgColor
    }
    func setupSwipeDownToRefresh() {
        if !(searchBar.text?.isEmpty ?? true) {
            refreshControl.addTarget(self, action:  #selector(didSwipeDown), for: .valueChanged)
            albumsCollection.refreshControl = refreshControl
        }
    }
    @objc func didSwipeDown() {
        results = searchItunesController().FetchAlbums(forArtistName: searchBar.text ?? "")
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.albumsCollection.reloadData()
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
            setupSwipeDownToRefresh()
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
    ///Use to display non interactive messages on the screen
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
        refreshControl.endRefreshing()
        return cell
    }
}
