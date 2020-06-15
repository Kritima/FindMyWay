//
//  Pin.swift
//  FindMyWay
//
//  Created by Kritima Kukreja on 2020-06-15.
//  Copyright © 2020 Kritima Kukreja. All rights reserved.
//

import Foundation

class Pin: NSObject, Codable {
    let name: String
    let latitude: Double
    let Longitude: Double
    
    init(name: String, latitude: Double, longitude: Double)
    {
        self.name = name;
        self.latitude = latitude
        self.Longitude = longitude
    }
}

extension Pin {
    static let pinsKey = "pins"
    
    static func save(pins: [Pin]) {
        let data = try? JSONEncoder().encode(pins)  // json encoding
        UserDefaults.standard.set(data, forKey: pinsKey)
    }
    
    static func loadPins() -> [Pin]? {
        if let data = UserDefaults.standard.value(forKey: pinsKey) as? Data,  // UserDefaults
            let pins = try? JSONDecoder().decode([Pin].self, from: data) {     // json decoding
            
            return pins
        }
        return nil
    }
}
