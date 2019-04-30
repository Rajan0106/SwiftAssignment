//
//  ViewController.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private var listTableView = UITableView()
    // MARK: - View life cycle methods
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    private func setupTableView() {
        listTableView.backgroundColor    = .white
        listTableView.cellLayoutMarginsFollowReadableWidth = false
        listTableView.tableFooterView    = UIView(frame: .zero)
        listTableView.rowHeight          = UITableView.automaticDimension
        listTableView.estimatedRowHeight = 150
        listTableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.CellIdentifier)
    }
}

