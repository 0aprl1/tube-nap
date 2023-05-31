//
//  PlanJourney.swift
//  NapTube
//
//  Created by 0aprl1 on 03/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlanJourney: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var trip : Trip?
    var dataController : DataController?
    
    @IBOutlet weak var departureField: UITextField!
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var planJourney: UIButton!
    @IBOutlet weak var preferencesButton: UIBarButtonItem!
    @IBOutlet weak var netoworkButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationController?.delegate = self
        departureField.delegate = self
        destinationField.delegate = self
        departureField.text = trip?.departure
        destinationField.text = trip?.destination
        datePicker.datePickerMode = .dateAndTime
        datePicker.setDate(trip!.fullDate, animated: false)
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(24.0 * 3600.0 * 60)
        trip?.date = setDepartingDate(date: datePicker.date)
        trip?.departureHour = setDepartingHour(date: datePicker.date)
        canRequest()
    }
    
    func errorNoServiceAtNight(){
        let alert = UIAlertController(title: "Error", message: "No Service at this time of the night", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    func errorConsiderWalking(){
        let alert = UIAlertController(title: "Better to Walk", message: "It's not far from here!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { action in
            self.trip?.departure = ""
            self.trip?.destination = ""
            self.departureField.text = self.trip!.departure
            self.destinationField.text = self.trip!.destination
        }))
        self.present(alert, animated: true, completion: nil)
        preferencesButton.isEnabled = true
        netoworkButton.isEnabled = true
        planJourney.isEnabled = true
        resetButton.isEnabled = true
    }
    
    func errorSameStations(){
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: "Same Stations", message: "Select different", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { action in
            self.trip!.destination = ""
            self.destinationField.text = self.trip?.destination
        }))
        self.present(alert, animated: true, completion: nil)
        preferencesButton.isEnabled = true
        netoworkButton.isEnabled = true
        planJourney.isEnabled = true
        resetButton.isEnabled = true
    }
    
    func canRequest(){
        if trip?.departure == "" || trip?.destination == "" || trip?.date == "" || trip?.departureHour == "" {
            planJourney.isEnabled = false
        }else{
            planJourney.isEnabled = true
        }
    }
    
    func setDepartingHour(date: Date) -> String{
        let TimePeriodFormatter = DateFormatter()
        TimePeriodFormatter.dateFormat = "HHmm"
        return TimePeriodFormatter.string(from: date)
    }
    
    
    func setDepartingDate(date: Date) -> String {
        let DatePeriodFormatter = DateFormatter()
        DatePeriodFormatter.dateFormat = "yyyyMMdd"
        return DatePeriodFormatter.string(from: date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let controller: TflStops
        controller = storyboard?.instantiateViewController(withIdentifier: "TflStops") as! TflStops
        if textField == departureField{
            controller.senderIsDeparture = true
        }else{
            controller.senderIsDeparture = false
        }
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func preferencesPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SettingsFavuorites") as! SettingsFavourites
        controller.trip = trip
        controller.dataController = dataController
        controller.previousViewController = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func networkPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewNetworkMap") as! ViewNetworkMap
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func pickerCahnged(_ sender: UIDatePicker) {
        trip?.date = setDepartingDate(date: sender.date)
        trip?.departureHour = setDepartingHour(date: sender.date)
        trip?.fullDate = datePicker.date
        canRequest()
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        trip?.destination = ""
        trip?.departure = ""
        datePicker.date = Date()
        planJourney.isEnabled = false
        departureField.text = trip!.departure
        destinationField.text = trip!.destination
    }
    
    @IBAction func planJourney(_ sender: Any) {
        activityIndicator.startAnimating()
        destinationField.isEnabled = false
        departureField.isEnabled = false
        preferencesButton.isEnabled = false
        netoworkButton.isEnabled = false
        resetButton.isEnabled = false
        planJourney.isEnabled = false
        datePicker.isEnabled = false
        if trip?.departure != trip!.destination{
            let controller = storyboard?.instantiateViewController(withIdentifier: "TravelPlans") as! TravelPlans
            DispatchQueue.global().async { [weak self] in
                if self!.trip?.departure == "Current Location"{
                    self!.trip?.destinationCoordinates = self!.trip!.stationsCoordinates[self!.trip!.destination]!
                }else if self!.trip!.destination == "Current Location"{
                    self!.trip?.departureCoordinates = self!.trip!.stationsCoordinates[self!.trip!.departure]!
                }else{
                    self!.trip?.departureCoordinates = self!.trip!.stationsCoordinates[self!.trip!.departure]!
                    self!.trip?.destinationCoordinates = self!.trip!.stationsCoordinates[self!.trip!.destination]!
                }
                controller.travelPlan =  requestTravelPlanner(originLat: (self?.trip!.departureCoordinates[0])!, originLon: (self?.trip!.departureCoordinates[1])!, destinationLat: (self?.trip!.destinationCoordinates[0])!, destinationLon: (self?.trip!.destinationCoordinates[1])!, date: self!.trip!.date, departureHour: self!.trip!.departureHour, timeIs: self!.trip!.timeIs, journeyPreference: self!.trip!.journeyPreference)
                if controller.travelPlan?.options.count == 0{
                    self!.trip?.departure = ""
                    self!.trip?.destination = ""
                    DispatchQueue.main.async {
                        self!.errorConsiderWalking()
                        self!.departureField.text = self?.trip?.departure
                        self!.destinationField.text = self?.trip?.destination
                        self!.departureField.isEnabled = true
                        self!.destinationField.isEnabled = true
                        self!.datePicker.isEnabled = true
                        self!.planJourney.isEnabled = false
                        self!.activityIndicator.stopAnimating()
                    }
                }
                controller.trip = self!.trip
                controller.dataController = self!.dataController
                DispatchQueue.main.async {
                    self!.activityIndicator.stopAnimating()
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }else{
            errorSameStations()
        }
    }
}



