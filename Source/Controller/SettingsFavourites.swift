//
//  SettingsFavourites.swift
//  NapTube
//
//  Created by 0aprl1 on 04/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsFavourites : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var trip : Trip?
    var dataController : DataController?
    var favouriteList : [Favourite] = []
    var previousViewController : UIViewController?
    
    @IBOutlet weak var timeDepartingArriving: UISwitch!
    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var settingsLeast: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        timeDepartingArriving.isOn = timeIsSwitch()
        settingsLeast.selectedSegmentIndex = setPreferenceLeast(preference: trip!.journeyPreference)
        fetchFavourites()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self.previousViewController {
            let vc = viewController as! PlanJourney
            back(viewController : vc)
        }
    }
    
    func fetchFavourites(){
        let fetchRequest : NSFetchRequest<Favourite> = Favourite.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "departure", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController!.viewContext.fetch(fetchRequest){
            favouriteList = result
            favouriteTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite")
        let favourite = favouriteList[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = favourite.departure!.replacingOccurrences(of: " Underground Station", with: "") + " to " + favourite.destination!.replacingOccurrences(of: " Underground Station", with: "") 
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        let favourite = favouriteList[(indexPath as NSIndexPath).row]
        trip?.departure = favourite.departure!
        trip?.destination = favourite.destination!
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteFavourite(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func timeIsSwitch() -> Bool{
        if trip?.timeIs == "Departing"{
            return false
        }else{
            return true
        }
    }
    
    func deleteFavourite(at indexPath: IndexPath) {
        let favouriteToDelete = favouriteList[(indexPath as NSIndexPath).row]
        dataController!.viewContext.delete(favouriteToDelete)
        try? dataController!.viewContext.save()
        fetchFavourites()
    }
    
    func back(viewController : PlanJourney){
        viewController.trip = trip
        viewController.dataController = dataController
    }
    
    func setPreferenceLeast(preference: String) -> Int {
        switch preference{
        case "LeastTime":
            return 0
        case "LeastInterchange":
            return 1
        case "LeastWalking":
            return 2
        default:
            break
        }
        return 3
    }
    
    @IBAction func setTime(_ sender: Any) {
        if timeDepartingArriving.isOn == true{
            trip?.timeIs = "Arriving"
        }else{
            trip?.timeIs = "Departing"
        }
    }
    
    @IBAction func settingsLeast(_ sender: Any) {
        switch settingsLeast.selectedSegmentIndex{
        case 0:
            trip?.journeyPreference = "LeastTime"
        case 1:
            trip?.journeyPreference = "LeastInterchange"
        case 2:
             trip?.journeyPreference = "LeastWalking"
        default:
            break
        }
    }
}

