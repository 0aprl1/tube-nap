//
//  TravelOption.swift
//  NapTube
//
//  Created by 0aprl1 on 11/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation

struct TravelOptions {
    
    let options : [[[String : [String]]]]
    let duration : [[Double]]
    let linesInOption : [[String]]
    let stopsInOptionPerLine : [[[String]]]
    let departureTime : [String]
    let arrivalTime : [String]
    let directionDetails : [[String]]
    let departurePoint : String?
    let arrivalPoint : String?
}
