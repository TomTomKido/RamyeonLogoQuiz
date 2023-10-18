//
//  AppDelegate.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/18.
//

import Foundation
import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var lastScreenName: String?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        LogManager.sendAppLaunchLog()
        
        return true
    }
}
