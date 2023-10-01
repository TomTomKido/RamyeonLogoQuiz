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
    @State var isAnimatingErrorView = false
    @State var revealedAnswers: [String] = []
    @State var targetLetterIndex: Int = 0

    var body: some View {
        VStack {
            quizImage
                .padding(.vertical, 20)
            answerBlock
            answerChoicesBlock
            Spacer()
        }
        .background(Color.darkBlue)
        .overlay {
            Rectangle()
                .foregroundColor(.red)
                .opacity(isAnimatingErrorView ? 0.3 : 0)
                .animation(.easeIn(duration: 0.1), value: isAnimatingErrorView)
        }
        .disabled(targetLetterIndex == logo.letterCount)
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
        LazyHGrid(rows: Array(repeating: .init(.adaptive(minimum: blockSize)), count: 2)) {
            ForEach(0..<logo.letterCount, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: blockSize, height: blockSize)
                        .foregroundColor(.lightGray)
                    Text(revealedAnswers.count > index ? revealedAnswers[index] : "")
                }
                .onTapGesture {
                    revealedAnswers.remove(at: index)
                    targetLetterIndex -= 1
                }
            }
        }
    }
    
    var answerChoicesBlock: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(blockSize)), count: 5)) {
            ForEach(0..<10) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: blockSize, height: blockSize)
                        .foregroundColor(.white)
                    Text(logo.answerChoices[index])
                }
                .onTapGesture {
                    answerChoiceTapped(choice: logo.answerChoices[index])
                }
            }
        }
    }
    
    func answerChoiceTapped(choice: String) {
        print(targetLetterIndex, logo.letterCount)
        if targetLetterIndex < logo.letterCount {
            checkAnswer(choice: choice)
        } else {
            showWrongAnswerWarning()
        }
    }
    
    func checkAnswer(choice: String) {
        if logo.letters[targetLetterIndex] == choice {
            revealedAnswers.append(choice)
            targetLetterIndex += 1
        } else {
            showWrongAnswerWarning()
        }
    }
    
    func showWrongAnswerWarning() {
        isAnimatingErrorView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimatingErrorView = false
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(logo: Logo(name: "꼬꼬면"), parentSize: CGSize(width: 393, height: 393))
    }
}
