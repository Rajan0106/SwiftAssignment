//
//  ImageProviderTests.swift
//  TelstraAssignmentTests
//
//  Created by m-666346 on 01/05/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import XCTest
@testable import TelstraAssignment
class ImageProviderTests: XCTestCase {
    var imageDownloadWithValidURLExpectation: XCTestExpectation?
    var imageDownloadWithInValidURLExpectation: XCTestExpectation?
    var imageDownloadFromCacheExpectation: XCTestExpectation?
    var image: UIImage?
    var isTestingForCache: Bool = false
    override func setUp() {
        super.setUp()
        let nName = ImageProvider.DidFinishImageDownload
        let selctor = #selector(didRecieveNotification(_:))
        NotificationCenter.default.addObserver(self, selector: selctor, name: nName, object: nil)
    }
    override func tearDown() {
        image = nil
        isTestingForCache = false
        imageDownloadWithValidURLExpectation = nil
        imageDownloadWithInValidURLExpectation = nil
        imageDownloadFromCacheExpectation = nil
        super.tearDown()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func testImageDownloadWithEmptyURL() {
        let image = ImageProvider.defaultProvider.getImageForURLString(TestConstants.URL.emptyURL)
        XCTAssertNil(image, "There should not image for empty string url")
    }
    func testImageDownloadWithValidURL() {
        ImageProvider.defaultProvider.clearCache()
        imageDownloadWithValidURLExpectation = expectation(description: "ImageDownloadWithValidURL")
        _ = ImageProvider.defaultProvider.getImageForURLString(TestConstants.URL.validImageURL)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(image, "Image should not be nil")
    }
    func testImageDownloadWithInValidURL() {
        ImageProvider.defaultProvider.clearCache()
        imageDownloadWithInValidURLExpectation = expectation(description: "ImageDownloadWithInValidURL")
        _ = ImageProvider.defaultProvider.getImageForURLString(TestConstants.URL.inValidImageURL)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(image, "Image should be nil. There should not be for Invalid url")
    }
    func testImageDownloadFromCache() {
        ImageProvider.defaultProvider.clearCache()
        isTestingForCache = true
        imageDownloadFromCacheExpectation = expectation(description: "testImageDownloadFromCache")
        _ = ImageProvider.defaultProvider.getImageForURLString(TestConstants.URL.validImageURL)
        waitForExpectations(timeout: 5, handler: nil)
        let image = ImageProvider.defaultProvider.getImageForURLString(TestConstants.URL.validImageURL)
        XCTAssertNotNil(image, "Image should not be nil")
    }
    //Helper methods
    // Handles notifications
    @objc func didRecieveNotification(_ notification: Notification) {
        if notification.name == ImageProvider.DidFinishImageDownload {
            let userInfo = notification.userInfo
            let urlString = userInfo?[ImageProvider.keyDownloadedImageForString] as? String
            let downloadedImage = userInfo?[ImageProvider.keyDownloadedImage] as? UIImage
            if  let unwrappedImage = downloadedImage,
                let unwrappedUrlString = urlString,
                TestConstants.URL.validImageURL == unwrappedUrlString {
                if isTestingForCache {
                    imageDownloadFromCacheExpectation?.fulfill()
                    imageDownloadFromCacheExpectation = nil
                } else {
                    image = unwrappedImage
                    imageDownloadWithValidURLExpectation?.fulfill()
                    imageDownloadWithValidURLExpectation = nil
                }
            } else {
                image = nil
                imageDownloadWithInValidURLExpectation?.fulfill()
                imageDownloadWithInValidURLExpectation = nil
            }
        }
    }
}
