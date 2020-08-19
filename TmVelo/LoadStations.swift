//
//  LoadStations.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import Foundation
import MapKit

let groupApiRequestThread = DispatchGroup()
var didApiRequestEndedWithSucces = false


func loadStations(mapView: MKMapView, callingViewController: MapViewController) {
    
    print("Stations loaded")
    
    // Strat a ThreadGroup in order to be able to be notified when the request on an async Thread has finished. This is neccesary in order to be able to notifiy the user in case of an error
    groupApiRequestThread.enter()
    
    // Make Api request
    makeRequest(with: "http://www.velotm.ro/Station/Read", objectType: NetworkStations.self) { (result: Result) in
        switch result {
        case .success(let responseData):
            if responseData.data.count == 0 {
                didApiRequestEndedWithSucces = false
                groupApiRequestThread.leave()
                return
            } else {
                stations = responseData.data
                DispatchQueue.main.async {
                    addStationsToMap(mapView: mapView)
                }
                
                didApiRequestEndedWithSucces = true
                groupApiRequestThread.leave()
                return
            }
        case .failure(let error):
            print(error)
            didApiRequestEndedWithSucces = false
            groupApiRequestThread.leave()
            return
        }
    }
    
    // Wait to be notified when the request has finished
    groupApiRequestThread.notify(queue: .main) {
        
        // Check if the API request finished with an error
        if !didApiRequestEndedWithSucces {
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = callingViewController.view.frame
            callingViewController.view.addSubview(blurEffectView)
            callingViewController.noConnectionErrorView.translatesAutoresizingMaskIntoConstraints = false
            callingViewController.noConnectionViewIcon.image = #imageLiteral(resourceName: "ErrorIcon")
            callingViewController.noConnectionViewText.text = "Erroare Server. \nReîncearcă mai târziu."
            callingViewController.view.addSubview(callingViewController.noConnectionErrorView)
            callingViewController.view.addConstraint(
                NSLayoutConstraint(item: callingViewController.view!,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: callingViewController.noConnectionErrorView,
                                   attribute: .centerX,
                                   multiplier: 1, constant: 0))
            callingViewController.view.addConstraint(
                NSLayoutConstraint(item: callingViewController.view!,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: callingViewController.noConnectionErrorView,
                                   attribute: .centerY,
                                   multiplier: 1,constant: 0))
        }
    }
}
