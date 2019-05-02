//
//  ImageProvider.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import UIKit

///This class handles the download of image and saving it to cache(NSCache) for future use.
final class ImageProvider {
    
    static let DidFinishImageDownload: Notification.Name = Notification.Name(rawValue: "com.Telstra.ImageProvider.didFinishImageDownload")
    static let keyDownloadedImage: String                = "com.Telstra.ImageProvider.downloadedImage"
    static let keyDownloadedImageForString: String       = "com.Telstra.ImageProvider.downloadedImageForString"
    static let defaultProvider: ImageProvider = {
        let shared =   ImageProvider()
        return shared
    }()
    // Making private to init makes sure that only one instance exit at any time.
    private init () {}
    // MARK: - Instance variables
    private var requestInProgress: [URL] = [URL]()
    private var totalRequest: [URL] = [URL]()
    static let MaxRequestToBeInProgress: Int = 2
    // MARK: - Cache properties
    private let cache: NSCache = NSCache<NSURL, UIImage>()
    ///Call this method to download image.
    /// It first checks image in cache and if available provides image from the cache,
    /// Otherwise makes network request
    ///
    /// - parameter urlstring: url on which network request has to be made.
    ///
    /// - returns: Image for specified url string.
    func getImageForURLString(_ urlString: String) -> UIImage? {
        guard let imageUrl = URL(string: urlString) else {
            return nil
        }
        if let image = self.cache.object(forKey: imageUrl as NSURL) {
            return image
        }
        //Image download is already in progress for urlString
        //don't start it again.
        if self.requestInProgress.contains(imageUrl) {
            return nil
        }
        //New entry in total request
        self.totalRequest.append(imageUrl)
        if  self.requestInProgress.count < ImageProvider.MaxRequestToBeInProgress {
            let urlToStartDownload = self.totalRequest.remove(at: self.totalRequest.count - 1)
            self.requestInProgress.append(urlToStartDownload)
            self.downloadImageForUrl(urlToStartDownload)
        }
        return nil
    }
    ///It will clear all the images stored in cache
    func clearCache() {
        self.cache.removeAllObjects()
    }
    ///Call this method to download image
    /// - parameter url : url on which network request has to be made.
    private func downloadImageForUrl(_ url: URL) {
        ImageDownloader.shared.downloadImageForUrl(url) {[weak self] (image, _) in
            guard let strongSelf = self else { return }
            if let pos = strongSelf.requestInProgress.firstIndex(of: url) {
                strongSelf.requestInProgress.remove(at: pos)
            }
            if strongSelf.totalRequest.isEmpty == false {
                let newURL = strongSelf.totalRequest.remove(at: strongSelf.totalRequest.count - 1)
                strongSelf.requestInProgress.append(newURL)
                strongSelf.downloadImageForUrl(newURL)
            }
            var userInfo: [String: Any] = [String: Any]()
            userInfo[ImageProvider.keyDownloadedImageForString] = url.absoluteString
            if let unwrappedImage = image {
                // Add image in NSCache
                strongSelf.cache.setObject(unwrappedImage, forKey: url as NSURL)
                userInfo[ImageProvider.keyDownloadedImage] = unwrappedImage
                print("Image download success for url -> \(url.absoluteString)")
            } else {
                userInfo[ImageProvider.keyDownloadedImage] = nil
                print("Image download failed for url -> \(url.absoluteString)")
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: ImageProvider.DidFinishImageDownload, object: nil, userInfo: userInfo)
            }
        }
    }
}
