//
//  LogoListView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct LogoListView: View {
    @StateObject var logoListManager = LogoListManager()
    let columns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 150)), count: 3)
    
    var body: some View {
        NavigationView {
            GeometryReader { parent in
                ScrollView {
                    VStack(alignment: .leading) {
                        LazyVGrid(columns: columns) {
                            ForEach(logoListManager.logoList, id: \.self) { logo in
                                NavigationLink {
                                    GameView(logoManager: LogoManager(logo: logo, delegate: logoListManager), parentSize: parent.size)
                                } label: {
                                    gridImage(logo: logo)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.darkBlue)
        }
        .navigationTitle("라면 퀴즈")
    }
    
    func gridImage(logo: Logo) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 110, height: 110)
                .foregroundColor(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentBlue, lineWidth: 5)
                }
            Image(logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipped()
            if logo.solved {
                solvedCover
                checkMark
                    .padding(EdgeInsets(top: 80, leading: 80, bottom: 10, trailing: 10))
            }
        }
        .padding(3)
    }
    
    var solvedCover: some View {
        Image("solvedCover")
            .resizable()
            .frame(width: 100, height: 100)
            .opacity(0.5)
    }
    
    var checkMark: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 17, height: 17)
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.green)
        }
    }
}

struct LogoListView_Previews: PreviewProvider {
    static var previews: some View {
        LogoListView()
    }
}
