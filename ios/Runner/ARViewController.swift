//
//  ARViewController.swift
//  Runner
//
//  Created by Nontaphat Pongpis on 12/7/2566 BE.
//

import UIKit
import GraffityARCloudService

class ARViewController: UIViewController {
    var data: String?
    let graffityARCloud = GraffityARCloud(accessToken: "YOUR_ACCESS_TOKEN")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the "data" property to display the passed data
        if let data = data {
            let graffityARCloud = GraffityARCloud(accessToken: data)
            let arCloudUIView = ARCloudUIView(service: self.graffityARCloud)
            self.addChild(arCloudUIView)
            self.view.addSubview(arCloudUIView.view)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
