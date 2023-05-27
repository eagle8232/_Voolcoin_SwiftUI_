//
//  VCDailyRewardsViewModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import Foundation

class VCDailyRewardsViewModel {
    func saveDefaultRewardInfo(rewardAmount: Double? = 0) {
        let watchedCards = ["card1": rewardAmount != 0 ? true : false, "card2": false, "card3": false]
        let rewards = ["card1": rewardAmount, "card2": 0, "card3": 0]
        let watchedAmount = 1
        
        //Save
        UserDefaults.standard.set(watchedCards, forKey: "watchedCards")
        UserDefaults.standard.set(rewards, forKey: "rewards")
        UserDefaults.standard.set(watchedAmount, forKey: "watchedAmount")
        UserDefaults.standard.set(Date(), forKey: "rewardedDate")
    }
    
    func saveRewardInfo(watchedCards: [String: Bool], rewards: [String: Double], watchedAmount: Int) {
        //Save
        UserDefaults.standard.set(watchedCards, forKey: "watchedCards")
        UserDefaults.standard.set(rewards, forKey: "rewards")
        UserDefaults.standard.set(watchedAmount, forKey: "watchedAmount")
        UserDefaults.standard.set(Date(), forKey: "rewardedDate")
    }
}
