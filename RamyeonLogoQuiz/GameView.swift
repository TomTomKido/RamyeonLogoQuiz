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
    let blockSize: CGFloat = 50

    var body: some View {
        VStack {
            quizImage
                .padding(.vertical, 20)
            answerBlock
            lettersBlock
            Spacer()
        }
        .background(Color.darkBlue)
    }
    
    var quizImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: parentSize.width * ratio, height: parentSize.width * ratio)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentBlue, lineWidth: 10)
                }
            Image(logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: parentSize.width * ratio, height: parentSize.width * ratio)
                .clipped()
        }
    }
    
    var answerBlock: some View {
        LazyHGrid(rows: [.init(.fixed(blockSize))]) {
            ForEach(0..<logo.letterCount, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: blockSize, height: blockSize)
                    .foregroundColor(.lightGray)
            }
        }
    }
    
    var lettersBlock: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(blockSize)), count: 5)) {
            ForEach(0..<10) { _ in
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: blockSize, height: blockSize)
                    .foregroundColor(.white)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(logo: Logo(name: "꼬꼬면"), parentSize: CGSize(width: 393, height: 393))
    }
}
