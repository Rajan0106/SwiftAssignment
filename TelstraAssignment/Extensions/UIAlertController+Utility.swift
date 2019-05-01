//
//  UIAlertController+Utility.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    // Showing alert with title and message.
    static func showAlertWith(title: String, message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: Constants.AppStrings.titleOK, style: UIAlertAction.Style.default, handler: nil))
        return alertVC
    }
}
