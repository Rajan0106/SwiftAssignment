//
//  TestConstants.swift
//  TelstraAssignmentTests
//
//  Created by m-666346 on 01/05/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
///It will keep all constant belongs to Application Testing
struct TestConstants {
    ///It will Keep all the URL's consumed in the Application Testing
    struct URL {
        static let baseURL = "http://upload.wikimedia.org/wikipedia/commons/thumb/"
        static let validImageURL = baseURL+"6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
        static let inValidImageURL = baseURL+"/6/6b/American_Beaver.jpg/220px-American_Beave"
        static let emptyURL = ""
    }
}
