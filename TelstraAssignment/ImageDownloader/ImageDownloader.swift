//
//  ImageDownloader.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case invalidURL
    case message(message: String)
    case unknownError
    case requestFailed(statusCode: Int, message: String)
}

typealias ImageDownloadCompletionHandler = (UIImage?, ImageDownloadError?) -> Swift.Void

/// conform this protocol to download images from server.
protocol ImageDownloadable {
    func downloadImageForUrl(_ url: URL, withCompletionHandler completionHandler:@escaping ImageDownloadCompletionHandler) -> Swift.Void
}

final class ImageDownloader: ImageDownloadable {
    static let shared = ImageDownloader()
    private init () {}
    ///Handles image download
    let imageDownloaderSession: URLSession = {
        let  configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 60.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.urlCache = nil
        configuration.httpCookieStorage          = nil
        let session = URLSession(configuration: configuration)
        return session
    }()
    /// downloads image from server
    func downloadImageForUrl(_ url: URL, withCompletionHandler completionHandler:@escaping ImageDownloadCompletionHandler) -> Swift.Void {
        self.imageDownloaderSession.dataTask(with: url) { (data, urlResponse, error) in
            print(url)
            if let error = error {
                completionHandler(nil, ImageDownloadError.message(message: error.localizedDescription))
            }
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completionHandler(nil, ImageDownloadError.unknownError)
                return
            }
            guard let data = data, httpUrlResponse.statusCode == 200 else {
                let message = HTTPURLResponse.localizedString(forStatusCode: httpUrlResponse.statusCode)
                completionHandler(nil, ImageDownloadError.requestFailed(statusCode: httpUrlResponse.statusCode, message: message))
                return
            }
            let image = UIImage(data: data)
            completionHandler(image, nil)
            }.resume()
    }
}
