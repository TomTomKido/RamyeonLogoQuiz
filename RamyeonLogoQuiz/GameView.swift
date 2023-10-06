//
//  GameView.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/20.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.presentationMode) var presentationMode
    let parentSize: CGSize
    @Binding var trigger: Bool
    let blockSize: CGFloat = 50
    @EnvironmentObject var logoListManager: LogoListManager
    
    var imageBlockSize: CGFloat {
        2 / 3 * parentSize.width
    }
    
    var answerBlockSize: CGFloat {
        let width = (parentSize.width - 20 - CGFloat(10 * gameManager.logo.letterCount)) / CGFloat(gameManager.logo.letterCount)
        return min(width, blockSize)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.all)
                .foregroundColor(.darkBlue)
            VStack(alignment: .center) {
                Rectangle()
                    .ignoresSafeArea(.all)
                    .foregroundColor(.basicBlue)
                    .frame(height: 20)
                Spacer(minLength: 30)
                quizImage
                answerBlock
                gameManager.solved ? AnyView(nextButton) : AnyView(answerChoicesBlock)
                Spacer(minLength: 70)
                ZStack {
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.basicBlue)
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
                    .padding(20)
                }
                .frame(height: 70)
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
                .frame(width: 40, height: 40)
        })
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
    }
    
    var answerBlock: some View {
        LazyHGrid(rows: [.init(.fixed(answerBlockSize))]) {
            ForEach(0..<gameManager.logo.letterCount, id: \.self) { index in
                ZStack {
                    Image(gameManager.answerTrialBackground(at: index))
                        .resizable()
                        .frame(width: answerBlockSize, height: answerBlockSize)
                    Text(gameManager.answerTrialLetter(at: index))
                        .font(.title2)
                        .foregroundColor(gameManager.isSolvedAnswerLetter(at: index) ? .white : .black)
                        .fontWeight(.medium)
                }
                .onTapGesture {
                    gameManager.removeAnswerLetter(at: index)
                }
//                .disabled(logoManager.isSolvedAnswerLetter(at: index))
            }
        }
    }
    
    var answerChoicesBlock: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(blockSize)), count: 5)) {
            ForEach(0..<10) { index in
                ZStack {
                    Image(gameManager.answerChoiceBackground(at: index))
                        .resizable()
                        .frame(width: blockSize, height: blockSize)
                    Text(gameManager.answerChoiceLetter(at: index))
                        .font(.title2)
                }
                .onTapGesture {
                    gameManager.tryAnswerChoice(at: index)
                }
                .disabled(gameManager.shouldDisableChoiceLetter(at: index))
            }
        }
        .frame(maxHeight: 120)
    }
    
    func bottomButton(name: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(name)
                .resizable()
                .frame(width: 70, height: 70)
        }
        .disabled(gameManager.solved)
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
                .frame(width: parentSize.width / 2)
        }
        .frame(maxHeight: 120)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameManager: GameManager(logo: Logo(name: "오동통면", solved: false, answerChoices: ["면", "꼬", "삼", "개", "짜", "라" , "장", "선", "육", "꼬"], id: 3), delegate: LogoListManager()) , parentSize: CGSize(width: 393, height: 852), trigger: Binding.constant(false))
    }
}
