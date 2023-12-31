//
//  LogoManager.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/30.
//

import Foundation
import Combine

class LogoListManager: ObservableObject {
    let answerChoiceCount = 12
    
    private lazy var answerPool: [String] = {
        var answerCharacters: [String] = []
        (bongjiPaldo + bongjiOttugi + bongjiNongshim).shuffled().forEach { name in
            name.forEach { char in answerCharacters.append(String(char)) }
        }
        return answerCharacters
    }()
    private var tempLogoList: [Logo] = [] {
        didSet {
            guard let data = try? JSONEncoder().encode(tempLogoList) else { return }
            UserDefaults.standard.set(data, forKey: "logoList")
        }
    }
    @Published var logoList: [Logo] = []

    private let bongjiPaldo: [String] = ["꼬꼬면", "남자라면", "비빔면레몬", "왕뚜껑", "일품삼선짜장", "일품해물라면", "틈새라면", "틈새라면고기짬뽕", "틈새라면매운김치", "틈새라면매운짜장", "틈새라면매운카레", "팔도비빔면", "팔도비빔면매운맛", "팔도비빔쫄면", "팔도짜장면"]

    private let bongjiOttugi: [String] = ["냉모밀", "북엇국라면", "열라면", "오!라면", "오동통면", "진라면매운맛", "진라면순한맛", "진진짜라", "참깨라면", "해물짬뽕"]

    private let  bongjiNongshim: [String] = ["감자면", "둥지냉면동치미물냉면", "둥지냉면비빔냉면", "멸치칼국수", "무파마라면", "배홍동비빔면", "보글보글부대찌개면", "볶음너구리", "사리곰탕면", "사천백짬뽕", "사천짜파게티", "순한너구리", "시원한메밀소바", "신라면", "신라면건면", "신라면더레드", "신라면블랙", "신라면블랙두부김치", "안성탕면", "앵그리너구리", "앵그리짜파구리", "야채라면", "얼큰한너구리", "오징어짬뽕", "육개장라면", "장칼국수", "짜왕건면", "짜파게티", "찰비빔면", "튀김우동면", "해물안성탕면", "후루룩국수", "후루룩칼국수"]
    
    private lazy var names: [String] = {
        bongjiPaldo + bongjiOttugi + bongjiNongshim
    }()
    
    init() {
        initializeLogoList()
    }
    
    func name(id: Int) -> String {
        names[id]
    }
    
    func updateLogo(newLogo: Logo) {
        let index = logoIndex(for: newLogo.name)
        tempLogoList[index] = newLogo
    }
    
    func updateLogoList() {
        logoList = tempLogoList
    }
    
    private func logoIndex(for targetName: String) -> Int {
        self.logoList.firstIndex { $0.name == targetName } ?? 0
    }
    
    private func initializeLogoList() {
        if let data = UserDefaults.standard.object(forKey: "logoList") as? Data,
           let oldLogoList = try? JSONDecoder().decode([Logo].self, from: data) {
            
            if oldLogoList[0].answerChoices.count == 12 {
                self.logoList = oldLogoList
                self.tempLogoList = oldLogoList
            } else {
                let mergedLogoList = (bongjiPaldo + bongjiOttugi + bongjiNongshim).enumerated().map { (index, name) in
                    Logo(name: name, solved: oldLogoList[index].solved, answerChoices: getAnswerChoices(name: name), id: index)
                }
                
                self.logoList = mergedLogoList
                self.tempLogoList = mergedLogoList
            }
            
            return
        }
    
        let newLogoList = (bongjiPaldo + bongjiOttugi + bongjiNongshim).enumerated().map { (index, name) in
            Logo(name: name, answerChoices: getAnswerChoices(name: name), id: index)
        }
        self.logoList = newLogoList
        self.tempLogoList = newLogoList
    }
    
    private func getAnswerChoices(name: String) -> [String] {
        var answerChoices: [String] = name.compactMap { String($0) }
        var index = 0
        
        if answerChoices.count < answerChoiceCount {
            repeat {
                let currentChar = String(answerPool[index])
                if !answerChoices.contains(currentChar) {
                    answerChoices.append(currentChar)
                }
                index += 1
            } while answerChoices.count < answerChoiceCount
        }
        
        return answerChoices.shuffled()
    }
    
    func nextLogo(currentId: Int) -> Logo? {
        guard currentId + 1 < logoList.count else {
            return nil
        }

        return logoList[currentId + 1]
    }
}
