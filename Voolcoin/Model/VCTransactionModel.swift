//
//  VCTransactionModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import Foundation

enum TransactionType: String, CaseIterable, Codable {
    case all = "All"
    case income = "Income"
    case outcome = "Outcome"
}

struct VCTransactionModel: Codable, Hashable, Identifiable {
    var id: UUID?
    let type: TransactionType
    let amount: Double
    let date: String
    
    func getReward() -> Double {
        let generateRanNum = Double.random(in: 0.1...10)
        return generateRanNum
    }
    
}
