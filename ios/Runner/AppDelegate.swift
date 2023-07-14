import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var navigationController: UINavigationController!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            //AR
            // let controllerAR : FlutterViewController = window?.rootViewController as! FlutterViewController
            // self.navigationController = UINavigationController(rootViewController: controllerAR)
            // self.window.rootViewController = self.navigationController
            // self.navigationController.setNavigationBarHidden(true, animated: false)
            // self.window.makeKeyAndVisible()
            
            
            // let ARChannel = FlutterMethodChannel(name: "samples.flutter.dev/navigation", binaryMessenger: controllerAR.binaryMessenger)
            // ARChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            //     if call.method == "OpenAR" {
            //         if let args = call.arguments as? Dictionary<String, Any>,
            //            let data = args["data"] as? String {
            //             let arVC = ARViewController()
            //             arVC.data = data
            //             self?.navigationController.setNavigationBarHidden(false, animated: true)
            //             self?.navigationController.pushViewController(arVC, animated: true)
            //             //                self?.navigateToARViewController(data: data)
            //         }
            //     }
            // }
            
            GeneratedPluginRegistrant.register(with: self)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
}

