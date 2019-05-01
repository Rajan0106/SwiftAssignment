//
//  NetworkService.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import Alamofire

/// commpletion handler for making network request
typealias OnSuccess = (AboutCountry) -> Void
typealias OnFailure = (HTTPErrorCode) -> Void

///Error which may occur during network request
enum HTTPErrorCode: Error {
    case unknownError
    case invalideURL
    case emptyResponse
    case requestFailed(message: String)
}

///Conform to this protocol to make network call
protocol NetworkService {
    func loadCountryDetailWithCompletionHandler(_ success: @escaping OnSuccess, onFailure failure: @escaping OnFailure)
}

///Production server
class ProductionServer: NetworkService {
    func loadCountryDetailWithCompletionHandler(_ success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        guard let url = URL(string: Constants.URL.fetchDetailsEndPoint) else {
            failure(HTTPErrorCode.invalideURL)
            return
        }
        ///Creating the Alamofire request by passing the Get Request and the URL from where to fetch the same.
        let request = Alamofire.SessionManager.default.request(url,
                                                               method: Alamofire.HTTPMethod.get,
                                                               parameters: nil,
                                                               encoding: JSONEncoding.default,
                                                               headers: nil)
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 3
        Alamofire.SessionManager.default.session.configuration.urlCache = nil
        Alamofire.SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        ///handling the response from the request
        request.responseData(completionHandler: {(response) in
            switch response.result {
            case .success:
                if let responseData = response.result.value {
                    let dataString = String(data: responseData, encoding: String.Encoding.isoLatin1)
                    guard let modifiedData = dataString?.data(using: String.Encoding.utf8) else {
                        let error = NSError(domain: Constants.AppStrings.jsonError, code: 400, userInfo: nil)
                        failure(HTTPErrorCode.requestFailed(message: error.debugDescription))
                        return
                    }
                    do {
                        //since struct is decodable, we are decoding our json with the model
                        let jsonDecoder = JSONDecoder()
                        let aboutCountry  = try jsonDecoder.decode(AboutCountry.self, from: modifiedData)
                        success(aboutCountry)
                    } catch let error as NSError {
                        //Error handling
                        failure(HTTPErrorCode.requestFailed(message: error.debugDescription))
                    }
                }
            case .failure(let error as NSError):
                failure(HTTPErrorCode.requestFailed(message: error.debugDescription))
            }
        })
    }
}

class MockServer: NetworkService {
    var isTestingForRightURL: Bool!
    func loadCountryDetailWithCompletionHandler(_ success: @escaping OnSuccess, onFailure failure: @escaping OnFailure) {
        if isTestingForRightURL {
            if let data = getMockData() {
                success(data)
            } else {
                failure(HTTPErrorCode.unknownError)
            }
        } else {
            failure(HTTPErrorCode.invalideURL)
        }
    }
    //Returns mock data stored in
    func getMockData() -> AboutCountry? {
        let url = Bundle.main.url(forResource: Constants.mockDataFileName, withExtension: Constants.jsonExtensionString)
        do {
            let jsonData = try Data.init(contentsOf: url!)
            //since struct is decodable, we are decoding our json with the model
            let jsonDecoder = JSONDecoder()
            let aboutCountry  = try jsonDecoder.decode(AboutCountry.self, from: jsonData)
            return aboutCountry
        } catch {
            print(error)
        }
        return nil
    }
}
