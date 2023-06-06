//
//  VCDailyRewardsViewModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import Foundation
import FirebaseAuth

class VCDailyRewardsViewModel {
    func saveDefaultRewardInfo(rewardAmount: Double? = 0) -> VCRewardModel {
        let watchedCards = ["card1": rewardAmount != 0 ? true : false, "card2": false, "card3": false]
        let rewards = ["card1": rewardAmount, "card2": 0, "card3": 0]
        let watchedAmount = rewardAmount != 0 ? 1 : 0
        
        //Save
        UserDefaults.standard.set(watchedCards, forKey: "watchedCards")
        UserDefaults.standard.set(rewards, forKey: "rewards")
        UserDefaults.standard.set(watchedAmount, forKey: "watchedAmount")
        UserDefaults.standard.set(Date(), forKey: "rewardedDate")
        
        let rewardModel = VCRewardModel(watchedCards: watchedCards, rewardAmount: rewards, watchedAmount: watchedAmount, rewardedDate: Date().toString(format: DateFormatKey.wholeFormat.rawValue))
        
        return rewardModel
    }
    
    func saveRewardInfo(watchedCards: [String: Bool], rewards: [String: Double], watchedAmount: Int) {
        //Save
        setUserDefaults(watchedCards: watchedCards, rewards: rewards, watchedAmount: watchedAmount)
    }
    
    func setUserDefaults(watchedCards: [String: Bool], rewards: [String: Double], watchedAmount: Int ) {
        UserDefaults.standard.set(watchedCards, forKey: "watchedCards")
        UserDefaults.standard.set(rewards, forKey: "rewards")
        UserDefaults.standard.set(watchedAmount, forKey: "watchedAmount")
        UserDefaults.standard.set(Date(), forKey: "rewardedDate")
    }
}
