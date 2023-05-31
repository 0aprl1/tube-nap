//
//  TubeStops.swift
//  NapTube
//
//  Created by 0aprl1 on 03/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

struct Lines : Codable {
    
    let dollarSignType : String?
    let id : String
    let name : String
    let uri : String
    let type : String
    let crowding : Crowding
    let routeType : String
    let status : String
    
    enum LinesCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case id  = "id"
        case name = "name"
        case uri  = "uri"
        case type  = "type"
        case crowding  = "crowding"
        case routeType  = "routeType"
        case status  = "status"
    }
}

struct Crowding : Codable {
    
    let dollarSignType : String?
    
    enum CrowdingCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
    }
}

struct LineGroup : Codable {
    
    let type : String?
    let naptanIdReference : String?
    let stationAtcoCode : String
    let lineIdentifier : [String]
    
    enum LineGroupCodingKeys : String, CodingKey {
        
        case type = "$type"
        case naptanIdReference  = "naptanIdReference"
        case stationAtcoCode  = "stationAtcoCode"
        case lineIdentifier  = "lineIdentifier"
    }
}

struct LineModeGroups : Codable {
    
    let type : String?
    let modeName : String
    let lineIdentifier : [String]
    
    enum LineGroupCodingKeys : String, CodingKey {
        
        case type = "$type"
        case modeName  = "modeName"
        case lineIdentifier  = "lineIdentifier"
    }
}

struct AdditionalProp : Codable {
    
    let type : String?
    let category : String
    let key : String
    let sourceSystemKey : String
    let value : String
    
    enum AdditionalPropCodingKeys : String, CodingKey {
        
        case type = "$type"
        case category  = "category"
        case key  = "key"
        case sourceSystemKey  = "sourceSystemKey"
        case value = "value"
    }
}

struct Children : Codable {
    
    let type : String?
    let naptanID : String?
    let modes : [String]?
    let icsCode : String
    let stationNaptan : String
    let lines : [String]?
    let lineGroup : [String]?
    let lineModeGroups : [String]?
    let status : Bool
    let id : String
    let commonName : String
    let placeType : String
    let additionalProp : [String]?
    let children : [String]?
    let lat: Double
    let lon : Double
    
    enum ChildrenCodingKeys : String, CodingKey {
        
        case type = "$type"
        case naptanID = "naptanID"
        case modes = "modes"
        case icsCode = "icsCode"
        case stationNaptan = "stationNaptan"
        case lines = "lines"
        case lineGroup = "lineGroup"
        case lineModeGroups = "lineModeGroups"
        case status = "status"
        case id = "id"
        case commonName = "commonName"
        case placeType = "placeType"
        case additionalProp = "additionalProperties"
        case children = "children"
        case lat = "lat"
        case lon = "lon"
    }
}


struct lineStops : Codable {
    
    let type : String?
    let naptanID : String?
    let modes : [String]
    let icsCode : String
    let stopType : String
    let stationNaptan : String
    let lines : [Lines]
    let lineGroup : [LineGroup]
    let lineModeGroups : [LineModeGroups]
    let status : Bool
    let id : String
    let commonName : String
    let placeType : String
    let additionalProp : [AdditionalProp]?
    let children : [Children]?
    let lat: Double
    let lon : Double
    
    enum LineStopsCodingKeys : String, CodingKey {
        
        case type = "$type"
        case naptanID = "naptanID"
        case modes = "modes"
        case icsCode = "icsCode"
        case stopType = "stopType"
        case stationNaptan = "stationNaptan"
        case lines = "lines"
        case lineGroup = "lineGroup"
        case lineModeGroups = "lineModeGroups"
        case status = "status"
        case id = "id"
        case commonName = "commonName"
        case placeType = "placeType"
        case additionalProp = "additionalProp"
        case children = "children"
        case lat = "lat"
        case lon = "lon"
    }
}


