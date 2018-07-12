//
//  ViewController.swift
//  BeaconListner
//
//  Created by Pushpendra Khandelwal on 11/07/18.
//  Copyright © 2018 Pushpendra Khandelwal. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyType: UILabel!
    
    var locationManager: CLLocationManager!
    var beaconRegion: CLBeaconRegion!
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?

    
    private let uuid = UUID.init(uuidString: "9CD99728-41E9-4723-8A7B-75F379FA5555")
    private var pastDistance: CLProximity = .unknown
    private var currentDistance: CLProximity = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        setUpLocationManager()
        setupBeaconSettings()
    }
    
    private func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
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
        if let beacon = beacons.first {
            self.beaconLabel.text = "Beacon Found"
            if #available(iOS 10.0, *) {
                if pastDistance != beacon.proximity {
                    let request = UNNotificationRequest.init(identifier: "Found",
                                                             content: getContentBody(for: beacon),
                                                             trigger: nil)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    pastDistance = beacon.proximity
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    private func getContentBody(for beacon: CLBeacon) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Beacon Found"
        switch beacon.proximity {
        case .immediate:
            self.companyName.text = "immediate"
            content.body = "Hey, There is one beacon immediate you"
            print("Hey, There is one beacon immediate you")
        case .near:
            self.companyName.text = "near"
            content.body = "Hey, There is one beacon near you"
            print("Hey, There is one beacon near you")
        case .far:
            self.companyName.text = "far"
            content.body = "Hey, There is one beacon far from you"
            print("Hey, There is one beacon far you")
        case .unknown:
            self.companyName.text = "unknown"
            content.body = "Beacon is shut"
        }
        content.sound = .default()
        return content
    }
    
}

