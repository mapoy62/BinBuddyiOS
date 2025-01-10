//
//  ExploreViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit

class ExploreViewController: UIViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    
    var categories = InstagramData.categories
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    
    func setupTableView() {
        //tableView.delegate = self
    }
    }
