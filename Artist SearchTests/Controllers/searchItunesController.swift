//
//  searchItunesController.swift
//  Artist Search
//
//  Created by Kristhian De Oliveira on 3/2/21.
//

import Foundation
///Manages REST api integration
class searchItunesController: NSObject {
    private let endpoint = "https://itunes.apple.com/search?term="
    ///Fetches albums by specified artist
    func FetchAlbums(forArtistName:String) -> [Track] {
        var tracks = [Track]()
         let searchString = forArtistName.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: endpoint + searchString) {
             if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                    if let lisTracks = try? decoder.decode(TrackResponse.self, from: data) {
                        tracks = lisTracks.results
                    }
             }
         }
     
        return tracks
    }
    
}
