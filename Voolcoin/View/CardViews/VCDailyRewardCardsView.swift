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
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    @State var isDataFetched: Bool = false
    
    @State var rewardModel: VCRewardModel?
    @State var isShowCardAfterTime: Bool?
    
    @State var isRewardLoaded = false
    
    var intersitial: Rewarded?
    
    init(rewardModel: VCRewardModel?, isShowCardAfterTime: Bool?, isDataFetched: Bool?) {
        intersitial = Rewarded()
        self.rewardModel = rewardModel
        self.isShowCardAfterTime = isShowCardAfterTime
        self.isDataFetched = isDataFetched ?? false
    }
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let rewardModel = rewardModel {
                        ForEach(Array(rewardModel.watchedCards.keys.sorted()), id: \.self) { cardKey in
                            let watchedCard = rewardModel.watchedCards[cardKey] ?? false
                            let isShowCard = rewardModel.watchedCards["card\(Int(cardKey.dropFirst(4))! - 1)"] ?? true
                            
                            if isShowCard || (isShowCardAfterTime != nil) {
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
                            intersitial?.showAd { transaction, rewardModel  in    
                                
                                guard let userId = Auth.auth().currentUser?.uid else {return}
                                
                                print(transaction)
                                DatabaseViewModel().saveTransactionsToFirestore(userId: userId, transaction: transaction)
                                
                                DatabaseViewModel().saveDailyRewardsInfoToFirestore(userId: userId, dailyRewardsModel: rewardModel)
                                
                                firebaseDBManager.transactions?.append(transaction)
                                firebaseDBManager.rewardModel = rewardModel
                                firebaseDBManager.calculateCardAmount()
                                
                                
                                self.rewardModel = rewardModel
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
        VCDailyRewardCardsView(rewardModel: VCRewardModel(watchedCards: [:], rewardAmount: [:], watchedAmount: 0, rewardedDate: ""), isShowCardAfterTime: false, isDataFetched: true)
    }
}
