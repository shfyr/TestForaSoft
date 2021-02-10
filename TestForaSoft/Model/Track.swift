//
//  Track.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 07.02.2021.
//

struct Tracks: Codable {
    var results: [Track]
}

struct Track: Codable {
    var trackName: String?
}

