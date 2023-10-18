//
//  RamyeonLogoQuizApp.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

@main
struct RamyeonLogoQuizApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
