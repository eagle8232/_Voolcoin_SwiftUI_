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
    @State var watchedAmount: Int = 0
//        @State private var showAd = false
    
    @State private var rewardsState: RewardsState = .unwatched
    
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
                    
                    VCDailyRewardsState(watchedAmount: watchedAmount)
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
                VCDailyRewardCardsView()
                    .frame(width: 302, height: 165, alignment: .center)
            }
        }
        
        .onAppear {
            watchedAmount = UserDefaults.standard.integer(forKey: "watchedAmount")
            print(watchedAmount)
            
            if watchedAmount == 3 {
                rewardsState = .watched
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
                        Text("\(watchedAmount)/3 Rewards")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
            }
        }
    }
    
    
    
    struct VCDailyRewardView_Previews: PreviewProvider {
        static var previews: some View {
            VCDailyRewardView()
        }
    }
