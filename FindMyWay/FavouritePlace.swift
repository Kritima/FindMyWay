//
//  Pin.swift
//  FindMyWay
//
//  Created by Kritima Kukreja on 2020-06-15.
//  Copyright © 2020 Kritima Kukreja. All rights reserved.
//

import Foundation

class FavouritePlace{
    
    var name :String
    var city :String
    var postalCode : String
    var country : String
    var latitude: Double
    var longitude: Double
    
    init(name:String, city:String, postalCode: String, country:String, latitude:Double , longitude: Double) {
        
        self.name = name
        self.city = city
        self.postalCode = postalCode
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
