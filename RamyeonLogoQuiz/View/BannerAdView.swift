//
//  BannerAdView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/18.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewControllerRepresentable {
    private let bannerAdManager = BannaerAdManager()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerAdManager.bannerView.rootViewController = bannerViewController
        bannerViewController.bannerAdManager = bannerAdManager
        bannerViewController.view.addSubview(bannerAdManager.bannerView)
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if let bannerViewController = uiViewController as? BannerViewController {
            bannerViewController.updateAdSize()
        }
    }
}
