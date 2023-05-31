//
//  TravelPlanner.swift
//  NapTube
//
//  Created by 0aprl1 on 04/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit

struct Caveat: Codable {
    
    let dollarSignType : String?
    let text : String?
    let type : String
    
    enum CaveatCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case text = "text"
        case type = "type"
    }
}

struct TapDetail: Codable {
    
    let type : String?
    let modeType : String?
    let validationType : String
    let hostDeviceType : String
    let nationalLocationCode : Double
    let tapTimeStamp : String
    
    
    enum TapDetailCodingKeys : String, CodingKey {
        
        case type = "$type"
        case modeType = "text"
        case validatinType = "type"
        case hostDeviceType = "hostDeviceType"
        case nationalLocationCode = "nationalLocationCode"
        case tapTimeStamp = "tapTimeStamp"
    }
}

struct Tap: Codable {
    
    let type : String?
    let atcoCode : String?
    let tapDetails : TapDetail
    
    enum TaptCodingKeys : String, CodingKey {
        
        case type = "$type"
        case atcoCode = "atcoCode"
        case tapDetails = "tapDetail"
    }
}

struct Fares : Codable {
    
    let type : String?
    let lowZone : Double?
    let highZone : Double?
    let cost : Double?
    let chargeProfileName : String
    let isHopperfare : Bool
    let chargeLevel : String
    let peak : Double
    let offPeak : Double
    let taps : [Tap]
    
    enum FaresPointCodingKeys : String, CodingKey {
        
        case type = "$type"
        case lowZone = "lowZone"
        case highZone = "highZone"
        case cost = "cost"
        case chargeProfileName = "chargeProfileName"
        case isHopperFare = "isHopperFare"
        case chargeLevel = "chargeLevel"
        case peak = "peak"
        case offPeak = "offPeak"
        case taps = "taps"
    }
}

struct Fare : Codable {
    
    let type : String?
    let totalCost : Double?
    let fares : [Fares]
    
    enum FarePointCodingKeys : String, CodingKey {
        
        case type = "$type"
        case totalCost = "totalCost"
        case fares = "fares"
    }
}


struct Mode : Codable {
    
    let dollaSignType : String?
    let id : String
    let name : String
    let type : String
    let routeType : String
    let status : String
    
    enum ModeCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case id = "id"
        case name = "name"
        case type = "type"
        case routeType = "routeType"
        case status = "status"
    }
}

struct LineIdentifier : Codable {
    
    let dollarSignType : String?
    let id : String
    let name : String
    let type : String
    let crowding : Crowding
    let routeType : String
    let status : String
    
    
    
    enum LineIdentifierCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case id = "id"
        case name = "name"
        case type = "type"
        case crowding = "crowding"
        case routeType = "routeType"
        case status = "status"
    }
}

struct RouteOption : Codable {
    
    let type : String?
    let name : String
    let directions : [String]?
    let lineIdentifier : LineIdentifier?
    
    enum RouteOptionCodingKeys : String, CodingKey {
        
        case type = "$type"
        case name =  "name"
        case directions = "directions"
        case lineIdentifier = "lineIdentifier"
    }
}

struct StopPoint : Codable {
    
    let dollarSignType : String?
    let id : String?
    let name : String
    let uri : String
    let type : String
    let routeType : String
    let status : String
    
    enum StopPointCodingKeys : String, CodingKey{
        
        case dollarSignType = "$type"
        case id = "id"
        case name = "name"
        case uri = "url"
        case type = "type"
        case routeType = "routeType"
        case status = "status"
    }
}

struct Path : Codable {
    
    let type : String?
    let lineString : String
    let stopPoints : [StopPoint]?
    let elevation : [String]?
    
    enum PathCodingKeys : String, CodingKey {
        
        case type = "$type"
        case lineString = "lineString"
        case stopPoints = "stopPoints"
        case elevation = "elevation"
        
    }
}

struct ArrivalPoint : Codable {
    
    let type : String?
    let naptanID : String?
    let platformName : String?
    let icsCode : String?
    let commonName : String
    let placeType : String
    let additionalProperties : [String]?
    let lat : Double
    let lon : Double
    
    enum ArrivalPointCodingKeys : String, CodingKey {
        
        case type = "$type"
        case naptanID = "naptanID"
        case platformName = "platformName"
        case icsCode = "icsCode"
        case commonName = "commonName"
        case placeType = "placeType"
        case additionalProperties = "addiotionalProperties"
        case lat = "lat"
        case lon = "lon"
    }
}

struct DeparturePoint : Codable {
    
    let type : String?
    let platformName : String
    let icsCode : String
    let commonName : String
    let placeType : String
    let additionalProperties : [String]?
    let lat : Double
    let lon : Double
    
    enum ArrivalPointCodingKeys : String, CodingKey {
        
        case type = "$type"
        case platformName = "platformName"
        case icsCode = "icsCode"
        case commonName = "commonName"
        case placeType = "placeType"
        case additionalProperties = "addiotionalProperties"
        case lat = "lat"
        case lon = "lon"
    }
}

struct Obstacle : Codable {
    
    let dollarSignType : String?
    let type : String
    let incline : String
    let stopID : Double?
    let position : String
    
    
    enum ObstacleCodingKeys : String, CodingKey {
        
        case dollarSignType = "$type"
        case type = "type"
        case incline = "incline"
        case stopID = "stopID"
        case position = "position"
    }
}

struct PathAttribute : Codable {
    
    let type : String?
    
    enum PathAttributeCodingKeys : String, CodingKey {
        
        case type = "$type"
    }
}

struct Step : Codable {
    
    let type : String?
    let description : String
    let turnDirection : String
    let streetName : String
    let distance : Double?
    let cumulativeDistance : Double
    let skyDirection : Double
    let skyDirectionDescription : String
    let cumulativeTravelTime : Double
    let latitue : Double?
    let longitude : Double?
    let pathAttribute : PathAttribute
    let descriptionHeading : String
    let trackType : String
    
    enum StepCodingKeys : String, CodingKey {
        
        case type = "$type"
        case description = "description"
        case turnDirection = "turnDirection"
        case streetName = "streetName"
        case distance = "distance"
        case cumulativeDistance = "cumulativeDistance"
        case skyDirection = "skyDirection"
        case skyDirectionDescription = "skyDirectionDescription"
        case cumulativeTravelTime = "cumulativeTravelTime"
        case latitue = "latitude"
        case longitude = "longitude"
        case pathAttribute = "pathAttribute"
        case descriptionHeading = "descriptionHeading"
        case trackType = "trackType"
    }
}

struct Instruction : Codable {
    
    let type : String?
    let summary : String?
    let detailed : String?
    let steps : [Step]?
    
    enum InstructionCodingKeys : String, CodingKey {
        
        case type = "$type"
        case summary = "summary"
        case detailed = "detailed"
        case steps = "steps"
    }
}

struct Leg : Codable {
    
    let type : String?
    let duration : Double
    let instruction : Instruction?
    let obstacles : [Obstacle]?
    let departureTime : String
    let arrivalTime : String
    let departurePoint : DeparturePoint
    let arrivalPoint : ArrivalPoint?
    let path : Path?
    let routeOptions : [RouteOption]
    let mode : Mode
    let disruptions : [[String:String]]?
    let plannedWorks : [String]?
    let distance : Double?
    let isDisrupted : Bool
    let hasFixedLocations : Bool
    let fare : Fare?
    let caveats : Caveat?
    
    enum LegPropCodingKeys : String, CodingKey {
        
        case type = "$type"
        case duration = "duration"
        case instruction = "instruction"
        case obstacles = "obstacle"
        case departureTime = "departureTime"
        case arrivalTime = "arrivalTime"
        case departurePoint = "departurePoint"
        case arrivalPoint = "arrivalPoint"
        case path = "path"
        case routeOptions = "routeOptions"
        case mode = "mode"
        case disruptions = "disruptions"
        case plannedWorks = "plannedWorks"
        case distance = "distance"
        case isDisrupted = "isDisrupted"
        case hasFixedLocations = "hasFixedLocation"
        case fare = "fare"
        case caveats = "caveats"
    }
}

struct Journey : Codable {
    
    let type : String?
    let startDateTime : String
    let duration : Double
    let arrivalDateTime: String
    let legs : [Leg]?
    
    enum JourneyCodingKeys : String, CodingKey {
        
        case type = "$type"
        case startDateTime = "startDateTime"
        case duration = "duration"
        case arrivalDatetime = "arrivalDateTime"
        case legs = "legs"
    }
}


struct TravelPlanner : Codable {
    
    let type : String?
    let journeys : [Journey]?
    
    
    enum TravelPlannerCodingKeys : String, CodingKey {
        
        case type = "$type"
        case journeys = "journeys"
    }
}
