//
//  TflStops.swift
//  NapTube
//
//  Created by 0aprl1 on 03/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class TflStops : UIViewController, UITableViewDelegate ,UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, CLLocationManagerDelegate {
    
    
    var trip : Trip?
    var dataController : DataController?
    var choice : String = ""
    var senderIsDeparture : Bool?
    var allStopsSearch : [String] = []
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var tflTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Stop"
        allStopsSearch = trip!.allStops
        tflTable.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStopsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleStop")
        let allStopsRow = allStopsSearch[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = allStopsRow
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choice = (tableView.cellForRow(at: indexPath)?.textLabel!.text)!
        let controller: PlanJourney
        controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        if senderIsDeparture == true{
            trip?.departure = choice
        }else{
            trip?.destination = choice
        }
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            allStopsSearch = trip!.allStops.sorted()
            tflTable.reloadData()
            return
        }
        allStopsSearch = trip!.allStops.filter({(allStops: String) -> Bool in
            allStops.contains(searchText.capitalized)}).sorted()
        tflTable.reloadData()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        let controller: PlanJourney
        controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            if senderIsDeparture == true{
                trip?.departure = "Current Location"
                trip?.departureCoordinates = [String(format: "%f", locationManager.location!.coordinate.latitude), String(format: "%f", locationManager.location!.coordinate.longitude)]
                trip?.destinationCoordinates = trip!.destinationCoordinates
                trip?.destination = trip!.destination
            }else{
                trip?.destination = "Current Location"
                trip?.destinationCoordinates = [String(format: "%f", locationManager.location!.coordinate.latitude), String(format: "%f", locationManager.location!.coordinate.longitude)]
                trip!.departureCoordinates = trip!.departureCoordinates
                trip!.departure = trip!.departure
            }
            controller.trip = trip
            controller.dataController = dataController
            navigationController?.pushViewController(controller, animated: true)
        case .denied, .restricted :
            let alert = UIAlertController(title: "Can't Access Location", message: "Check Location Preferences", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        CLLocationManager.locationServicesEnabled()
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    func back(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        controller.trip = trip
        controller.dataController = dataController
        controller.planJourney.isEnabled = true
        controller.resetButton.isEnabled = true
        controller.preferencesButton.isEnabled = true
        controller.netoworkButton.isEnabled = true
        navigationController?.pushViewController(controller, animated: true)
    }

    
    @IBAction func currentLocatinoPressed(_ sender: Any) {
        checkLocationServices()
    }
}
