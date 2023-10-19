//
//  ContentView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack(spacing: 0) {
            MainView()
            BannerView()
                .ignoresSafeArea()
                .padding(0)
                .frame(height: UIScreen.main.bounds.width * 50 / 320)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
