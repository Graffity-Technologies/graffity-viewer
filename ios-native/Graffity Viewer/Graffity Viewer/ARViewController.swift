//
//  ARViewController.swift
//  Runner
//
//  Created by Bank Wang on 12/7/2566 BE.
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
            setupBackButton()
        }
    }
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupBackButton() {
        // Create back button with chevron left icon
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure back button appearance
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: largeConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .white
        
        // Add shadow to make button visible on any background
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 0.5
        backButton.layer.shadowRadius = 4
        
        // Add action to button
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Add to view
        view.addSubview(backButton)
        
        // Set constraints
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
