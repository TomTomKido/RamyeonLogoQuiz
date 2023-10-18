//
//  MainView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct MainView: View {
    let screenName: "main"
    
    var body: some View {
        VStack {
            LogoListView()
        }
        .onAppear {
            LogManager.sendScreenLog(screenName: screenName)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
