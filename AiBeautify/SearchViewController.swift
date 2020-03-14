//
//  SearchViewController.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/2.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchBar = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSearchBar()
        // Do any additional setup after loading the view.
    }
    
    internal func prepareSearchBar() {
        self.navigationItem.searchController = searchBar
    }

}
