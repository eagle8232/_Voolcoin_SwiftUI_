//
//  VCDailyRewardCardView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/5/23.
//

import SwiftUI
import FirebaseAuth

enum TappedCard {
    case tappedCard1
    case tappedCard2
    case tappedCard3
}

struct VCDailyRewardCardView: View {
    @EnvironmentObject var adManager: AdManager
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    @State var isRewardLoaded: Bool = false
    @State var isGlowing = false
    
    var isWatchedCard: Bool = false
    
    var body: some View {
        
        ZStack {
            if !isWatchedCard {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray).opacity(0.3)
                    .blur(radius: 5)
                    .frame(width: 95, height: 150)
                    .shadow(color: .green, radius: isGlowing ? 39 : 0)
                    .onAppear {
                        startGlowAnimation()
                    }
                    .overlay {
                        Button {
                            let watchedCards = firebaseDBManager.rewardModel?.watchedCards ?? [:]
                            let rewardAmount = firebaseDBManager.rewardModel?.rewardAmount ?? [:]
                            let watchedAmount = firebaseDBManager.rewardModel?.watchedAmount ?? 0

                            adManager.intersitial?.showAd(watchedCards: watchedCards, rewards: rewardAmount, watchedAmount: watchedAmount, onDismiss: {  transaction, rewardModel, error  in
                                
                                if let error = error {
                                    adManager.error = error
                                } else {
                                    guard let userId = Auth.auth().currentUser?.uid else {return}
                                    
                                    print(transaction)
                                    DatabaseViewModel().saveTransactionsToFirestore(userId: userId, transaction: transaction)
                                    
                                    DatabaseViewModel().saveDailyRewardsInfoToFirestore(userId: userId, dailyRewardsModel: rewardModel)
                                    
                                    firebaseDBManager.transactions?.append(transaction)
                                    firebaseDBManager.rewardModel = rewardModel
                                    firebaseDBManager.rewardState = (rewardModel.watchedCards["card3"] ?? false) ? .watched : .unwatched
                                    firebaseDBManager.calculateCardAmount()
                                    
                                    firebaseDBManager.isShowCardAfterTime = true
                                    
                                    adManager.intersitial = Rewarded()
                                }
                                
                            })
                            
                            
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
    
    private func startGlowAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
            isGlowing = true
        }
    }
}

struct VCDailyRewardCardView_Previews: PreviewProvider {
    static var previews: some View {
        VCDailyRewardCardView()
    }
}
