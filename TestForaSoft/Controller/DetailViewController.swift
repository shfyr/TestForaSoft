//
//  DetailViewController.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 06.02.2021.
//

import UIKit


class DetailViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var albumLink: String?
    var tracks = [Track]()
    var artistName: String?
    var collectionName: String?
    
    @IBOutlet weak var bandName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var detailTableView: UITableView!

    override func viewDidLoad() {

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.albumLink != nil {
    
                Network.fetchTrackJSON(urlString: "https://itunes.apple.com/lookup?id=\( self.albumLink!)&entity=song", tracks: &self.tracks)
                DispatchQueue.main.async {
                    if !self.tracks.isEmpty {
                        self.tracks.remove(at: 0)
                    self.detailTableView.reloadData()
                    } else {
                        self.showError()
                    }
                }
            }
        }
        
        detailTableView.dataSource = self
        bandName.text = artistName
        albumName.text = collectionName
    }
    
    //MARK: TableView configuration
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tracks.isEmpty {
            return 1
        }
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Track", for: indexPath)
        
        if tracks.isEmpty {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "No data availiable"
            return cell
        }
        cell.textLabel?.textAlignment = .left
        let track = tracks[indexPath.row].trackName
        cell.textLabel?.text = "\(indexPath.row + 1). \(track ?? "No data")"
        return cell
    }
    
    //MARK: Other viewController methods
    
 func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

