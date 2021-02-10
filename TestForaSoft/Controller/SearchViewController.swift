//
//  ViewController.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 06.02.2021.
//

import UIKit


class SearchViewController: UICollectionViewController,  UISearchBarDelegate {
    
    var albums = [Album]()
    var tracks = [Track]()
    var searchText = ""
    var historyArray = [String]()
    var historyItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !Global.isFromHistoryController {
            historyArray = Global.defaults.object(forKey: "History") as? [String] ?? [String]()
            self.tabBarController?.tabBar.isHidden = false
            configureSearchBar()
            
            
        } else {
            self.tabBarController?.tabBar.isHidden = true
            Global.isFromHistoryController = false
            searchText = historyItem
            searchText = searchText.replacingOccurrences(of: " ", with: "+")
            let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=50"
            loadAndShowAlbums(urlString: urlString)
        }
    }
    
    //MARK: CollectionView configuration

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Album", for: indexPath)as? AlbumCell else { fatalError("Unable to deque AlbumCell")}
        
        let album = albums[indexPath.item]
        
        if let _ = album.artworkUrl100 {
            let url = URL(string: album.artworkUrl100!)
            
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.albumImage.image = UIImage(data: data!)
                }
            }
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewContoller {
            
            vc.albumLink = String(albums[indexPath.item].collectionId)
            vc.artistName = albums[indexPath.item].artistName
            vc.collectionName = albums[indexPath.item].collectionName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: SearchBar configuration
    
    func configureSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type the album name"
        navigationItem.searchController = search
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if !(searchBar.text!.isEmpty) {
            searchText =  searchBar.text!
            searchText = searchText.trimmingCharacters(in: .whitespaces)
            historyArray.insert(searchText, at: 0)
            Global.defaults.set(historyArray, forKey: "History")
            searchText = searchText.replacingOccurrences(of: " ", with: "+")
            let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=50"
            loadAndShowAlbums(urlString: urlString )
            
        }
    }
    
    //MARK: Other viewController methods
    
    func loadAndShowAlbums (urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            Network.fetchAlbumJSON(urlString: urlString, albums: &self.albums)
            self.albums.sort { $0.collectionName.lowercased() < $1.collectionName.lowercased() }
            DispatchQueue.main.async {
                if !self.albums.isEmpty || self.historyItem != "" {
                    self.collectionView.reloadData()
                } else {
                    self.showError()
                }
            }
        }
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    

    
}



