//
//  Constants.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

///It will keep all constant belongs to Application
struct Constants {
    //MockData file name
    static let mockDataFileName = "MockData"
    //Json Extension String
    static let jsonExtensionString = "json"
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
    //Static image names
    struct Images {
        static let thumbnailPlaceholder   = "Thumbnail_Placeholder"
    }
    /// Contains custom view width and height
    struct ViewCustomSizes {
        static let NoDataAvableViewHeight: CGFloat = 50.0
        static let NoDataAvableLableHeight: CGFloat = 32.0
        static let NoDataAvableViewPaddingForBothSide: CGFloat = 50.0
    }
    ///System Fonts
    struct FontSizes {
        static let systemFont17: CGFloat = 17.0
        static let systemFont18: CGFloat = 18.0
        static let systemFont19: CGFloat = 19.0
        static let systemFont13: CGFloat = 13.0
    }
}
