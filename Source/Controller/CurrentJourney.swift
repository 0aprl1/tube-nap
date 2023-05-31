//
//  CurrentJourney.swift
//  NapTube
//
//  Created by 0aprl1 on 04/09/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import AVFoundation
import CoreML

class CurrentJourney : UIViewController, MKMapViewDelegate {
    
    var trip : Trip?
    var audioHandler : AudioHandler?
    var dataController : DataController?
    var journeyProgress : Float = 0
    var nextStop : Int = 0
    var sequenceOfStill : Int = 0
    var sequenceOfMoving : Int = 0
    var canMove : Bool = false
    var lastSequenceOfMoving : Int = 0
    var durationsList : [Double]?
    var totalDurationInSec : Double?
    var timeLeft : Double?
    var linesInOption : [String]?
    var stopsInOptionPerLine : [[String]]?
    var stopsList : [String]?
    var stationsStringCoordinatesInPath : [[String]] = []
    var stationsCoordinatesInPath : [CLLocationCoordinate2D] = []
    var timer : Timer?
    var path : MKPolyline?
    var prediction : String = ""
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    let model = tubeClassifier()
    
    @IBOutlet weak var mapOfJourney: MKMapView!
    @IBOutlet weak var journeyTitle: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var stopsTableView: UITableView!
    @IBOutlet weak var stillCarriage: UILabel!
    @IBOutlet weak var movingCarriage: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        audioHandler = AudioHandler()
        stillCarriage.isHidden = true
        movingCarriage.isHidden = true
        stillCarriage.backgroundColor = .red
        movingCarriage.backgroundColor = .green
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask),name: UIApplication.didBecomeActiveNotification, object: nil)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = newBackButton
        let newPlusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = newPlusButton
        journeyTitle.text = "Travelling from \(trip!.departure.replacingOccurrences(of: "Underground Station", with: ""))to \(trip!.destination.replacingOccurrences(of: "Underground Station", with: ""))"
        stopsList = listAllStops(stops: stopsInOptionPerLine!)
        totalDurationInSec = getTotalDuration(duration: durationsList!)*60
        timeLeft = totalDurationInSec
        progressBar.setProgress(0, animated: false)
        progressField.text = "0%"
        setInitialMapCenter()
        placeAPin(stationName: trip!.departure)
        for stop in 0..<stopsList!.count{
            placeAPin(stationName: stopsList![stop] )
        }
        DispatchQueue.global().async { [weak self] in
            self!.path = self!.drawIntinerary()
            DispatchQueue.main.async {
                self!.mapOfJourney.addOverlay(self!.path!, level: .aboveRoads)
                self!.mapOfJourney.delegate = self
                self!.addMapTrackingButton()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        mapOfJourney.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setInitialMapCenter(){
        var mostNorth = Double(trip!.departureCoordinates[0])
        var mostSouth = Double(trip!.departureCoordinates[0])
        var mostEast = Double(trip!.departureCoordinates[1])
        var mostWest = Double(trip!.departureCoordinates[1])
        var lat : Double?
        var lon : Double?
        for station in stopsList!{
            lat = Double(trip!.stationsCoordinates[station]![0])
            lon = Double(trip!.stationsCoordinates[station]![1])
            if lat! > mostNorth!{
                mostNorth = lat
            }else if lat! < mostSouth!{
                mostSouth = lat
            }
            if lon! > mostEast!{
                mostEast = lon
            }else if lon! < mostWest!{
                mostWest = lon
            }
        }
        let centerLat = (mostNorth!+mostSouth!)/2
        let centerLon = (mostEast!+mostWest!)/2
        let centerMap = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        let latDiff = CLLocationDegrees(abs(mostNorth!-mostSouth!)+((abs(mostNorth!-mostSouth!)/2.5)))
        let lonDiff = CLLocationDegrees(abs(mostEast!-mostWest!)+((abs(mostEast!-mostWest!)/2.5)))
        let rect = MKCoordinateSpan(latitudeDelta: latDiff, longitudeDelta: lonDiff)
        self.mapOfJourney.setRegion(MKCoordinateRegion(center: centerMap, span: rect), animated: true)
    }
    
    func setMapCenter(coordinates: [String]){
        let lat = Double(coordinates[0])
        let lon = Double(coordinates[1])
        let centerMap = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let fraction : Double = 0.99985
        let latSpan = CLLocationDegrees(abs(lat!-lat!*fraction))
        let lonSpan = CLLocationDegrees(abs(lon!-lon!*fraction))
        let rect = MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lonSpan)
        self.mapOfJourney.setRegion(MKCoordinateRegion(center: centerMap, span: rect), animated: true)
    }
    
    func addMapTrackingButton(){
        let image = UIImage(named: "relocate") as UIImage?
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let mapRect = mapOfJourney.frame.size
        button.frame = CGRect(origin: CGPoint(x:(Double(mapRect.width)/375)*345, y:(Double(mapRect.height)/321)*275), size: CGSize(width: (Double(mapRect.width)/375)*25, height: (Double(mapRect.width)/375)*25))
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(centerMapOnUserButtonClicked), for:.touchUpInside)
        mapOfJourney.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        setInitialMapCenter()
    }
    
    func placeAPin(stationName : String){
        let coordinates = trip!.stationsCoordinates[stationName]
        let lat = Double(coordinates![0])
        let lon = Double(coordinates![1])
        let location = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        let pin = CustomPin(pinTitle: "\(stationName.replacingOccurrences(of: "Underground Station", with: ""))", pinSubTitle: "", location: location)
        self.mapOfJourney.addAnnotation(pin)
    }
    
    func drawIntinerary() -> MKPolyline{
        stationsStringCoordinatesInPath.append(trip!.stationsCoordinates[trip!.departure]!)
        for stop in stopsList!{
            stationsStringCoordinatesInPath.append(trip!.stationsCoordinates[stop]!)
        }
        for pairOfCoordinates in stationsStringCoordinatesInPath{
            let temporaryLat = Double(pairOfCoordinates[0])
            let temporaryLon = Double(pairOfCoordinates[1])
            stationsCoordinatesInPath.append(CLLocationCoordinate2D(latitude: temporaryLat!, longitude: temporaryLon!))
        }
        
        return MKPolyline(coordinates: stationsCoordinatesInPath, count: stopsList!.count+1)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    func listAllStops(stops: [[String]])->[String]{
        var stopsList = [String]()
        for i in 0..<stops.count{
            for j in 0..<stops[i].count{
                stopsList.append(stops[i][j])
            }
        }
        return stopsList
    }
    
    func getTotalDuration(duration: [Double]) -> Double {
        var totalDuration : Double = 0
        for i in 0..<duration.count{
            totalDuration = totalDuration + duration[i]
        }
        return totalDuration
    }
    
    func alertEndOfPath(){
        let alert = UIAlertController(title: "Wake Up!", message: "You Are Arrived", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { action in
            self.cancelButton.isEnabled = true
            self.startButton.isEnabled = true
            self.startButton.isHidden = true
            self.progressField.isHidden = true
            self.movingCarriage.isHidden = true
            self.stillCarriage.isHidden = true
            self.stopsTableView.bottomAnchor.constraint(equalTo: self.journeyTitle.topAnchor).isActive = true
        }))
        alert.addAction(UIAlertAction(title: "End Trip", style: UIAlertAction.Style.destructive, handler: { action in self.performSegueAfterCancel()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertConfirmationCancelTrip(){
        let alert = UIAlertController(title: "Stopping Journey", message: "Are You Sure?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive, handler: { action in self.performSegueAfterCancel()}))
        alert.addAction(UIAlertAction(title: "Undo", style: UIAlertAction.Style.cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertForAdditionToFavourites(){
        let alert = UIAlertController(title: "Added to Favourites", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertChangeLine(nextLine : String){
        let alert = UIAlertController(title: "Line Transfer Needed", message: "Change to \(nextLine)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: {action in
            self.startButton.isEnabled = true
            self.startButton.setTitle("Resume", for: UIControl.State.normal)
        }))
        alert.addAction(UIAlertAction(title: "Resume", style: UIAlertAction.Style.default, handler: {action in self.timerTrigger()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertContinueJourney(){
        let alert = UIAlertController(title: "Resume Journey", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {action in 
            self.timer?.fire()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func performSegueAfterCancel(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "PlanJourney") as! PlanJourney
        timer?.invalidate()
        trip?.departure = ""
        trip?.destination = ""
        trip?.fullDate = Date()
        controller.trip = trip
        controller.dataController = dataController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func soundNotificaton(){
        AudioServicesPlayAlertSound(SystemSoundID(1000))
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    @objc func cancel(sender: UIBarButtonItem) {
        if startButton.isEnabled == false{
            alertConfirmationCancelTrip()
        }else{
            performSegueAfterCancel()
        }
    }
    
    @objc func add(sender: UIBarButtonItem) {
        let favourite = Favourite(context: dataController!.viewContext)
        favourite.destination = trip!.destination
        favourite.departure = trip!.departure
        try? dataController!.viewContext.save()
        alertForAdditionToFavourites()
    }
    
    @objc func reinstateBackgroundTask() {
        if timer != nil && backgroundTask ==  .invalid {
            registerBackgroundTask()
        }
    }
    
    @objc func progressBarUpdate(timer: Timer){
        journeyProgress = progressBar.progress + (1/Float(totalDurationInSec!))
        timeLeft! -= 1
        progressBar.setProgress(journeyProgress, animated: true)
        progressField.text = String(Int(journeyProgress*100))+"%"
        if progressBar.progress > 0.90{
            soundNotificaton()
        }
        if journeyProgress >= 1{
            timer.invalidate()
            alertEndOfPath()
            journeyTitle.text = "Arrived at \(trip!.destination)"
        }
        if self.prediction == "moving"{
            self.stillCarriage.isHidden = true
            self.movingCarriage.isHidden = false
            sequenceOfMoving += 1
            lastSequenceOfMoving += 1
            if lastSequenceOfMoving > 5{
                sequenceOfStill = 0
            }
            if sequenceOfMoving > 15{
                canMove = true
            }
        }else if self.prediction == "still"{
            self.stillCarriage.isHidden = false
            self.movingCarriage.isHidden = true
            if sequenceOfStill < 7 && canMove == true{
                sequenceOfStill += 1
                lastSequenceOfMoving = 0
            }else if sequenceOfStill == 7 && canMove == true{
                sequenceOfMoving = 0
                sequenceOfStill = 0
                canMove = false
                if nextStop <= stopsList!.count-1{
                  stopsList?.remove(at: 0)
                  stopsTableView.reloadData()
                }
            }
        }
    }
    
    func timerTrigger(){
        startButton.isEnabled = false
        registerBackgroundTask()
        DispatchQueue.global().async { [weak self] in
            for _ in 0..<Int(self!.timeLeft!)/Int(1.1){
                self!.startClassification()
                if !self!.timer!.isValid{
                    break
                }
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(progressBarUpdate), userInfo: nil, repeats: true)
        if linesInOption!.count > 1{
            DispatchQueue.global().async {
                sleep(UInt32(self.durationsList![0]*60*0.90))
                for _ in 0..<Int(self.durationsList![0]*60*0.1){
                    sleep(UInt32(1))
                    self.soundNotificaton()
                }
                    DispatchQueue.main.async {
                        self.alertChangeLine(nextLine : self.linesInOption![1])
                        self.timer?.invalidate()
                        self.linesInOption?.remove(at: 0)
                    }
                }
                return
            }
        if backgroundTask != .invalid {
            endBackgroundTask()
        }
    }
    
    @IBAction func startTrip(_ sender: Any) {
        timerTrigger()
    }
}

extension CurrentJourney : UITableViewDelegate ,UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let station = cell?.textLabel?.text
        let coordinates = trip!.stationsCoordinates[station!]
        setMapCenter(coordinates: coordinates!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopsList!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextStops")
        let stop = stopsList![(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = stop
        return cell!
    }
}

extension CurrentJourney : AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    func startRecording() {
        //1
        audioHandler?.recordingSession = AVAudioSession.sharedInstance()
        try! audioHandler?.recordingSession!.setCategory(.record, mode: .default)
        try! audioHandler?.recordingSession!.setActive(true)

        // 2
        audioHandler!.audioURL = CurrentJourney.getWhistleURL()

        // 3
        let settings = [
            AVAudioFileTypeKey: Int(kAudioFileWAVEType),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        // 4
        audioHandler?.recorder = try! AVAudioRecorder(url: (audioHandler!.audioURL!), settings: settings)
        audioHandler?.recorder!.delegate = self
        audioHandler?.recorder!.record()
    }

    func finishRecording(){
        audioHandler?.recorder!.stop()
    }

    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.wav")
    }

    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func performClassifcation(path: URL){
        do {
            let fileUrl = path
            audioHandler?.wav_file = try AVAudioFile(forReading:fileUrl)
        } catch {
            fatalError("Could not open wav file.")
        }

        print("wav file length: \(audioHandler!.wav_file!.length)")
        assert(audioHandler!.wav_file!.fileFormat.sampleRate==16000.0, "Sample rate is not right!")

        let buffer = AVAudioPCMBuffer(pcmFormat: audioHandler!.wav_file!.processingFormat,
                                      frameCapacity: UInt32(audioHandler!.wav_file!.length))
        do {
            try audioHandler!.wav_file!.read(into:buffer!)
        } catch{
            fatalError("Error reading buffer.")
        }
        guard let bufferData = try buffer?.floatChannelData else {
            fatalError("Can not get a float handle to buffer")
        }

        // Chunk data and set to CoreML model
        let windowSize = 15600
        guard let audioData = try? MLMultiArray(shape:[windowSize as NSNumber],
                                                dataType:MLMultiArrayDataType.float32)
            else {
                fatalError("Can not create MLMultiArray")
        }

        // Ignore any partial window at the end.
        var results = [Dictionary<String, Double>]()
        let windowNumber = audioHandler!.wav_file!.length / Int64(windowSize)
        for windowIndex in 0..<Int(windowNumber) {
            let offset = windowIndex * windowSize
            for i in 0...windowSize {
                audioData[i] = NSNumber.init(value: bufferData[0][offset + i])
            }
            let modelInput = tubeClassifierInput(audio: audioData)

            guard let modelOutput = try? model.prediction(input: modelInput) else {
                fatalError("Error calling predict")
            }
            results.append(modelOutput.categoryProbability)
        }

        // Average model results from each chunk
        var prob_sums = Dictionary<String, Double>()
        for r in results {
            for (label, prob) in r {
                prob_sums[label] = (prob_sums[label] ?? 0) + prob
            }
        }

        var max_sum = 0.0
        var max_sum_label = ""
        for (label, sum) in prob_sums {
            if sum > max_sum {
                max_sum = sum
                max_sum_label = label
            }
        }

        let most_probable_label = max_sum_label
        let probability = max_sum / Double(results.count)
        print("\(most_probable_label) predicted, with probability: \(probability)")
        prediction = most_probable_label
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }

    func startClassification(){
        startRecording()
        sleep(UInt32(1.1))
        finishRecording()
        performClassifcation(path: audioHandler!.audioURL!)
    }
}



