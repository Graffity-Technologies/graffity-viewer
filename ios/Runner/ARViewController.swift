//
//  ARViewController.swift
//  Runner
//
//  Created by Nontaphat Pongpis on 12/7/2566 BE.
//

import UIKit
import GraffityARCloudService
import CoreLocation

class ARViewController: UIViewController {
    var accessToken: String?
    var arMode: String?
    var latitude: Double?
    var longitude: Double?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = accessToken {
            var isFrontCamera = false
            var pointCloudMode = false
            var initialLocation: CLLocation?
            if (arMode == "Face Anchor") {
                isFrontCamera = true
            } else if (arMode == "Point Cloud & Image Anchor") {
                pointCloudMode = true
            }
            if (latitude != nil && longitude != nil) {
                initialLocation = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
            }
            let graffityARCloud = GraffityARCloud(
                accessToken: accessToken,
                frontCameraMode: isFrontCamera,
                pointCloudMode: pointCloudMode,
                initialLocation: initialLocation
            )
            let arCloudUIView = ARCloudUIView(service: graffityARCloud)
            self.addChild(arCloudUIView)
            self.view.addSubview(arCloudUIView.view)
        }
    }
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
