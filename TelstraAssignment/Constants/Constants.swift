//
//  Constants.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation

import Foundation
import UIKit

///It will keep all constant belongs to Application
struct Constants {
    
    ///It will Keep all the URL's consumed in the Application
    struct URL {
        static let fetchDetailsEndPoint = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    }
    
    ///It will keep all the Strings used in the Application.
    struct AppStrings {
        static let titleOK      = "OK"
        static let jsonError    = "JSON Error"
        static let titleError   = "Error!"
        static let offlineTitle = "Device is offline"
        static let offlineMessage = "Please check your internet connection."
        static let noDataAvailableMessage = "No Data Available, Please try again!"
        static let pullToRefresh  = "Pull to refresh"
        static let emptyString    = ""
        static let loadingText = "Loading..."
    }
}
