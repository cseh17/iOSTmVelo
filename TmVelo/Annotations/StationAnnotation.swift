//
//  StationAnnotation.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Stations annotation
class StationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title, stationName: String?
    var occupiedSpots, emptySpots, maxNumberOfBikes: Int
    var status, statusType: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, stationName: String, occupiedSpots: Int, emptySpots: Int, maxNumberOfBikes: Int, status: String, statusType: String) {
        
        self.coordinate = coordinate
        self.title = title
        self.stationName = stationName
        self.occupiedSpots = occupiedSpots
        self.emptySpots = emptySpots
        self.maxNumberOfBikes = maxNumberOfBikes
        self.status = status
        self.statusType = statusType
    }
}
