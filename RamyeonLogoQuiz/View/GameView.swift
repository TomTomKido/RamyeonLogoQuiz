//
//  GameView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/20.
//

import SwiftUI

struct GameView: View {
    let screenName = "game"
    @ObservedObject var gameManager: GameManager
    @Environment(\.presentationMode) var presentationMode
    let parentSize: CGSize
    @Binding var trigger: Bool
    let blockSize: CGFloat = Utils.isIPad ? 80 : 50
    let backButtonSize: CGFloat = Utils.isIPad ? 60 : 40
    let bottomButtonSize: CGFloat = Utils.isIPad ? 80 : 70
    let cornerRadius: CGFloat = Utils.isIPad ? 20 : 10
    let nextButtonWidth: CGFloat = Utils.isIPad ? 250 : 170
    let nextButtonAnswerChoicesAreaHeight: CGFloat = Utils.isIPad ? 250 : 100
    let font: Font = Utils.isIPad ? .largeTitle : .title2
    let padding: CGFloat = Utils.isIPad ? 30 : 20
    let blockSpacing: CGFloat = Utils.isIPad ? 20 : 10
    let topPadding: CGFloat = Utils.isIPad ? 90 : 40
    let bottomPadding: CGFloat = Utils.isIPad ? 40 : 30
    @EnvironmentObject var logoListManager: LogoListManager
    
    var imageBlockSize: CGFloat {
        parentSize.height * 1 / 3
    }
    
    var answerBlockSize: CGFloat {
        let width = (parentSize.width - blockSpacing - CGFloat(10 * gameManager.logo.letterCount)) / CGFloat(gameManager.logo.letterCount)
        return min(width, blockSize)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundColor(.darkBlue)
            VStack(alignment: .center, spacing: 0) {
                topNavigationBar
                Spacer(minLength: topPadding)
                quizImage
                Spacer()
                answerBlock
                Spacer()
                gameManager.solved ? AnyView(gameEndButton) : AnyView(answerChoicesBlock)
                Spacer(minLength: bottomPadding)
                bottomCancelArea
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            gameManager.reset()
            trigger = true
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("백버튼")
                .resizable()
                .frame(width: backButtonSize, height: backButtonSize)
        })
        .navigationTitle("Stage \(gameManager.currentLogoID + 1)")
        .onAppear {
            LogManager.sendScreenLog(screenName: screenName)
        }
    }
    
    var topNavigationBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundColor(.basicBlue)
                .frame(height: Utils.isIPad ? 20 : 10)
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundColor(.accentBlue)
                .frame(height: 5)
        }
    }
    
    var quizImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.white)
                .frame(width: imageBlockSize, height: imageBlockSize)
                
            Image(gameManager.quizImageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageBlockSize - 30, height: imageBlockSize - 30)
                .clipped()
            
            if gameManager.solved {
                Image("gameSuccessCover")
                    .resizable()
                    .frame(width: imageBlockSize, height: imageBlockSize)
                    .opacity(0.5)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.accentBlue, lineWidth: Utils.isIPad ? 12 : 10)
        }
    }
    
    var answerBlock: some View {
        LazyHGrid(rows: [.init(.fixed(answerBlockSize), spacing: blockSpacing)]) {
            ForEach(0..<gameManager.logo.letterCount, id: \.self) { index in
                ZStack {
                    Image(gameManager.answerTrialBackground(at: index))
                        .resizable()
                        .frame(width: answerBlockSize, height: answerBlockSize)
                    Text(gameManager.answerTrialLetter(at: index))
                        .font(font)
                        .foregroundColor(gameManager.isSolvedAnswerLetter(at: index) ? .white : .black)
                        .fontWeight(.medium)
                }
                .onTapGesture {
                    gameManager.removeAnswerLetter(at: index)
                }
            }
        }
    }
    
    var answerChoicesBlock: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(blockSize), spacing: blockSpacing), count: 5)) {
            ForEach(0..<10) { index in
                ZStack {
                    Image(gameManager.answerChoiceBackground(at: index))
                        .resizable()
                        .frame(width: blockSize, height: blockSize)
                    Text(gameManager.answerChoiceLetter(at: index))
                        .font(font)
                }
                .onTapGesture {
                    gameManager.tryAnswerChoice(at: index)
                }
                .disabled(gameManager.shouldDisableChoiceLetter(at: index))
            }
        }
        .frame(maxHeight: nextButtonAnswerChoicesAreaHeight)
    }
    
    func bottomButton(name: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(name)
                .resizable()
                .frame(width: bottomButtonSize, height: bottomButtonSize)
        }
        .disabled(gameManager.solved)
    }
    
    var gameEndButton: some View {
        if let _ = logoListManager.nextLogo(currentId: gameManager.currentLogoID) {
            return AnyView(nextButton)
        } else {
            return AnyView(endButton)
        }
    }
    
    var nextButton: some View {
        Button {
            if let nextLogo = logoListManager.nextLogo(currentId: gameManager.currentLogoID) {
                gameManager.reset(logo: nextLogo)
            }
        } label: {
            Image("다음버튼")
                .resizable()
                .scaledToFit()
                .frame(width: nextButtonWidth)
        }
        .frame(maxHeight: nextButtonAnswerChoicesAreaHeight)
    }
    
    var endButton: some View {
        Button {
            gameManager.reset()
            trigger = true
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("끝버튼")
                .resizable()
                .scaledToFit()
                .frame(width: nextButtonWidth * 1.5)
        }
        .frame(maxHeight: nextButtonAnswerChoicesAreaHeight)
    }
    
    var bottomCancelArea: some View {
        ZStack {
            VStack(spacing: 0) {
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.accentBlue)
                    .frame(height: 5)
                Rectangle()
                    .foregroundColor(.basicBlue)
                    .frame(height: Utils.isIPad ? 130 : 100)
            }
            HStack {
                Spacer()
                bottomButton(name: "x_button") {
                    gameManager.xButtonTapped()
                }
                Spacer()
                bottomButton(name: "retry_button") {
                    gameManager.retryButtonTapped()
                }
                Spacer()
            }
        }
        .padding(.vertical, padding)
        .frame(height: Utils.isIPad ? 150 : 90)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameManager: GameManager(logo: Logo(name: "오동통면", solved: false, answerChoices: ["면", "꼬", "삼", "개", "짜", "라" , "장", "선", "육", "꼬"], id: 3), delegate: LogoListManager()) , parentSize: CGSize(width: 393, height: 852), trigger: Binding.constant(false))
    }
}
