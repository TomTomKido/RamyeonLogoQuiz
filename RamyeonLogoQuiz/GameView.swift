//
//  GameView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/20.
//

import SwiftUI

struct GameView: View {
    var logo: Logo
    let parentSize: CGSize
    let ratio: CGFloat = 2 / 3

    var body: some View {
        VStack {
            Rectangle()
                .frame(width: .infinity, height: 100)
                .foregroundColor(.blue)
            quizImage
            Spacer()
        }
        .background(Color.blue)
    }
    
    var quizImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.white)
                .frame(width: parentSize.width * ratio, height: parentSize.width * ratio)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.cyan, lineWidth: 10)
                }
            Image(logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: parentSize.width * ratio, height: parentSize.width * ratio)
                .clipped()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(logo: Logo(name: "꼬꼬면"), parentSize: CGSize(width: 393, height: 393))
    }
}
