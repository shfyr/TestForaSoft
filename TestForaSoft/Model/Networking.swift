//
//  Networking.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 08.02.2021.
//
import Foundation

class Network {
    
static func fetchTrackJSON(urlString: String, tracks: inout [Track]) {

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseTrack(json: data, tracks: &tracks)
                print(tracks)
            }
        }

    }

static func parseTrack(json: Data, tracks: inout [Track]) {
        let decoder = JSONDecoder()
        if let jsonTracks = try? decoder.decode(Tracks.self, from: json) {
            tracks = jsonTracks.results

    }
}
static func fetchAlbumJSON(urlString: String, albums: inout [Album]) {

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parseAlbum(json: data, albums: &albums)
                }
            }

        }

static func parseAlbum(json: Data, albums: inout [Album]) {
            let decoder = JSONDecoder()
            if let jsonTracks = try? decoder.decode(Albums.self, from: json) {
                albums = jsonTracks.results

        }
    }
    
}



