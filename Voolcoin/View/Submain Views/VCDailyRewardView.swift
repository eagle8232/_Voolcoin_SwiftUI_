//
//  VCDailyRewardView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI

enum RewardsState {
    case watched
    case unwatched
}

struct VCDailyRewardView: View {
    var rewardsState: RewardsState = .unwatched
    var rewardModel: VCRewardModel?
    var isShowCardAfterTime: Bool?
    var isDataFetched: Bool?
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Daily rewards")
                        .font(.title2.bold())
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.white)
                    
                    VCDailyRewardsState(watchedAmount: rewardModel?.watchedAmount ?? 0)
                        .padding(.trailing)
                }
                
                Text("The chance to win rewards from 0.1 to 10 voolcoins")
                    .font(.callout)
                    .fontWeight(.light)
                    .opacity(0.7)
                    .padding(.horizontal)
                    .foregroundColor(.white)
            }
            
            switch rewardsState {
            case .watched:
                HStack {
                    VCBlockedCardView(rewardState: rewardsState)
                    VCBlockedCardView(rewardState: rewardsState)
                    VCBlockedCardView(rewardState: rewardsState)
                }
            case .unwatched:
                VCDailyRewardCardsView(rewardModel: rewardModel, isShowCardAfterTime: isShowCardAfterTime ?? false)
                    .frame(width: 302, height: 165, alignment: .center)
            }
        }
        .padding(.bottom)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        
        
    }
}

struct VCDailyRewardsState: View {
    var watchedAmount = 0
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(watchedAmount == 3 ? .green : .yellow)
                .frame(width: 85, height: 30)
                .overlay {
                    
                    HStack(alignment: .center, spacing: 2) {
                        
                        Text("\(watchedAmount)/3")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        
                        Text("Rewards")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
        }
    }
}



struct VCDailyRewardView_Previews: PreviewProvider {
    static var previews: some View {
        VCDailyRewardView()
    }
}
