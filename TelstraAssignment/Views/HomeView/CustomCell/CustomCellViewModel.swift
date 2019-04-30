//
//  CustomCellViewModel.swift
//  TelstraAssignment
//
///  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation

///Items to be shown in UITableViewRow
protocol RowItem {}

///Provides different states of Image download
enum ImageDownloadState {
    case notStarted
    case started
    case finished
    case failed
}

///Viewm model for custom cell
class CustomCellViewModel: RowItem {
    //Data to be presented in cell
    var about: AboutComponent
    //current state of image in custom cell
    var imagedownloadState: ImageDownloadState =  ImageDownloadState.notStarted
    init(about: AboutComponent) {
        self.about = about
    }
}
