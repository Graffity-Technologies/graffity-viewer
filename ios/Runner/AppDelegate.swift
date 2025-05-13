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
                    if let latitude = args["latitude"] as? Double,
                       let longitude = args["longitude"] as? Double {
                        arVC.latitude = latitude
                        arVC.longitude = longitude
                    }
                    self?.window.rootViewController = arVC
                }
            } else if call.method == "GetAppClipParameters" {
                // Retrieve parameters from UserDefaults
                if let userDefaultsDict = UserDefaults.standard.dictionary(forKey: "AppClipParameters") {
                    // Convert to a format that Flutter can handle (String keys and values)
                    var flutterCompatibleDict: [String: String] = [:]
                    for (key, value) in userDefaultsDict {
                        if let stringKey = key as? String {
                            if let stringValue = value as? String {
                                flutterCompatibleDict[stringKey] = stringValue
                            }
                        }
                    }
                    result(flutterCompatibleDict)
                } else {
                    result(nil)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle URL scheme (if your app uses custom URL scheme)
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("📱 App opened via URL scheme: \(url.absoluteString)")
        
        // Log URL components
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            print("📱 URL Path: \(components.path)")
            
            // Log query parameters
            if let queryItems = components.queryItems {
                print("📱 URL Query Parameters:")
                for item in queryItems {
                    print("  📱 \(item.name) = \(item.value ?? "nil")")
                }
                
                // Create a dictionary for easier access if needed
                let paramsDict = queryItems.reduce(into: [String: String]()) { (result, item) in
                    result[item.name] = item.value
                }
                
                // Log the dictionary
                print("📱 Parameters Dictionary: \(paramsDict)")
                
                // Optional: Save parameters to UserDefaults for later access
                UserDefaults.standard.set(paramsDict, forKey: "URLSchemeParameters")
            }
        }
        
        return super.application(app, open: url, options: options)
    }
    
    // Handle App Clip invocation and NSUserActivity
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("📱 AppClip or Universal Link received: \(userActivity.activityType)")
        
        // Check if it's a web URL activity which is used by App Clips and Universal Links
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            // Log the full URL
            print("📱 AppClip URL: \(url.absoluteString)")
            
            // Log URL components
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                print("📱 URL Path: \(components.path)")
                
                // Log query parameters
                if let queryItems = components.queryItems {
                    print("📱 URL Query Parameters:")
                    for item in queryItems {
                        print("  📱 \(item.name) = \(item.value ?? "nil")")
                    }
                    
                    // Create a dictionary for easier access if needed
                    let paramsDict = queryItems.reduce(into: [String: String]()) { (result, item) in
                        result[item.name] = item.value
                    }
                    
                    // Log the dictionary
                    print("📱 Parameters Dictionary: \(paramsDict)")
                    
                    // Save parameters to UserDefaults for later access by Flutter
                    UserDefaults.standard.set(paramsDict, forKey: "AppClipParameters")
                }
            }
        }
        
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
