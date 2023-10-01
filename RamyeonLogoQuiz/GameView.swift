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
    let blockSize: CGFloat = 50
    
    var imageBlockSize: CGFloat {
        2 / 3 * parentSize.width
    }
    
    var answerBlockSize: CGFloat {
        let width = (parentSize.width - 20 - CGFloat(10 * logo.letterCount)) / CGFloat(logo.letterCount)
        return min(width, blockSize)
    }
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
                .frame(width: imageBlockSize, height: imageBlockSize)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentBlue, lineWidth: 10)
                }
            Image(logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: imageBlockSize - 30, height: imageBlockSize - 30)
                .clipped()
        }
    }
    
    var answerBlock: some View {
        LazyHGrid(rows: [.init(.fixed(answerBlockSize))]) {
            ForEach(0..<logo.letterCount, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: answerBlockSize, height: answerBlockSize)
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
        GameView(logo: Logo(name: "꼬꼬면", answerChoices: ["면", "꼬", "삼", "개", "짜", "라" , "장", "선", "육", "꼬"]), parentSize: CGSize(width: 393, height: 393))
    }
}
