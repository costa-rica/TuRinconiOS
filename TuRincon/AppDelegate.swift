//
//  AppDelegate.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import UIKit
import Sentry

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Access the Font
        UIFont.overrideDefaultTypography()
        
        SentrySDK.start { options in
            options.dsn = "https://81d3fc0b331ce6b4c503b2c56175d0e7@o4505798987284480.ingest.sentry.io/4505798991347712"
            options.debug = true // Enabled debug when first installing is always helpful

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
            
            // Set up beforeSend event
            options.beforeSend = { event in
//                // Attach breadcrumbs to provide context
//                SentrySDK.addBreadcrumb("App launched")
//                SentrySDK.addBreadcrumb("User performed action XYZ")
//                
//                // Example: Attach additional data to the event
//                event.extra["customKey"] = "Custom Value"
                
                return event // Send the modified event
            }
            
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

