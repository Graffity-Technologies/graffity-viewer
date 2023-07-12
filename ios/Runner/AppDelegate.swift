import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var navigationController: UINavigationController!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            //Battery
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                                      binaryMessenger: controller.binaryMessenger)
            batteryChannel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                guard call.method == "getBatteryLevel" else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                self?.receiveBatteryLevel(result: result)
            })
            //AR
            let controllerAR : FlutterViewController = window?.rootViewController as! FlutterViewController
            self.navigationController = UINavigationController(rootViewController: controller)
            self.window.rootViewController = self.navigationController
            self.navigationController.setNavigationBarHidden(true, animated: false)
            self.window.makeKeyAndVisible()
            
            
            let ARChannel = FlutterMethodChannel(name: "samples.flutter.dev/navigation", binaryMessenger: controllerAR.binaryMessenger)
            ARChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if call.method == "OpenAR" {
                    if let args = call.arguments as? Dictionary<String, Any>,
                       let data = args["data"] as? String {
                        let arVC = ARViewController()
                        arVC.data = data
                        self?.navigationController.setNavigationBarHidden(false, animated: true)
                        self?.navigationController.pushViewController(arVC, animated: true)
                        //                self?.navigateToARViewController(data: data)
                    }
                }
            }
            
            GeneratedPluginRegistrant.register(with: self)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
    //Battery
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Battery level not available.",
                                details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    //AR
    //    private func navigateToARViewController(data: String) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as! ARViewController
    //        viewController.data = data
    //
    //        // Replace "YourNavigationController" with the actual navigation controller used in your app
    //        let navigationController = window?.rootViewController as! NavARViewController
    //        navigationController.pushViewController(viewController, animated: true)
    //      }
}

