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
    let graffityARCloud = GraffityARCloud(accessToken: "YOUR_ACCESS_TOKEN")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the "accessToken" property to display the passed data
        if let accessToken = accessToken {
            
                let graffityARCloud = GraffityARCloud(accessToken: accessToken)
                let arCloudUIView = ARCloudUIView(service: self.graffityARCloud)
                self.addChild(arCloudUIView)
                self.view.addSubview(arCloudUIView.view)
            } 
            
            //            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            //            label.text = data
            //            label.textAlignment = .center
            //            label.center = view.center
            //            label.backgroundColor = .orange
            //            view.backgroundColor = .blue
            //            view.addSubview(label)
        }
    }
