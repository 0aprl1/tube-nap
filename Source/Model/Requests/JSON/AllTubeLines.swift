//
//  AllTubeLines.swift
//  NapTube
//
//  Created by 0aprl1 on 03/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

struct RouteSection: Codable {
    
    let dollarSignType : String?
    let name : String
    let direction : String
    let originationName : String
    let destinationName : String
    let originator : String
    let destination : String
    let serviceType : String
    let validTo : String
    let validFrom : String
    
    
    enum RouteSectionsCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case name = "name"
        case direction = "direction"
        case originationName = "originationName"
        case destinationName = "destinationName"
        case originator = "originator"
        case destination = "destination"
        case serviceType = "serviceType"
        case validTo = "validTo"
        case validFrom = "validFrom"
    }
}

struct Crowding2 : Codable {
    
    let dollarSignType : String?
    
    enum CrowdingCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
    }
}
struct ServiceTypes : Codable {
    
    let type : String?
    let name : String
    let uri : String
    
    enum ServiceTypesCodingKeys : String, CodingKey {
        
        case type = "$type"
        case name  = "name"
        case uri  = "uri"
    }
}

struct Line : Codable {
    
    let type : String?
    let id : String
    let name : String
    let modeName : String
    let disruptions : [String]?
    let created : String
    let modified : String
    let lineStatus : [String]?
    let routeSection : [RouteSection]?
    let serviceTypes : [ServiceTypes]?
    let crowding : Crowding2?
    
    
    enum LineKeys : String, CodingKey {
        
        case type = "$type"
        case id = "id"
        case name = "name"
        case modeName = "modeName"
        case disruptions = "disruptions"
        case created = "created"
        case modifed = "modified"
        case lineStatus = "lineStatus"
        case routeSection = "routeSection"
        case serviceTypes = "serviceTypes"
        case crowding = "crowding"
        
    }
}
