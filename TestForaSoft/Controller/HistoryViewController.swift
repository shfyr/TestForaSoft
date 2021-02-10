//
//  HistoryViewController.swift
//  TestForaSoft
//
//  Created by Liza Prokudina on 06.02.2021.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController {
    
    var historyArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        historyArray = Global.defaults.object(forKey: "History") as? [String] ?? [String]()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    //MARK: TableView configuration
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = historyArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "Search") as? SearchViewController {
            vc.historyItem = historyArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            Global.isFromHistoryController = true
        }
    }
    
    @objc func refresh(sender:AnyObject)
    {
        historyArray = Global.defaults.object(forKey: "History") as? [String] ?? [String]()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
}

