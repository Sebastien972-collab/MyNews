//
//  MyNewsApp.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppCenter.configure()
        AppCenter.start(withAppSecret: "6eac17ed-8c2a-47aa-8674-de8c69135608", services: [Analytics.self, Crashes.self])
        return true
    }
}
@main
struct MyNewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
