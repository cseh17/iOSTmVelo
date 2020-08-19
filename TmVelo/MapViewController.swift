//
//  ViewController.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import UIKit
import MapKit
import AKSideMenu
import GoogleMobileAds

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var customAnnotationCalloutView: UIView!
    @IBOutlet weak var cacvTitle: UITextField!
    @IBOutlet weak var cacvStatus: UITextField!
    @IBOutlet weak var cacvUpperImageView: UIImageView!
    @IBOutlet weak var cacvLowerImageView: UIImageView!
    @IBOutlet weak var cacvUpperTextView: UITextField!
    @IBOutlet weak var cacvLowerTextView: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var noConnectionErrorView: UIView!
    @IBOutlet weak var noConnectionRetryButton: UIButton!
    @IBOutlet weak var noConnectionViewIcon: UIImageView!
    @IBOutlet weak var noConnectionViewText: UILabel!
    @IBOutlet weak var bannerAdView: GADBannerView!
    
    let locationManager = CLLocationManager()
    let authStatus = CLLocationManager.authorizationStatus()
    let initialZoom = 1000
    let distanceChangeSensitivity: Double = 500
    var userLocation = CLLocation()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            print("Connected to the internet!")
        } else {
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.frame
            self.view.addSubview(blurEffectView)
            noConnectionErrorView.translatesAutoresizingMaskIntoConstraints = false
            noConnectionViewIcon.image = #imageLiteral(resourceName: "NoWifi")
            noConnectionViewText.text = "Erroare conexiune. \nVerifică conexiunea la internet."
            self.view.addSubview(noConnectionErrorView)
            self.view.addConstraint(
                NSLayoutConstraint(item: self.view!,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: noConnectionErrorView,
                                   attribute: .centerX,
                                   multiplier: 1, constant: 0))
            self.view.addConstraint(
                NSLayoutConstraint(item: self.view!,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: noConnectionErrorView,
                                   attribute: .centerY,
                                   multiplier: 1,constant: 0))
            print("No internet connection!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        mapView.delegate = self
        locationManager.delegate = self
        
        // Configure adBanner and initialize adview and ad calls
        bannerAdView.adUnitID = "ca-app-pub-3182911509384087/7475995769"
        bannerAdView.rootViewController = self
        bannerAdView.load(GADRequest())
        
        
        // Check for location service authoritation
        if CLLocationManager.locationServicesEnabled(){
            switch authStatus{
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                //enableLocationServices()
                break
            case .restricted, .denied:
                break
            case .authorizedWhenInUse, .authorizedAlways:
                enableLocationServices()
                
                // Check if there is a connection, and then load the stations
                    if Reachability.isConnectedToNetwork() {
                    
                        // Load stations onto the map
                        loadStations(mapView: mapView, callingViewController: self)
                }
                break
            @unknown default:
                break
            }
        }
        
        noConnectionRetryButton.layer.cornerRadius = 5
    }

    // ------------------------------------- My Functions ----------------------------------------------------------------
    
    // Initial function to enable basic lcoation services. Sets the delegate, enables location on map and shows first user location
    func enableLocationServices (){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Set minimum distance in meters, that triggers the distance change detector
        locationManager.distanceFilter = distanceChangeSensitivity
        
        locationManager.startUpdatingLocation()
        mapView.isUserInteractionEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        
        // Initial user positionating. Sets the camera to the user location with the initialZoom setting, when the app first loads.
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: CLLocationDistance(initialZoom), longitudinalMeters: CLLocationDistance(initialZoom))
            
            // Set animation to "false" in order to disable rendering lag that blocks the UI interactions
            mapView.setRegion(region, animated: false)
        }
    }
    
    private func checkIfLocationManager() -> CLLocationCoordinate2D{
        return self.locationManager.location!.coordinate
    }
    
    func setUserLocation() -> CLLocation{
        return self.userLocation
    }
    
    // Register annotationView classes
    private func registerAnnotationViewClasses() {
        mapView.register(StationAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    //-------------------------------------------------- IBO Action --------------------------------------------------------------------
    
    @IBAction func buttonClick(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction func connectionRetry(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            print("Connected to the internet!")
            
            // Remove the last two subwiews which in this case are the blur-view and the wifi error message
            self.view.subviews.last!.removeFromSuperview()
            self.view.subviews.last!.removeFromSuperview()
            
            // Load stations onto the map
            loadStations(mapView: mapView, callingViewController: self)
            
        } else {
            print("No internet connection!")
        }
    }
}

//--------------------------------------------------- Delegate ------------------------------------------------------------------------

extension MapViewController: MKMapViewDelegate {
    
    // Function that configures the annotations that will be added to the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let stationAnnotation = annotation as? StationAnnotation {
        
            // Create the annotationViews based on the stations status. The reuseIdentifier is used to map the image to each status
            let annotationView: StationAnnotationView!
            switch stationAnnotation.statusType {
                case "Subpopulated":
                    annotationView = StationAnnotationView(annotation: stationAnnotation, reuseIdentifier: "SubpopulatedStation")
                    annotationView.image = #imageLiteral(resourceName: "MarkerSubpopulated")
                case "Suprapopulated":
                    annotationView = StationAnnotationView(annotation: stationAnnotation, reuseIdentifier: "OverpopulatedStation")
                    annotationView.image = #imageLiteral(resourceName: "MarkerOverpopulated")
                case "Offline":
                    annotationView = StationAnnotationView(annotation: stationAnnotation, reuseIdentifier: "OfflineStation")
                    annotationView.image = #imageLiteral(resourceName: "MarkerOffline")
                case "Online":
                    annotationView = StationAnnotationView(annotation: stationAnnotation, reuseIdentifier: "OnlineStation")
                    annotationView.image = #imageLiteral(resourceName: "MarkerOnline")
                default:
                    annotationView = StationAnnotationView(annotation: stationAnnotation, reuseIdentifier: "OnlineStation")
                    annotationView.image = #imageLiteral(resourceName: "MarkerOnline")
            }
            
            
            // A callout has 3 configurable parts. In order to only display the middle one, this function adds 2 dummy lables to the left and right accessoryView, each with an ignorable size of 0.1. In this way only the middle accessory will be configured (later on) and displayed
            let sideDummyAccessory = UILabel(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
            annotationView.leftCalloutAccessoryView = sideDummyAccessory
            annotationView.rightCalloutAccessoryView = sideDummyAccessory

            return annotationView
        } else {return nil}
    }
    
    // Function to configure the custom callout
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let tappedAnnotation = view.annotation as? StationAnnotation {
            
            // Set the size of the custom callout by adding width and height constraints
            let widthConstraint = NSLayoutConstraint(item: customAnnotationCalloutView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            customAnnotationCalloutView.addConstraint(widthConstraint)
            let heightConstraint = NSLayoutConstraint(item: customAnnotationCalloutView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            customAnnotationCalloutView.addConstraint(heightConstraint)
            customAnnotationCalloutView.backgroundColor = UIColor.clear
            cacvTitle.text = tappedAnnotation.stationName 
            cacvUpperTextView.text = ("Biciclete disponibile: " + ((tappedAnnotation.occupiedSpots).description))
            cacvLowerTextView.text = ("Porți libere disponibile: " + ((tappedAnnotation.emptySpots).description))
            cacvUpperImageView.image = #imageLiteral(resourceName: "TmVeloBikeIcon")
            cacvLowerImageView.image = #imageLiteral(resourceName: "TmVeloGateIcon")
            
            // Set status text color of the annotationCallout based on the status of the station
            switch tappedAnnotation.statusType {
                case "Subpopulated" :
                    cacvStatus.textColor = UIColor.init(named: "ColorSubpopulated")
                    cacvStatus.text = "Stație subpopulată"
                case "Suprapopulated" :
                    cacvStatus.textColor = UIColor.init(named: "ColorOverpopulated")
                    cacvStatus.text = "Stație suprapopulată"
                case "Offline":
                    cacvStatus.textColor = UIColor.init(named: "ColorOffline")
                    cacvStatus.text = "Stație offline"
                case "Online":
                    cacvStatus.textColor = UIColor.init(named: "ColorOnline")
                    cacvStatus.text = "Stație online"
                default:
                    cacvStatus.textColor = UIColor.init(named: "ColorOnline")
                    cacvStatus.text = "Stație online"
            }
            view.detailCalloutAccessoryView = customAnnotationCalloutView
        }
    }
    
    // Function that searches for the userLocation annotationView and sets ist canShowCallout parameter to false, in order to remove the "User Location" callout from the user location annotation. All other annotations will be unaffected.
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotation in views {
            if annotation.annotation is MKUserLocation {
                annotation.canShowCallout = false
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // LocationManager function called every time the device location has been updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentRegionSpan = getZoomLevel(region: mapView.region)
        let currentLocation = manager.location!.coordinate
        let region = MKCoordinateRegion(center: currentLocation, span: currentRegionSpan)
        mapView.setRegion(region, animated: false)
    }
    
    // Location manager function, called every time an authorization change has been detected
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationServices()
            
            // Load stations onto the map
            loadStations(mapView: mapView, callingViewController: self)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    // Location manager error handler
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("In the location there is an error \(error.localizedDescription)")
    }
}
