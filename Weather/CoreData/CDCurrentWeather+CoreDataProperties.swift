//
//  CDCurrentWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Khushbuben Patel on 16/10/23.
//
//

import Foundation
import CoreData


extension CDCurrentWeather {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCurrentWeather> {
        return NSFetchRequest<CDCurrentWeather>(entityName: "CDCurrentWeather")
    }
    
    @NSManaged public var city: String?
    @NSManaged public var date: String?
    @NSManaged public var humidity: String?
    @NSManaged public var icon: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var temp: String?
    @NSManaged public var weatherType: String?
    @NSManaged public var wind: String?
    
}

extension CDCurrentWeather : Identifiable {
}
