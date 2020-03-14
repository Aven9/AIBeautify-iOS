//
//  SettingsViewController.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/2.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSearchBar()
    }
    
    internal func prepareSearchBar() {
        self.navigationItem.searchController = searchBar
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
