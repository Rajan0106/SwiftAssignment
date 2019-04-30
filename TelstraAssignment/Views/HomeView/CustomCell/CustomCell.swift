//
//  CustomCell.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

/// CustomCell shows data provide by Model class AboutComponent
class CustomCell: UITableViewCell {
     static let CellIdentifier: String = "CustomCellIdentifier"
    //updates the UI components according model changes
    var cellViewModel: CustomCellViewModel? 
}
