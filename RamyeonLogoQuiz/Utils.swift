//
//  Utils.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/08.
//

import UIKit
import SwiftUI

struct Utils {
    static let isIPad = UIDevice.current.userInterfaceIdiom == .pad
}

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    @Binding var orientation: UIDeviceOrientation
        
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func detectOrientation(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        modifier(DeviceRotationViewModifier(orientation: orientation))
    }
}
