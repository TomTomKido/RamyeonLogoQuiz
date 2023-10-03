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
    private let answer: [String]
    private var answerChoiceLetters: [ChoiceLetter]
    @Published var answerTrialLetters: [TrialLetter]
    private var subscriptions = Set<AnyCancellable>()
    private var currentIndex: Int = 0
    
    init(logo: Logo, delegate: LogoListManager) {
        self.logo = logo
        self.answer = logo.name.map { String($0) }
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
    
    //MARK: choice
    
    private func choiceLetter(with answerIndex: Int) -> ChoiceLetter {
        let choice = answerChoiceLetters.first(where: { $0.answerIndex == answerIndex })
        return choice ?? ChoiceLetter()
    }
    
    private func choiceIndex(with answerIndex: Int) -> Int? {
        return answerChoiceLetters.firstIndex(where: { $0.answerIndex == answerIndex })
    }
    
    //MARK: answer
    
    func answerBackground(at answerIndex: Int) -> String {
        choiceLetter(with: answerIndex).status.answerBackgroundName
    }
    
    func answerLetter(at answerIndex: Int) -> String {
        choiceLetter(with: answerIndex).letter
    }
    
    //MARK: trial
    
    func answerTrialBackground(at answerIndex: Int) -> String {
        answerTrialLetters[answerIndex].backgroundName
    }
    
    func answerTrialLetter(at answerIndex: Int) -> String {
        answerTrialLetters[answerIndex].letter
    }
    
    //MARK: choice
    
    func answerChoiceBackground(at choiceIndex: Int) -> String {
        isTrying(choiceIndex: choiceIndex) ? "회색배경" : answerChoiceLetters[choiceIndex].status.backgroundName
    }
    
    func answerChoiceLetter(at choiceIndex: Int) -> String {
        answerChoiceLetters[choiceIndex].letter
    }
    
    //MARK: block tapped
    
    func removeAnswerLetter(at answerIndex: Int) {
        if answerTrialLetters[answerIndex].revealed { return }
        
        answerTrialLetters[answerIndex].removeFromTrial()
        updateCurrentIndex()
    }
    
    func tryAnswerChoice(at choiceIndex: Int) {
        if answerChoiceLetters[choiceIndex].status == .correct { return }
        guard currentIndex < answerTrialLetters.count else { return }
        
        let choiceLetter = answerChoiceLetter(at: choiceIndex)
        answerTrialLetters[currentIndex].addToTrial(letter: choiceLetter, choiceIndex: choiceIndex)
        updateCurrentIndex()
    }
    
    //MARK: currentIndex
    
    private func updateCurrentIndex() {
        if let firstEmptyIndex = answerTrialLetters.firstIndex(where: { $0.letter == "" && !$0.revealed }) {
            currentIndex = firstEmptyIndex
        } else {
            currentIndex = answerTrialLetters.count
            checkAnswer()
        }
    }
    
    private func moveCurrentIndexForward() {
//        repeat {
//            if answerTrialLetters[currentIndex].letter == "" {
//                currentIndex += 1
//            }
//        } while currentIndex < answerTrialLetters.count && answerTrialLetters[currentIndex].letter == ""
    }
    
    private func moveCurrentIndexBackward() {
        
    }
    
    //MARK: disable block
    
    func shouldDisableChoiceLetter(at choiceIndex: Int) -> Bool {
        answerChoiceLetters[choiceIndex].status == .correct
        || answerChoiceLetters[choiceIndex].status == .wrong
        || isTrying(choiceIndex: choiceIndex)
    }
    
    func isSolvedAnswerLetter(at answerIndex: Int) -> Bool {
        choiceLetter(with: answerIndex).status == .correct
    }
    
    //MARK: bottom Buttons
    
    func xButtonTapped() {
        guard currentIndex != 0 else { return }
        guard let lastIndex = answerTrialLetters.lastIndex(where: { $0.revealed == false && $0.letter != "" }) else { return }
        
        answerTrialLetters[lastIndex].removeFromTrial()
        updateCurrentIndex()
    }
    
    func retryButtonTapped() {
        (0..<answerTrialLetters.count).forEach { index in
            if !answerTrialLetters[index].revealed {
                answerTrialLetters[index].removeFromTrial()
            }
        }
        
        updateCurrentIndex()
    }
    
    func checkAnswer() {
        answerTrialLetters.enumerated().forEach { [weak self] (answerIndex, trialLetter) in
            guard let self else { return }
            let choiceIndex = answerTrialLetters[answerIndex].choiceIndex
            
            if trialLetter.letter == self.answer[answerIndex] {
                answerTrialLetters[answerIndex].revealed = true
                answerChoiceLetters[choiceIndex].status = .correct
            } else if self.answer.contains(trialLetter.letter) {
                answerChoiceLetters[choiceIndex].status = .halfCorrect
            } else {
                answerChoiceLetters[choiceIndex].status = .wrong
            }
        }
        
        answerTrialLetters.enumerated().forEach { [weak self] (index, trialLetter) in
            self?.answerTrialLetters[index].removeFromTrial()
        }
        
        if didFinishGame() {
            return
        }
        
        updateCurrentIndex()
    }
    
    private func didFinishGame() -> Bool {
        if answerTrialLetters.filter({ !$0.revealed }).count == 0 {
            let newLogo = Logo(name: logo.name, solved: true, answerChoices: logo.answerChoices)
            logo = newLogo
            delegate?.updateLogo(newLogo: newLogo)
            return true
        }
        
        return false
    }
    
    func isTrying(choiceIndex: Int) -> Bool {
        !answerTrialLetters.filter { $0.choiceIndex == choiceIndex }.isEmpty
    }
}

struct TrialLetter {
    var letter: String
    var revealed: Bool
    var choiceIndex: Int
    var backgroundName: String {
        revealed ? "정답배경" : "기본배경"
    }
    
    mutating func removeFromTrial() {
        if !revealed {
            self.letter = ""
            self.choiceIndex = -1
        }
    }
    
    mutating func addToTrial(letter: String, choiceIndex: Int) {
        if !revealed {
            self.letter = letter
            self.choiceIndex = choiceIndex
        }
    }
}

extension TrialLetter {
    init() {
        self.letter = ""
        self.revealed = false
        choiceIndex = -1
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
