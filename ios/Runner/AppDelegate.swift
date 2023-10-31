import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Flutter Platform Channel Setup
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let ARChannel = FlutterMethodChannel(name: "app.graffity.ar-viewer/ar", binaryMessenger: controller.binaryMessenger)
        
        ARChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "OpenAR" {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let accessToken = args["accessToken"] as? String,
                   let arMode = args["arMode"] as? String {
                    let arVC = ARViewController()
                    arVC.accessToken = accessToken
                    arVC.arMode = arMode
                    
                    let navigationController = UINavigationController(rootViewController: arVC)
                    navigationController.isNavigationBarHidden = true
                    // Present the navigation controller modally
                    navigationController.modalPresentationStyle = .fullScreen
                    self!.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
                    self!.window!.makeKeyAndVisible()
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
