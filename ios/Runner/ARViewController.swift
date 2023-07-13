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
            
            // Check if the first three characters of the token are "sk."
            if data.hasPrefix("sk.") {
                let graffityARCloud = GraffityARCloud(accessToken: data)
                let arCloudUIView = ARCloudUIView(service: self.graffityARCloud)
                self.addChild(arCloudUIView)
                self.view.addSubview(arCloudUIView.view)
            } else {
                // Token is not valid, handle the error or take appropriate actions
                print("Invalid token")
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
