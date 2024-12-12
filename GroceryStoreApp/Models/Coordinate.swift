//
//  Coordinate.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-11.
//

struct Coordinate {
    var name : String
    var longitude : Double
    var latitude : Double
    
    init(longitude :Double , latitude :Double , name : String) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}
