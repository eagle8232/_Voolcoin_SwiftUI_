//
//  videoAdInterstitial.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 06.05.23.
//

import GoogleMobileAds
import SwiftUI
import UIKit
import AppTrackingTransparency
import AdSupport


final class Rewarded: NSObject, GADFullScreenContentDelegate {
    
    @Published private var isRewardLoaded = true
    
    var rewardAmount: Double = Double.random(in: 0.1...10)
    
    let today = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
    
    var rewardModel: VCRewardModel?
    
    var rewardedAd: GADRewardedInterstitialAd?
    var dailyRewardVM = VCDailyRewardsViewModel()
    
    var onDismiss: ((VCTransactionModel, VCRewardModel, (Bool, String)?) -> Void)?
    
    var error: (Bool, String)?
    
    
    @Published var watchedAmount: Int = 0
    @Published var watchedCards: [String: Bool] = [:]
    @Published var rewards: [String: Double] = [:]
    @Published var adDismissed = false
    
    
    //ca-app-pub-1633444832866213/7626120561
    
    let adUnitId: String = "ca-app-pub-1633444832866213/7626120561"
    //ca-app-pub-1633444832866213/3064074930 ad reward
    //ca-app-pub-1633444832866213/1743161545 int ad
    //ca-app-pub-7829184150158566/3060985751 - for kamraniosdeveloper@gmail.com
    //for testing: ca-app-pub-3940256099942544/1712485313
    override init() {
        super.init()
        loadAd()
    }
    
    
    func loadAd() {
        
        let request = GADRequest()
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["b136fc524c09a9bdc02fd318a52fcf88", "8b4fb722d123c7b1100a4275f458e362", "ce0b72bf211b0fd9a27480978527062e"]
        
//        GADInterstitialAd
        GADRewardedInterstitialAd.load(withAdUnitID: adUnitId, request: request) { ad, error in
            if let error = error {
                self.isRewardLoaded = false
                print("Loading failed with error: \(error)")
                self.error = (true, error.localizedDescription)
            } else {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .notDetermined:
                        print("notDetermined")
                    case .restricted:
                        print("restricted")
                    case .denied:
                        print("denied")
                    case .authorized:
                        print("authorized")
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    @unknown default:
                        print("unknown")
                    }
                }
                print("Loading Succeeded")
                self.isRewardLoaded = true
                self.rewardedAd = ad
                self.rewardedAd?.fullScreenContentDelegate = self
            }
        }
    }
    
    func showAd(watchedCards: [String : Bool], rewards: [String : Double], watchedAmount: Int, onDismiss: @escaping (VCTransactionModel, VCRewardModel, (Bool, String)?) -> Void) {
        guard let rewardedInterstitialAd = rewardedAd else {
            isRewardLoaded = false
            return print("Ad wasn't ready.")
        }
        let root = UIApplication.shared.windows.first?.rootViewController
        
        rewardedInterstitialAd.present(fromRootViewController: root!) {
            let reward = rewardedInterstitialAd.adReward
            self.onDismiss = onDismiss
            self.rewardTheUser(watchedCards: watchedCards, rewards: rewards, watchedAmount: watchedAmount)
            self.isRewardLoaded = true
        }
        
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed. Rewarding user.")
        
        // Reload ad for the next time
        
        loadAd()
    }
    
    func rewardTheUser(watchedCards: [String: Bool], rewards: [String: Double], watchedAmount: Int) {
        self.watchedAmount = watchedAmount
        
        if (watchedCards["card1"] ?? false) {
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
            
            self.watchedAmount += 1
            
            dailyRewardVM.saveRewardInfo(watchedCards: self.watchedCards, rewards: self.rewards, watchedAmount: watchedAmount)
            
            rewardModel = VCRewardModel(watchedCards: self.watchedCards, rewardAmount: self.rewards, watchedAmount: self.watchedAmount, rewardedDate: today)
        } else {
            rewardModel = dailyRewardVM.saveDefaultRewardInfo(rewardAmount: rewardAmount)
        }
        
        let transaction = VCTransactionModel(id: nil, type: .income, amount: rewardAmount, date: today)
        
        onDismiss?(transaction, rewardModel ?? VCRewardModel(watchedCards: [:], rewardAmount: [:], watchedAmount: 0, rewardedDate: ""), self.error)
    }
}
