//
//  GameView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/20.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var logoManager: LogoManager
    @State var isAnimatingErrorView = false
    
    let parentSize: CGSize
    let blockSize: CGFloat = 50
    
    var imageBlockSize: CGFloat {
        2 / 3 * parentSize.width
    }
    
    var answerBlockSize: CGFloat {
        let width = (parentSize.width - 20 - CGFloat(10 * logoManager.logo.letterCount)) / CGFloat(logoManager.logo.letterCount)
        return min(width, blockSize)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.darkBlue)
            VStack(alignment: .center) {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundColor(.basicBlue)
                    .frame(height: 50)
                Spacer(minLength: 30)
                quizImage
                answerBlock
                logoManager.logo.solved ? AnyView(nextButton) : AnyView(answerChoicesBlock)
                Spacer(minLength: 70)
                ZStack {
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.basicBlue)
                    HStack {
                        Spacer()
                        bottomButton(name: "x_button") {
                            logoManager.xButtonTapped()
                        }
                        Spacer()
                        bottomButton(name: "retry_button") {
                            logoManager.retryButtonTapped()
                        }
                        Spacer()
                    }
                    .padding(20)
                }
                .frame(height: 70)
            }
        }
        .overlay {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.red)
                .opacity(isAnimatingErrorView ? 0.3 : 0)
                .animation(.easeIn(duration: 0.1), value: isAnimatingErrorView)
        }
//        .disabled(targetLetterIndex == logo.letterCount)
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
            Image(logoManager.logo.logoName)
                .resizable()
                .scaledToFill()
                .frame(width: imageBlockSize - 30, height: imageBlockSize - 30)
                .clipped()
            
            if logoManager.logo.solved {
                Image("gameSuccessCover")
                    .resizable()
                    .frame(width: imageBlockSize, height: imageBlockSize)
                    .opacity(0.5)
            }
        }
    }
    
    var answerBlock: some View {
        LazyHGrid(rows: [.init(.fixed(answerBlockSize))]) {
            ForEach(0..<logoManager.logo.letterCount, id: \.self) { index in
                ZStack {
                    Image(logoManager.answerTrialBackground(at: index))
                        .resizable()
                        .frame(width: answerBlockSize, height: answerBlockSize)
                    Text(logoManager.answerTrialLetter(at: index))
                        .font(.title2)
                        .foregroundColor(logoManager.isSolvedAnswerLetter(at: index) ? .white : .black)
                        .fontWeight(.medium)
                }
                .onTapGesture {
                    logoManager.removeAnswerLetter(at: index)
                }
                .disabled(logoManager.isSolvedAnswerLetter(at: index))
            }
        }
    }
    
    var answerChoicesBlock: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(blockSize)), count: 5)) {
            ForEach(0..<10) { index in
                ZStack {
                    Image(logoManager.answerChoiceBackground(at: index))
                        .resizable()
                        .frame(width: blockSize, height: blockSize)
                    Text(logoManager.answerChoiceLetter(at: index))
                        .font(.title2)
                }
                .onTapGesture {
                    logoManager.tryAnswerChoice(at: index)
                }
                .disabled(logoManager.isSolvedChoiceLetter(at: index))
            }
        }
    }
    
    func bottomButton(name: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(name)
                .resizable()
                .frame(width: 70, height: 70)
        }
    }
    
    var nextButton: some View {
        Button {
            print("next")
        } label: {
            Image("다음버튼")
                .resizable()
                .scaledToFit()
                .frame(width: parentSize.width / 2)
        }
    }
    
    func answerChoiceTapped(index: Int) {
        logoManager.answerChoiceLetter(at: index)
        
        
//        if targetLetterIndex < logo.letterCount {
//            checkAnswer(index: index)
//        } else {
//            showWrongAnswerWarning(index: index)
//        }
    }
    
    func checkAnswer(index: Int) {
//        if logo.letters[targetLetterIndex] == logo.answerChoices[index] {
//            revealedAnswers.append(logo.answerChoices[index])
//            answerManager.reveal(index: targetLetterIndex)
//            targetLetterIndex += 1
//            answerManager.rightAnswerTapped(index: index)
//        } else {
//            showWrongAnswerWarning(index: index)
//        }
    }
    
    func showWrongAnswerWarning(index: Int) {
//        answerManager.wrongAnswerTapped(index: index)
        isAnimatingErrorView = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimatingErrorView = false
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(logoManager: LogoManager(logo: Logo(name: "오동통면", solved: false, answerChoices: ["면", "꼬", "삼", "개", "짜", "라" , "장", "선", "육", "꼬"]), delegate: LogoListManager()) , parentSize: CGSize(width: 393, height: 852))
    }
}
