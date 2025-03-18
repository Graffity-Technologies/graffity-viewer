import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
//    var navigationController: UINavigationController!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Flutter Platform Channel Setup
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//        self.navigationController = UINavigationController(rootViewController: controller)
//        self.window.rootViewController = self.navigationController
//        self.navigationController.setNavigationBarHidden(true, animated: false)
//        self.window.makeKeyAndVisible()
        
        let ARChannel = FlutterMethodChannel(name: "app.graffity.ar-viewer/ar", binaryMessenger: controller.binaryMessenger)
        
        ARChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "OpenAR" {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let accessToken = args["accessToken"] as? String,
                   let arMode = args["arMode"] as? String {
                    let arVC = ARViewController()
                    arVC.accessToken = accessToken
                    arVC.arMode = arMode
                    
                    self?.window.rootViewController = arVC
                    
//                    self?.navigationController.setNavigationBarHidden(false, animated: true)
//                    self?.navigationController.pushViewController(arVC, animated: true)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
