//
//  AppDelegate.swift
//  coffee-cat
//
//  Created by Tin on 27/01/2024.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var timer: Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        scheduleTask()
        IQKeyboardManager.shared.enable = true
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
    
    
    private func scheduleTask() {
        // Invalidate the previous timer if it exists
        timer?.invalidate()
        
        // Create a new timer
        timer = Timer.scheduledTimer(timeInterval: /*(2 * 60 * 60 + 30 * 60)*/ 100,
                                     target: self,
                                     selector: #selector(runTask),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func runTask() {
        print("Task performed at \(Date())")
    }
    
    private func privateapplicationWillTerminate(_ application: UIApplication) {
        timer?.invalidate()
    }
}

