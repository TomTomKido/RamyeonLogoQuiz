//
//  LogoListView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/04.
//

import SwiftUI

struct LogoListView: View {
    let logoList: [Logo] = Logo.bongjiPaldo
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
            VStack {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 100, maximum: 150))]) {
                    ForEach(logoList, id: \.self) { logo in
                        ZStack {
                            Image(logo.logoName)
                                .resizable()
                                .frame(width:100, height: 100)
                            solvedCover
                            checkMark
                                .padding(EdgeInsets(top: 80, leading: 80, bottom: 10, trailing: 10))
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
    
    var solvedCover: some View {
        Image("solvedCover")
            .resizable()
            .frame(width: 110, height: 110)
            .opacity(0.5)
            .border(.white, width: 5)
            .cornerRadius(6)
            
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
