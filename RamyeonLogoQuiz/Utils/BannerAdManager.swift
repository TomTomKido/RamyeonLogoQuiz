//
//  BannerAdManager.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/18.
//

import UIKit
import GoogleMobileAds
import SwiftUI

class BannaerAdManager: NSObject {
    var bannerView: GADBannerView!
    weak var delegate: UIViewController?
    
    override init() {
        super.init()
        setAds()
    }
    
    private func setAds() {
        let width: Double = UIScreen.main.bounds.width
        let height = Double(width * 50 / 320)
        let adSize = GADAdSizeFromCGSize(CGSize(width: width, height: height)) //사이즈 직접지정
        bannerView = GADBannerView(adSize: adSize)
        
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test id
        #else
        bannerView.adUnitID = "ca-app-pub-8667576295496816/2136946897" //실제 하단배너 id
        #endif
        
        
        let request = GADRequest()
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            request.scene = scene
        }

        bannerView.load(request)
        bannerView.delegate = self
    }
}

extension BannaerAdManager: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}

extension BannaerAdManager {
    func updateAdSize(to width: CGFloat) {
        let height = Double(width * 50 / 320)
        let adSize = GADAdSizeFromCGSize(CGSize(width: width, height: height))
        bannerView.adSize = adSize
    }
}

class BannerViewController: UIViewController {
    var bannerAdManager: BannaerAdManager?
    var delegate: BannerView?
    
    func updateAdSize() {
        let newWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        bannerAdManager?.updateAdSize(to: newWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            // do nothing
        }) { _ in
            self.updateAdSize()
        }
    }
}
