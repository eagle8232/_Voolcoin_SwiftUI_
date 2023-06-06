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
    @EnvironmentObject var adManager: AdManager
    
    var rewardModel: VCRewardModel?
    var isShowCardAfterTime: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                DailyRewards(rewardModel: rewardModel, isShowCardAfterTime: isShowCardAfterTime)
            }
        }
    }
    
}

struct DailyRewards: View {
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    var rewardModel: VCRewardModel?
    var isShowCardAfterTime: Bool = false
    
    var body: some View {
        if let rewardModel = rewardModel {
            ForEach(Array(rewardModel.watchedCards.keys.sorted()), id: \.self) { cardKey in
                let watchedCard = rewardModel.watchedCards[cardKey] ?? false
                let isShowCard = rewardModel.watchedCards["card\(Int(cardKey.dropFirst(4))! - 1)"] ?? true
                
                
                
                if isShowCard || isShowCardAfterTime {
                    VCDailyRewardCardView(isWatchedCard: watchedCard)
                } else {
                    VCBlockedCardView()
                }
            }
        } else {
            //This will show, when a user opens the app for the first time with new registered email
            VCDailyRewardCardView(isWatchedCard: false)
            VCBlockedCardView()
            VCBlockedCardView()
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
        VCDailyRewardCardsView(rewardModel: VCRewardModel(watchedCards: [:], rewardAmount: [:], watchedAmount: 0, rewardedDate: ""), isShowCardAfterTime: false)
    }
}
