//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 04.03.2023.
//

import Foundation

struct GameRecord: Codable,Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct    }
    
    let correct: Int
    let total: Int
    let date: Date

    
    }
