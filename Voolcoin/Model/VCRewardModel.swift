//
//  VCRewardModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 09.05.23.
//

import Foundation

enum RewardType {
    case rewarded
    case notrewarded
}

struct RewardModel {
    let watchedCards: [String: Bool]
    let rewardAmount: [String: Double]
    let watchedAmount: Int
    let rewardedDate: String
}
