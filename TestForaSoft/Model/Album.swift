//
//  Album.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 06.02.2021.
//

import Foundation

struct Albums: Codable {
    var results: [Album]
}

struct Album: Codable {
    var collectionId: Int
    var artistName: String
    var collectionName: String
    var artworkUrl100: String?
  
}
