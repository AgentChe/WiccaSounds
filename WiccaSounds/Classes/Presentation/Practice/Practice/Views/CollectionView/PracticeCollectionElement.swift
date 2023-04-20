//
//  PracticeCollectionElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

enum PracticeCollectionElement {
    case tarot(PracticeTarotElement)
    case rune(PracticeRuneElement)
}

struct PracticeTarotElement {
    let tarot: TarotCover
    let paid: Bool
}

struct PracticeRuneElement {
    let rune: RuneCover
    let paid: Bool
}
