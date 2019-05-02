//
//  FabricManager.swift
//  TelstraAssignment
//
//  Created by m-666346 on 02/05/19.
//  Copyright © 2019 m-666346. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

///Fabric Manager responsibilty to initialize all Fabric kit classes e.g. Crashlytics, Twitter, Answers etc.
final class FabricManager {
    
    ///It will initialize fabric library
    static func initializeFabric() {
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
    }
}
