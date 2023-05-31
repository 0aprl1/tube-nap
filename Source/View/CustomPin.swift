//
//  CustomPin.swift
//  NapTube
//
//  Created by 0aprl1 on 06/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomPin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subtitle : String?
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D){
        self.title = pinTitle
        self.coordinate = location
        
    }
    
    
}
