//
//  Person.swift
//  project10
//
//  Created by Waterflow Technology on 11/04/2025.
//

import UIKit
// NSObject is universal base class for all Cocoa Touch classes
class Person: NSObject {
    var name: String;
    var image: String;
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
