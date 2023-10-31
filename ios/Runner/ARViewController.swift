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
            var pointCloudMode = false
            if (arMode == "Face Anchor") {
                isFrontCamera = true
            } else if (arMode == "Point Cloud & Image Anchor") {
                pointCloudMode = true
            }
            let graffityARCloud = GraffityARCloud(accessToken: accessToken)
            let arCloudUIView = ARCloudUIView(
                service: graffityARCloud,
                frontCameraMode: isFrontCamera,
                pointCloudMode: pointCloudMode
            )
            self.addChild(arCloudUIView)
            self.view.addSubview(arCloudUIView.view)
        }
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.frame = CGRect(x: 16, y: 60, width: 40, height: 40) // Adjust the values as needed
        self.view.addSubview(closeButton)
    }
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
