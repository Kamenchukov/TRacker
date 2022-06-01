//
//  AppDelegate.swift
//  TRacker
//
//  Created by Константин Каменчуков on 05.05.2022.
//

import UIKit
import GoogleMaps


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var visualEffectView = UIVisualEffectView()
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyA_EP0iaICfuT1_PSnKiTmpGbr4oipcB4k")
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [ weak self ] granted, _ in
        
            self?.sendNotification()
        }
        
        return true
    }
    func sendNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Tracker"
        content.subtitle = "Attension"
        content.body = "Please, open App"
        content.badge = 10
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "remider",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Notification shedule \(error)")
            }
        }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
        
    }
}

