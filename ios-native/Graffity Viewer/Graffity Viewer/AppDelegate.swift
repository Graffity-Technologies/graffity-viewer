//
//  AppDelegate.swift
//  Graffity Viewer
//
//  Created by Thaworn Kangwansinghanat on 17/5/2568 BE.
//

import UIKit
import CoreLocation
import GraffityARCloudService

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Default AR mode to use when launching directly
    private let defaultARMode = "World & Image Anchor"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        // Check for incoming URLs
        if let urlContext = options.urlContexts.first {
            handleIncomingURL(urlContext.url)
        }
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - URL Handling
    
    // Handle URL scheme (if your app uses custom URL scheme)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("📱 App opened via URL scheme: \(url.absoluteString)")
        handleIncomingURL(url)
        return true
    }
    
    // Handle App Clip invocation and NSUserActivity
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("📱 AppClip or Universal Link received: \(userActivity.activityType)")
        
        // Check if it's a web URL activity which is used by App Clips and Universal Links
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            // Log the full URL
            print("📱 AppClip URL: \(url.absoluteString)")
            handleIncomingURL(url)
        }
        
        return true
    }
    
    // Private helper method to parse URLs
    private func handleIncomingURL(_ url: URL) {
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
                
                // Save parameters to UserDefaults for later access by the app (in case direct launch fails)
                UserDefaults.standard.set(paramsDict, forKey: "AppClipParameters")
            }
            
            // Get token and location from URL
            var token: String? = nil
            var latitude: Double? = nil
            var longitude: Double? = nil
            var arMode: String? = nil
            
            // Process URL path components for AR routes
            if components.path.contains("/ar/") {
                token = components.path.components(separatedBy: "/ar/").last
            }
            // Process clip route
            else if components.path.contains("/clip/") {
                token = components.path.components(separatedBy: "/clip/").last
            }
            // Process id route with query parameters
            else if components.path.contains("/id") {
                token = components.queryItems?.first(where: { $0.name == "token" })?.value
            }
            
            // Extract queryItems if available
            if let lat = components.queryItems?.first(where: { $0.name == "lat" })?.value,
               let latValue = Double(lat) {
                latitude = latValue
            }
            
            if let long = components.queryItems?.first(where: { $0.name == "long" })?.value,
               let longValue = Double(long) {
                longitude = longValue
            }

            if let arModeParam = components.queryItems?.first(where: { $0.name == "arMode" })?.value {
                if arModeParam == "faceAnchor" {
                    arMode = "Face Anchor"
                } else if arModeParam == "pointCloud" {
                    arMode = "Point Cloud & Image Anchor"
                }
            }
            
            // Store in UserDefaults in case direct launch fails
            if let tokenValue = token {
                var params: [String: String] = ["token": tokenValue]
                
                if let latValue = latitude {
                    params["lat"] = String(latValue)
                }
                
                if let longValue = longitude {
                    params["long"] = String(longValue)
                }
                
                UserDefaults.standard.set(params, forKey: "AppClipParameters")
                
                // Launch AR view controller directly if token is available
                if (arMode != nil) {
                    DispatchQueue.main.async {
                        self.launchARDirectly(token: tokenValue, latitude: latitude, longitude: longitude, arMode: arMode)
                    }
                }
            }
        }
    }
    
    // Launch AR view controller directly
    private func launchARDirectly(token: String, latitude: Double?, longitude: Double?, arMode: String?) {
        // Get the key window and root view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        // Create AR view controller
        let arVC = ARViewController()
        arVC.accessToken = "Bearer \(token)"  // Add "Bearer " prefix to the token
        arVC.arMode = arMode ?? defaultARMode
        
        // Set location if available
        if let lat = latitude, let long = longitude {
            arVC.latitude = lat
            arVC.longitude = long
        }
        
        // Present AR view controller modally
        arVC.modalPresentationStyle = .fullScreen
        
        // If current root is already showing something modal, dismiss it first
        if let rootVC = window.rootViewController {
            if let presentedVC = rootVC.presentedViewController {
                presentedVC.dismiss(animated: false) {
                    rootVC.present(arVC, animated: true)
                }
            } else {
                rootVC.present(arVC, animated: true)
            }
        }
    }
}

