//
//  LogoManager.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/10/02.
//

import Combine

class LogoManager: ObservableObject {
    weak var delegate: LogoListManager?
    private(set) var logo: Logo
    private var answerChoiceLetters: [ChoiceLetter]
    @Published var answerTrialLetters: [TrialLetter]
    private var subscriptions = Set<AnyCancellable>()
    private var currentIndex: Int = 0
    
    init(logo: Logo, delegate: LogoListManager) {
        self.logo = logo
        self.answerChoiceLetters = logo.answerChoices.map { ChoiceLetter(letter: $0, status: .unsolved, answerIndex: -1) }
        self.answerTrialLetters = Array(repeating: TrialLetter(), count: logo.letterCount)
        self.delegate = delegate
        
        logo.name.enumerated().forEach { [weak self] (index, letter) in
            if let targetIndex = self?.answerChoiceLetters.firstIndex(where: { $0.letter == String(letter) && $0.answerIndex == -1 }) {
                self?.answerChoiceLetters[targetIndex].initialize(answerIndex: index)
            }
        }

//        $revealedAnswers
//            .sink { [weak self] answers in
//                guard let self else { return }
//                if answers.joined() == self.logo.name {
//                    self.delegate?.updateLogo(logo: self.logo)
//                }
//            }
//            .store(in: &subscriptions)
    }
    
    private func choice(at answerIndex: Int) -> ChoiceLetter {
        let choice = answerChoiceLetters.first(where: { $0.answerIndex == answerIndex })
        return choice ?? ChoiceLetter()
    }
    
    private func choiceIndex(at answerIndex: Int) -> Int? {
        return answerChoiceLetters.firstIndex(where: { $0.answerIndex == answerIndex })
    }
    
    // answer
    
    func answerBackground(at answerIndex: Int) -> String {
        choice(at: answerIndex).status.answerBackgroundName
    }
    
    func answerLetter(at answerIndex: Int) -> String {
        choice(at: answerIndex).letter
    }
    
    // trial
    
    func answerTrialBackground(at answerIndex: Int) -> String {
        answerTrialLetters[answerIndex].backgroundName
    }
    
    func answerTrialLetter(at answerIndex: Int) -> String {
        answerTrialLetters[answerIndex].letter
    }
    
    // choice
    
    func answerChoiceBackground(at choiceIndex: Int) -> String {
        answerChoiceLetters[choiceIndex].status.backgroundName
    }
    
    func answerChoiceLetter(at choiceIndex: Int) -> String {
        answerChoiceLetters[choiceIndex].letter
    }
    
    // block tapped
    
    func removeAnswerLetter(at answerIndex: Int) {
        answerTrialLetters[answerIndex].letter = ""
        updateCurrentIndex()
    }
    
    func tryAnswerChoice(at choiceIndex: Int) {
        guard currentIndex < answerTrialLetters.count else { return }
        let choiceLetter = answerChoiceLetter(at: choiceIndex)
        answerTrialLetters[currentIndex].letter = choiceLetter
        updateCurrentIndex()
    }
    
    private func updateCurrentIndex() {
        if currentIndex == answerTrialLetters.count - 1 {
            currentIndex += 1
            checkAnswer()
        } else {
            currentIndex = answerTrialLetters.firstIndex(where: { $0.letter == "" }) ?? currentIndex
        }
    }
    
    // disable block
    
    func isSolvedChoiceLetter(at choiceIndex: Int) -> Bool {
        answerChoiceLetters[choiceIndex].status == .correct
    }
    
    func isSolvedAnswerLetter(at answerIndex: Int) -> Bool {
        choice(at: answerIndex).status == .correct
    }
    
    // bottom Buttons
    
    func xButtonTapped() {
        guard currentIndex != 0 else { return }
        guard let lastIndex = answerTrialLetters.lastIndex(where: { $0.revealed == false && $0.letter != "" }) else { return }
        currentIndex = lastIndex
        answerTrialLetters[lastIndex].letter = ""
    }
    
    func retryButtonTapped() {
        (0..<answerTrialLetters.count).forEach { index in
            if !answerTrialLetters[index].revealed {
                answerTrialLetters[index].letter = ""
            }
        }
        
        updateCurrentIndex()
    }
    
    func checkAnswer() {
        
    }
    
    
}

struct TrialLetter {
    var letter: String
    var revealed: Bool
    var backgroundName: String {
        revealed ? "정답배경" : "기본배경"
    }
}

extension TrialLetter {
    init() {
        self.letter = ""
        self.revealed = false
    }
}

struct ChoiceLetter {
    let letter: String
    var status: RevealStatus
    var answerIndex: Int
    
    enum RevealStatus {
        case unsolved
        case wrong
        case correct
        case halfCorrect
        
        var backgroundName: String {
            switch self {
            case .unsolved:
                return "기본배경"
            case .wrong:
                return "오답배경"
            case .correct:
                return "정답배경"
            case .halfCorrect:
                return "노란배경"
            }
        }
        
        var answerBackgroundName: String {
            switch self {
            case .correct:
                return "정답배경"
            default:
                return "기본배경"
            }
        }
    }
    
    mutating func initialize(answerIndex: Int) {
        self.answerIndex = answerIndex
    }
}

extension ChoiceLetter {
    init() {
        self.letter = ""
        self.status = .unsolved
        self.answerIndex = -1
    }
}
