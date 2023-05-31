//
//  TravelPlan.swift
//  NapTube
//
//  Created by 0aprl1 on 04/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TravelPlans: UIViewController{
    
    var trip : Trip?
    var travelPlan : TravelOptions?
    var dataController : DataController?
    var directionForOption : [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        if trip?.departure == "Current Location"{
            trip?.departure = (travelPlan?.departurePoint)!
        }else if trip?.destination == "Current Location"{
            trip?.destination = (travelPlan?.arrivalPoint)!
        }
        self.navigationItem.title = "Select Option"
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = newBackButton
        directionForOption = extractDirection(direction: travelPlan!.directionDetails)
    }
    
    @objc func cancel(sender: UIBarButtonItem){
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        controller.trip = trip
        controller.trip!.destination = ""
        controller.trip!.departure = ""
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func extractDirection(direction: [[String]]) -> [String]{
        var result = [String]()
        var directionForOption : String = ""
        for i in 0..<direction.count{
            directionForOption = direction[i][0].replacingOccurrences(of: " Underground Station", with: "")
            if direction[i].count > 1{
                for j in 1..<direction[i].count{
                    directionForOption = directionForOption + " or \(direction[i][j].replacingOccurrences(of: " Underground Station", with: ""))"
                }
            }
            result.append(directionForOption)
        }
        return result
    }
}

extension TravelPlans : UITableViewDelegate ,UITableViewDataSource {
    
    func extractContent(list: [String]) -> String {
        var stringValue = list[0]
        if list.count > 0{
            for i in 1..<list.count{
                stringValue = stringValue + "-" + list[i]
            }
        }
        return stringValue
    }
    
    func extractDuration(duration: [Double]) -> String{
        var durationInt : Double = 0
        for i in 0..<duration.count{
            durationInt += Double(duration[i])
        }
        return String(Int(durationInt))
    }
    
    func extractNumberOfStops(stops: TravelOptions, index: Int) -> Int{
        var numberOfStops = 0
        let option = stops.stopsInOptionPerLine[index]
        for i in 0..<option.count{
            numberOfStops += option[i].count
        }
        return numberOfStops
    }
    
    func returnLineColor(number: Int, index: IndexPath) -> UIColor{
        let line = travelPlan?.linesInOption[index.row][number]
        switch line{
        case "Piccadilly":
            return .init(red: 37/255, green: 62/255, blue: 144/255, alpha: 1)
        case "Jubilee":
            return .init(red: 146/255, green: 151/255, blue: 156/255, alpha: 1)
        case "Victoria":
            return .init(red: 69/255, green: 155/255, blue: 214/255, alpha: 1)
        case "Central":
            return .init(red: 219/255, green: 66/255, blue: 51/255, alpha: 1)
        case "Northern":
            return .init(red: 27/255, green: 23/255, blue: 24/255, alpha: 1)
        case "Circle":
            return .init(red: 248/255, green: 211/255, blue: 72/255, alpha: 1)
        case "District":
            return .init(red: 57/255, green: 131/255, blue: 70/255, alpha: 1)
        case "Hammersmith & City":
            return .init(red: 229/255, green: 141/255, blue: 161/255, alpha: 1)
        case "Metropolitan":
            return .init(red: 139/255, green: 26/255, blue: 91/255, alpha: 1)
        case "Bakerloo":
            return .init(red: 166/255, green: 102/255, blue: 41/255, alpha: 1)
        case "Waterloo & City":
            return .init(red: 150/255, green: 204/255, blue: 189/255, alpha: 1)
        default:
            return .white
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (travelPlan?.options.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrTime = travelPlan?.arrivalTime.count
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionJourneyCell", for: indexPath) as! OptionJourneyCell
        cell.accessoryType = .disclosureIndicator
        cell.linesName.text = "Lines: \(extractContent(list:(travelPlan?.linesInOption[indexPath.row])!))"
        cell.duration.text = extractDuration(duration: (travelPlan?.duration[indexPath.row])!) + " mins"
        cell.numberOfStops.text = "\(String(extractNumberOfStops(stops: travelPlan!, index: indexPath.row))) stops"
        cell.direction.text = "Toward: \(directionForOption![indexPath.row])"
        cell.arrival.text = "\(travelPlan!.arrivalTime[arrTime!-1].dropFirst(11).dropLast(3))"
        cell.departure.text = "\(travelPlan!.departureTime[0].dropFirst(11).dropLast(3))"
        cell.leftLine.backgroundColor = returnLineColor(number: 0, index: indexPath)
        if (travelPlan?.linesInOption[indexPath.row].count)! > 1 {
          cell.centralLine.backgroundColor = returnLineColor(number: 1, index: indexPath)
        }else{
            cell.centralLine.isHidden = true
        }
        if (travelPlan?.linesInOption[indexPath.row].count)! > 2 {
            cell.rightLine.backgroundColor = returnLineColor(number: 2, index: indexPath)
        }else{
            cell.rightLine.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CurrentJourney") as! CurrentJourney
        controller.linesInOption = travelPlan!.linesInOption[(indexPath as NSIndexPath).row]
        controller.stopsInOptionPerLine = travelPlan!.stopsInOptionPerLine[(indexPath as NSIndexPath).row]
        controller.trip = trip
        controller.dataController = dataController
        controller.durationsList = travelPlan?.duration[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
