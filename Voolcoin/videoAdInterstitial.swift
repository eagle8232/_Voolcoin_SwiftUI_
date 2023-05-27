//
//  videoAdInterstitial.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 06.05.23.
//

import GoogleMobileAds
import SwiftUI
import UIKit
import CoreData


final class Rewarded: NSObject, GADFullScreenContentDelegate {
    
    @Published private var isRewardLoaded = true
    
    var rewardedAd: GADInterstitialAd?
    var dailyRewardVM = VCDailyRewardsViewModel()
    
    var onDismiss: ((VCTransactionModel) -> Void)?
    
    
    
    @Published var watchedAmount: Int = 0
    @Published var watchedCards: [String: Bool] = [:]
    @Published var rewards: [String: Double] = [:]
    @Published var adDismissed = false
    
    override init() {
        super.init()
        loadAd()
    }
    
    
    func loadAd() {
        let request = GADRequest()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["eabfbb8f46892d02e3ce765b77e9752e"]
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-1633444832866213/1743161545", request: request) { (ad, error) in
            if let error = error {
                self.isRewardLoaded = false
                print("Loading failed with error: \(error)")
            } else {
                print("Loading Succeeded")
                self.isRewardLoaded = true
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        }
    }
    
    func showAd(onDismiss: @escaping (VCTransactionModel) -> Void) {
        if let ad = rewardedAd {
            let root = UIApplication.shared.windows.first?.rootViewController
            ad.present(fromRootViewController: root!)
            self.onDismiss = onDismiss
            self.isRewardLoaded = true
        } else {
            print("Ad wasn't ready")
            self.isRewardLoaded = false
            
        }
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        watchedAmount = UserDefaults.standard.integer(forKey: "watchedAmount")
        
        var rewardAmount: Double {
            let generateRanNum = Double.random(in: 0.1...10)
            return generateRanNum
        }
        
        if let watchedCards = UserDefaults.standard.object(forKey: "watchedCards") as? [String: Bool],
           let rewards = UserDefaults.standard.object(forKey: "rewards") as? [String: Double], watchedCards["card1"]! {
            
            self.watchedCards = watchedCards
            self.rewards = rewards
            
            if (watchedCards["card1"] ?? true) && !(watchedCards["card2"] ?? true) {
                self.watchedCards = ["card1": true, "card2": true, "card3": false]
                self.rewards["card2"] = rewardAmount
            } else {
                self.watchedCards = ["card1": true, "card2": true, "card3": true]
                self.rewards["card3"] = rewardAmount
                UserDefaults.standard.set(Date(), forKey: "lastReward")
            }
            watchedAmount += 1
            dailyRewardVM.saveRewardInfo(watchedCards: self.watchedCards, rewards: self.rewards, watchedAmount: watchedAmount)
        } else {
            dailyRewardVM.saveDefaultRewardInfo(rewardAmount: rewardAmount)
        }
        
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed. Rewarding user.")
        // Save to CoreData
        var rewardAmount: Double {
            let generateRanNum = Double.random(in: 0.1...10)
            return generateRanNum
        }
        
        let transaction = VCTransactionModel(id: nil, type: .income, amount: rewardAmount, date: Date())
        
        onDismiss?(transaction)
        
        // Reload ad for the next time
        loadAd()
    }
}
