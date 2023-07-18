import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var navigationController: UINavigationController!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
        GeneratedPluginRegistrant.register(with: self)
            
        // AR Setup
        let controllerAR = window?.rootViewController as! FlutterViewController
        self.navigationController = UINavigationController(rootViewController: controllerAR)
        self.window.rootViewController = self.navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.window.makeKeyAndVisible()
            
        // Flutter Platform Channel Setup
        let ARChannel = FlutterMethodChannel(name: "app.graffity.ar-viewer/ar", binaryMessenger: controllerAR.binaryMessenger)

        ARChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "OpenAR" {
                if let args = call.arguments as? Dictionary<String, Any>,
                    let accessToken = args["accessToken"] as? String {
                    let arVC = ARViewController()
                    arVC.accessToken = accessToken
                    self?.navigationController?.setNavigationBarHidden(false, animated: true)
                    self?.navigationController?.pushViewController(arVC, animated: true)
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
