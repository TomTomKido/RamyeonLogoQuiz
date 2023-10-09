//
//  LogoListView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct LogoListView: View {
    @StateObject var logoListManager = LogoListManager()
    @State var trigger: Bool = false
    let gridSize: CGFloat = Utils.isIPad ? 200 : 100
    let spacing: CGFloat = Utils.isIPad ? 40 : 20
    let checkmarkCircleSize: CGFloat = Utils.isIPad ? 34 : 17
    let cornerRadius: CGFloat = Utils.isIPad ? 12 : 6
    
    init() {
        Theme.navigationBarColors(background: UIColor(Color.basicBlue), titleColor: .white)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { parent in
                ScrollView {
                    VStack(alignment: .leading) {
                        let columns = [GridItem(.adaptive(minimum: gridSize, maximum: gridSize * 1.5), spacing: spacing)]
                        LazyVGrid(columns: columns, spacing: spacing) {
                            ForEach(logoListManager.logoList, id: \.self) { logo in
                                let gameManager = GameManager(logo: logo, delegate: logoListManager)
                                let gameView = GameView(gameManager: gameManager, parentSize: parent.size, trigger: $trigger)
                                    .environmentObject(logoListManager)
                                NavigationLink {
                                    gameView
                                } label: {
                                    gridImage(logo: logo)
                                }
                            }
                        }
                        .padding(spacing)
                    }
                }
            }
            .background(Color.darkBlue)
        }
        .navigationTitle("라면 퀴즈")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: trigger, perform: { newValue in
            logoListManager.updateLogoList()
            trigger = false
        })
    }
    
    func gridImage(logo: Logo) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: gridSize + 20, height: gridSize + 20)
                .foregroundColor(.white)
            Image(logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: gridSize, height: gridSize)
                .clipped()
            if logo.solved {
                solvedCover
                checkMark
                    .padding(EdgeInsets(top: gridSize - 20, leading: gridSize - 20, bottom: 10, trailing: 10))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius + 4)
                .stroke(Color.accentBlue, lineWidth: Utils.isIPad ? 8 : 5)
        }
    }
    
    var solvedCover: some View {
        Image("solvedCover")
            .resizable()
            .frame(width: gridSize + 20, height: gridSize + 20)
            .opacity(0.5)
    }
    
    var checkMark: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: checkmarkCircleSize, height: checkmarkCircleSize)
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: checkmarkCircleSize - 2, height: checkmarkCircleSize - 2)
                .foregroundColor(.green)
        }
    }
}

struct LogoListView_Previews: PreviewProvider {
    static var previews: some View {
        LogoListView()
    }
}
