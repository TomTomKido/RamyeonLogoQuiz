//
//  LogoListView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct LogoListView: View {
    let logoList: [Logo] = Logo.bongjiPaldo
    let columns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 150)), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns) {
                        ForEach(logoList, id: \.self) { logo in
                            gridImage(logo: logo)
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            .background(Color.blue)
        }
        .navigationTitle("라면 퀴즈")
    }
    
    func gridImage(logo: Logo) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 110, height: 110)
                .foregroundColor(.cyan)
            Image(logo.logoName)
                .resizable()
                .frame(width:100, height: 100)
            if logo.solved {
                solvedCover
                checkMark
                    .padding(EdgeInsets(top: 80, leading: 80, bottom: 10, trailing: 10))
            }
        }
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
