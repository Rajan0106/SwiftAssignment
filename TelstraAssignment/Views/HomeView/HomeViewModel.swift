//
//  ViewController.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

//Handles communication from view Model
protocol HomeViewModelDelegate: AnyObject {
    func fetched(country: AboutCountry)
    func fetchCountryDetailFailedWith(error: HTTPErrorCode)
}

class HomeViewModel: NSObject {
    var aboutCountry: AboutCountry?
    weak var delegate: HomeViewModelDelegate?
    
    ///It fetches data from server
    /// - parameter server : The server on which network call will be made. By default it is production server
    func fetchAboutCountryDetailFromService(_ server: NetworkService = ProductionServer()) {
        server.loadCountryDetailWithCompletionHandler({ (aboutCountry) in
            // Succesfull request
            self.delegate?.fetched(country: aboutCountry)
        }, onFailure: { error in
            //failure request
            self.delegate?.fetchCountryDetailFailedWith(error: error)
        })
    }
    
    ///Removes any values from list when all properties inside value is nil
    func removeInfoFromListIfAllPropertiesAreNil() {
        if let infoList = self.aboutCountry?.infoList {
            let nonNilInfoList = infoList.filter { ($0.title != nil) ||
                ($0.description != nil) ||
                ($0.imageHRef != nil) }
            self.aboutCountry?.infoList = nonNilInfoList
        }
    }
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
