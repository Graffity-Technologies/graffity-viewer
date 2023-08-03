//
//  ARViewController.swift
//  Runner
//
//  Created by Nontaphat Pongpis on 12/7/2566 BE.
//

import UIKit
import GraffityARCloudService

class ARViewController: UIViewController {
    var accessToken: String?
    var arMode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = accessToken {
            var isFrontCamera = false
            if (arMode == "Face Anchor") {
                isFrontCamera = true
            }
            let graffityARCloud = GraffityARCloud(accessToken: accessToken)
            let arCloudUIView = ARCloudUIView(service: graffityARCloud, frontCameraMode: isFrontCamera)
            self.addChild(arCloudUIView)
            self.view.addSubview(arCloudUIView.view)
        }
    }
}
