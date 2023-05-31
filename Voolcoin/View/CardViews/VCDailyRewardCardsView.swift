//
//  VCDailyRewardCardsView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI
import Combine
import CoreData
import GoogleMobileAds
import FirebaseAuth

struct VCDailyRewardCardsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var rewardModel: RewardModel?
    @State var currentWatchedAmount: Int = 0
    @State var currentWatchedCards: [String: Bool] = [:]
    @State var showAd: Bool = false
    
    @State var isShowCard: Bool = true
    @State var isShowCardAfterTime: Bool = false
    
    @State var isRewardLoaded = false
    @State var rewardedDate: Date = Date()
    
    
    var intersitial: Rewarded?
    
    init() {
        intersitial = Rewarded()
    }
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let rewardModel = rewardModel {
                        ForEach(Array(rewardModel.watchedCards.keys.sorted()), id: \.self) { cardKey in
                            let watchedCard = rewardModel.watchedCards[cardKey] ?? false
                            let isShowCard = rewardModel.watchedCards["card\(Int(cardKey.dropFirst(4))! - 1)"] ?? true
                            
                            if isShowCard || isShowCardAfterTime {
                                cardView(watchedCard: watchedCard)
                            } else {
                                VCBlockedCardView()
                            }
                            
                        }
                    } else {
                        cardView(watchedCard: false)
                        VCBlockedCardView()
                        VCBlockedCardView()
                    }
                }
            }
        }
        .onAppear {
            let lasRewardedDate = UserDefaults.standard.object(forKey: "lastReward") as? Date
            
            if timeDifference(date1: Date(), date2: lasRewardedDate ?? Date()) {
                isShowCardAfterTime = true
                
                VCDailyRewardsViewModel().saveDefaultRewardInfo()
                UserDefaults.standard.removeObject(forKey: "lastReward")
            }
            
            fetchDailyRewards { rewardModel in
                print(rewardModel)
            }
            
            guard let watchedCards = UserDefaults.standard.object(forKey: "watchedCards") as? [String: Bool] else {return}
            guard let rewards = UserDefaults.standard.object(forKey: "rewards") as? [String: Double] else {return}
            let watchedAmount = UserDefaults.standard.integer(forKey: "watchedAmount")
           
            let today = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
            rewardModel = RewardModel(watchedCards: watchedCards, rewardAmount: rewards, watchedAmount: watchedAmount, rewardedDate: today)
            
            isRewardLoaded = false
            
            
            
//            DatabaseViewModel().saveDailyRewardsInfoToFirestore(userId: userId, dailyRewardsModel: rewardModel ?? RewardModel(watchedCards: [:], rewardAmount: [:], watchedAmount: 0, rewardedDate: today))
            
        }
    }
    
    func cardView(watchedCard: Bool) -> some View {
        ZStack {
            if !watchedCard {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray).opacity(0.3)
                    .blur(radius: 5)
                    .frame(width: 95, height: 150)
                    .overlay {
                        Button {
                            intersitial?.showAd { transaction in
                                guard let userId = Auth.auth().currentUser?.uid else {return}
                                DatabaseViewModel().saveTransactionsToFirestore(userId: userId, transaction: transaction)
                            }
                            
                            isRewardLoaded = true
                            
                        } label: {
                            
                            VStack {
                                
                                Image("key")
                                    .resizable()
                                    .frame(width: 38, height: 38)
                                
                                Text("Unlock voolcoins")
                                    .font(.system(size: 15, weight: .light, design: .default))
                                    .foregroundColor(.white)
                                
                                ZStack {
                                    Capsule()
                                        .fill(.white)
                                        .frame(width: 70, height: 25)
                                        .overlay {
                                            
                                            HStack(alignment: .center, spacing: 4) {
                                                Text("Claim")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.black)

                                                
                                                Image(systemName: "play.circle")
                                                    .foregroundColor(.black)
                                            }
                                        }
                                }
                            }
                        }
                        .alert(isPresented: $isRewardLoaded) {
                                    Alert(title: Text("Error"), message: Text("Reward not loaded. Please try again later."), dismissButton: .default(Text("ОК")))
                                }
                        
                    }
                    .cornerRadius(20)
                
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray).opacity(0.3)
                    .blur(radius: 5)
                    .frame(width: 95, height: 150)
                    .overlay {
                        
                        VStack {
                            
                            Image("wallet")
                                .resizable()
                                .frame(width: 45, height: 45)
                            
                            Text("Added to wallet")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .opacity(0.5)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                        }
                        
                    }
                    .cornerRadius(20)
            }
        }
    }
    
    func timeDifference(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)
        
        if let minutes = components.minute {
            return abs(minutes) >= 5
        }
        
        return false
    }
    
    func fetchDailyRewards(completion: @escaping ((RewardModel?) -> Void)){
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        DatabaseViewModel().fetchDailyRewardsInfo(userId: userId) { data, error in
            if let data = data, error == nil {
                
                guard let rewardAmountCards = data["rewardAmountCards"] as? [String: Double],
                      let watchedCards = data["watchedCards"] as? [String: Bool],
                      let watchedAmount = data["watchedAmount"] as? Int,
                      let rewardedDate = data["rewardedDate"] as? String else {return}
                
                let rewardModel = RewardModel(watchedCards: watchedCards, rewardAmount: rewardAmountCards, watchedAmount: watchedAmount, rewardedDate: rewardedDate)
                
                completion(rewardModel)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
}

struct VCBlockedCardView: View {
    var rewardState: RewardsState = .unwatched
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.gray).opacity(0.3)
            .blur(radius: 5)
            .frame(width: 95, height: 150)
            .overlay {
                VStack(spacing: 15) {
                    
                    Image("lock")
                        .resizable()
                        .frame(width: 38, height: 38)
                        .opacity(0.5)
                    Text(rewardState == .watched ? "Come back tomorrow" : "Unclock other card")
                        .opacity(0.5)
                        .font(.system(size: 13, weight: .light, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .cornerRadius(20)
    }
}

struct VCDailyRewardCardsView_Previews: PreviewProvider {
    static var previews: some View {
        VCDailyRewardCardsView()
    }
}
