//
//  Journey.swift
//  NapTube
//
//  Created by 0aprl1 on 15/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

class Trip{

    var departure : String = ""
    var destination : String = ""
    var timeIs : String = "Departing"
    var journeyPreference : String = "LeastTime"
    var departureCoordinates = [String]()
    var destinationCoordinates = [String]()
    var date = String()
    var departureHour = String()
    var allLines : [String] = []
    var allStops : [String] = []
    var stationsCoordinates : [String : [String]] = [:]
    var fullDate = Date()
    
    init() {
        allLines.append(contentsOf: requestAllLinesName())
        for line in allLines{
            allStops.append(contentsOf: requestNameAllStationForALine(lineName: line.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "-")))
            stationsCoordinates.merge(requestCoordinatesForAllStationForALine(lineName: line.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "-"))){(_,new) in new}
        }
        allStops = Array(Set(allStops)).sorted()
    }
}
