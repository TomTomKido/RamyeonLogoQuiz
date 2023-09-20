//
//  GameView.swift
//  RamyeonLogoQuiz
//
//  Created by terry.yes on 2023/09/19.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarView()
            Rectangle()
                .foregroundColor(.clear)
        .background(Color(red: 21/255, green: 48/255, blue: 95/255))
            Rectangle()
                .foregroundColor(Color(red: 83/255, green: 166/255, blue: 244/255))
                .frame(maxWidth: .infinity, maxHeight: 5)
            Rectangle()
                .foregroundColor(Color(red: 54/255, green: 98/255, blue: 205/255))
                .frame(maxWidth: .infinity, maxHeight: 70)
                .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color(red: 54/255, green: 98/255, blue: 205/255))
    }
}


struct NavigationBarView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(Color(red: 83/255, green: 166/255, blue: 244/255))
                .frame(maxWidth: .infinity, maxHeight: 5)
            Rectangle()
                .foregroundColor(Color(red: 39/255, green: 73/255, blue: 160/255))
                .frame(maxWidth: .infinity, maxHeight: 2)
            ZStack(alignment: .leading) {
//                Image(systemName: "backButton")
                Rectangle()
                    .foregroundColor(Color(red: 54/255, green: 98/255, blue: 203/255))
                    .frame(maxWidth: .infinity, maxHeight: 40)
                Image("backButton")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.leading, 10)
            }
            Rectangle()
                .foregroundColor(Color(red: 83/255, green: 166/255, blue: 244/255))
                .frame(maxWidth: .infinity, maxHeight: 5)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
