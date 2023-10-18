//
//  Theme.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/08.
//

import UIKit

class Theme {
    static func navigationBarColors(background : UIColor, titleColor : UIColor? = nil, tintColor : UIColor? = nil) {
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background
        navigationAppearance.shadowColor = .clear
        
        navigationAppearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold),
            .foregroundColor: titleColor ?? .black
        ]
        navigationAppearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold),
            .foregroundColor: titleColor ?? .black
        ]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
