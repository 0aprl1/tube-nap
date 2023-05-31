//
//  ViewNetowrkMap.swift
//  NapTube
//
//  Created by 0aprl1 on 04/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewNetworkMap : UIViewController, UIScrollViewDelegate{
    
    var trip : Trip?
    var dataController : DataController?
    var allLinesMaps : [String] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        allLinesMaps += trip!.allLines
        allLinesMaps.insert("Metro Network", at: 0)
        imageView.image = UIImage(named: allLinesMaps[0])
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func back(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        back()
    }
}

extension ViewNetworkMap: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allLinesMaps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.scrollView.zoomScale = 1.0
        return allLinesMaps[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imageView.image = UIImage(named: allLinesMaps[row])
    }
}
