//
//  ViewController.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel: NSObject {
    var aboutCountry: AboutCountry?
}

extension HomeViewModel: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aboutCountry?.infoList?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: CustomCell.CellIdentifier, for: indexPath) as?  CustomCell else {
            return UITableViewCell()
        }
        if aboutCountry?.infoList?.isEmpty == false,
            indexPath.row < (aboutCountry?.infoList?.count)! {
            if let about = aboutCountry?.infoList![indexPath.row] {
                customCell.cellViewModel = CustomCellViewModel(about: about)
            }
        }
        return customCell
    }
}

