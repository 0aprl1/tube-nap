//
//  TflRequests.swift
//  NapTube
//
//  Created by 0aprl1 on 03/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

let app_id = "c3bb7a52"
let app_key = "950881f1c1e36f38c6372a054393bb0a"

func requestAllLinesName() -> [String] {
    
    var response = [String]()
    
    let decoder = JSONDecoder()
    let tflLines : [Line]
    let url = URL.init(string: "https://api.tfl.gov.uk/Line/Mode/tube/Route?app_id=\(app_id)&app_key=\(app_key)")!
    let data: Data = try! Data.init(contentsOf: url)

    do {
        tflLines = try decoder.decode([Line].self, from: data)
        for station in tflLines {
            response.append(station.name)
        }
    }catch{
        print(error)
    }
    return response
}

func requestNameAllStationForALine(lineName : String) -> [String]{
    
    var response = [String]()
    
    let decoder = JSONDecoder()
    let line : [lineStops]
    let url = URL.init(string: "https://api.tfl.gov.uk/Line/\(lineName.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "-"))/stoppoints?app_id=\(app_id)&app_key=\(app_key)")!
    let data: Data = try! Data.init(contentsOf: url)
    
    do {
        line = try decoder.decode([lineStops].self, from: data)
        for station in line {
            response.append(station.commonName)
        }
    }catch{
        print(error)
    }
    return response
}

func requestCoordinatesForAllStationForALine(lineName : String) -> [String : [String]]{
    
    var response = [String : [String]]()
    
    let decoder = JSONDecoder()
    let line : [lineStops]
    let url = URL.init(string: "https://api.tfl.gov.uk/Line/\(lineName.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "-"))/stoppoints?app_id=\(app_id)&app_key=\(app_key)")!
    let data: Data = try! Data.init(contentsOf: url)
    
    do {
        line = try decoder.decode([lineStops].self, from: data)
        for station in line {
            response[station.commonName] = [String(station.lat), String(station.lon)]
        }
    }catch{
        print(error)
    }
    return response
}

func requestTravelPlanner(originLat: String, originLon: String, destinationLat: String, destinationLon : String, date: String, departureHour: String, timeIs : String, journeyPreference : String ) -> TravelOptions{
    
    var options = [[[String : [String]]]]()
    var duration = [[Double]]()
    var linesInOption = [[String]]()
    var stopsInOptionPerLine = [[[String]]]()
    var departureTime = [String]()
    var arrivalTime = [String]()
    var directionDetails = [[String]]()
    var departurePoint : String = ""
    var arrivalPoint : String = ""
    
    
    let decoder = JSONDecoder()
    let travelPlanner : TravelPlanner
    let url = URL.init(string: "https://api.tfl.gov.uk/Journey/JourneyResults/\(originLat)%2C\(originLon)/to/\(destinationLat)%2C\(destinationLon)?date=\(date)&time=\(departureHour)&timeIs=\(timeIs)&journeyPreference=\(journeyPreference)&mode=tube&app_id=\(app_id)&app_key=\(app_key)")!
    let data: Data = try! Data.init(contentsOf: url)
    do {
        travelPlanner = try! decoder.decode(TravelPlanner.self, from: data)
        let travelPlans = travelPlanner.journeys
        for plan in 0..<travelPlans!.count-1{
            var planDuration = [Double]()
            var totallines = [String]()
            var totalstops = [[String]]()
            var innerOption = [[String : [String]]]()
            let journey = travelPlans![plan]
            let journeyLegs = journey.legs
            for leg in 0..<journeyLegs!.count{
                var directionsForLeg : RouteOption?
                var lineStopsInLeg = [String]()
                var legs = [String : [String]]()
                var stops = [String]()
                var singleLine = String()
                if journeyLegs![leg].mode.name == "tube" {
                    departurePoint = journeyLegs![leg].departurePoint.commonName
                    arrivalPoint = journeyLegs![leg].arrivalPoint!.commonName
                    planDuration.append(journeyLegs![leg].duration)
                    departureTime.append(journeyLegs![leg].departureTime)
                    arrivalTime.append(journeyLegs![leg].arrivalTime)
                    singleLine = journeyLegs![leg].routeOptions[0].name
                    directionsForLeg = journeyLegs![leg].routeOptions[0]
                    totallines.append(singleLine)
                    let stopsInLeg = journeyLegs![leg].path?.stopPoints
                    for stop in 0..<stopsInLeg!.count{
                        stops.append(stopsInLeg![stop].name)
                        lineStopsInLeg.append(stopsInLeg![stop].name)
                        legs[singleLine] = stops
                    }
                    totalstops.append(lineStopsInLeg)
                    innerOption.append(legs)
                    directionDetails.append(directionsForLeg!.directions!)
                }
            }
            options.append(innerOption)
            linesInOption.append(totallines)
            stopsInOptionPerLine.append(totalstops)
            duration.append(planDuration)
        }
    }
    return TravelOptions(options: options, duration: duration, linesInOption: linesInOption, stopsInOptionPerLine: stopsInOptionPerLine, departureTime: departureTime, arrivalTime: arrivalTime, directionDetails: directionDetails, departurePoint: departurePoint, arrivalPoint: arrivalPoint)
}
