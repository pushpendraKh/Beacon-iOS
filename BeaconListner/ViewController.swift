//
//  ViewController.swift
//  BeaconListner
//
//  Created by Pushpendra Khandelwal on 11/07/18.
//  Copyright © 2018 Pushpendra Khandelwal. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyType: UILabel!
    
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!
    
    private let uuid = UUID.init(uuidString: "9CD99728-41E9-4723-8A7B-75F379FA5555")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        setupBeaconSettings()
        
    }

    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupBeaconSettings() {
        beaconRegion = CLBeaconRegion.init(proximityUUID: uuid!, identifier: "estimode-pushpendra")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: self.beaconRegion)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered")
        locationManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited")
        locationManager.stopMonitoring(for: self.beaconRegion)
        self.beaconLabel.text = "No"
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        self.beaconLabel.text = "Beacon Found"
        let beacon = beacons.first
        print(beacons)
        
    }
    
    
}

