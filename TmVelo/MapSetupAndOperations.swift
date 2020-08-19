//
//  MapSetupAndOperations.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import MapKit

var stations: [NetworkStations.StationData] = []

// Function that determinates the actual zoom level, and saves it for future map interactions. Every single zoom change is tracked and saved
func getZoomLevel(region: MKCoordinateRegion) -> MKCoordinateSpan {
    let regionSpan = region.span
    return regionSpan
}

// Function that iterates the request results, and adds the bikes to the map
func addStationsToMap(mapView: MKMapView) {
    
    // Get Annotations from map, and remove them, in order to avoid duplicates
    let actualAnnotations = mapView.annotations
    mapView.removeAnnotations(actualAnnotations)
    
    for station in stations {
        let coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        let stationName = station.stationName
        let occupiedSpots = station.ocuppiedSpots
        let emptySpots = station.emptySpots
        let maxNumberOfBikes = station.maximumNumberOfBikes
        let status = station.status
        let statusType = station.statusType
        let annotation = StationAnnotation(coordinate: coordinate, title: "", stationName: stationName, occupiedSpots: occupiedSpots, emptySpots: emptySpots, maxNumberOfBikes: maxNumberOfBikes, status: status, statusType: statusType)
        
        // Load the annotations on a async thread in order to display them instantaniously
        DispatchQueue.main.async {
            mapView.addAnnotation(annotation)
        }
    }
}

