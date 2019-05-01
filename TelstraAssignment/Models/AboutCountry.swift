//
//  AboutCountry.swift
//  TelstraAssignment
//
//  Created by m-666346 on 30/04/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation

///Provides information
protocol Information: Decodable {
    var title: String? { get set}
    var description: String? {get set}
    var imageHRef: String? {get set}
}

/// It provides information of country
struct AboutComponent: Information, Decodable {
    var title: String?
    var description: String?
    var imageHRef: String?
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageHRef = "imageHref"
    }
}

//Country
struct AboutCountry: Decodable {
    var title: String
    var infoList: [AboutComponent]?
    enum CodingKeys: String, CodingKey {
        case title
        case infoList = "rows"
    }
}
