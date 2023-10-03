//
//  Logo.swift
//  RamyeonLogoQuiz
//
//  Created by JeongAh Hong on 2023/09/18.
//

import Foundation

struct Logo: Hashable {
    let name: String
    let solved: Bool
    let answerChoices: [String]
    
    init(name: String, solved: Bool = false, answerChoices: [String]) {
        self.name = name
        self.solved = solved
        self.answerChoices = answerChoices
    }
    
    var logoName: String {
        solved ? afterName : beforeName
    }
    
    var beforeName: String {
        "\(name)_q"
    }
    
    var afterName: String {
        "\(name)_a"
    }
    
    var letterCount: Int {
        name.count
    }
    
    var letters: [String] {
        name.map {
            String($0)
        }
    }
}

extension Logo {
    init() {
        name = ""
        solved = false
        answerChoices = []
    }
}
