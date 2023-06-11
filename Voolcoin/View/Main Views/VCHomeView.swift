//
//  Home.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 03.05.23.
//

import SwiftUI
import FirebaseAuth

struct VCHomeView: View {
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    @State var isPresentingTransactionsView: Bool = false
    @State var isPresentingInfoView: Bool = false
    
    @State var errorHandling: Bool = false
    
    @State var showProfileView: Bool = false
    
    @State var chosenType: TransactionType = .all
    
    
    
    var body: some View {
        if firebaseDBManager.isDataFetched {
            NavigationView {
                
                ZStack {
                    VCLinearGradientView()
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12) {
                            HStack(spacing: 15) {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.gray.opacity(0.4))
                                
                                    .overlay {
                                        Button {
                                            showProfileView = true
                                        } label: {
                                            Image(systemName: "person")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.white)
                                        }
                                    }
                                
                                
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                    Text("Welcome back")
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundColor(.white)
                                    
                                    Text(firebaseDBManager.userModel?.name ?? "Person")
                                        .font(.system(size: 25, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                NavigationLink(destination: VCSettingsView()) {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color.gray.opacity(0.4))
                                    
                                        .overlay {
                                            Image(systemName: "gear")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.white)
                                        }
                                    
                                }
                                
                                
                            }
                            
                            Spacer()
                            
                            VCCardView(isPresentingTransactionsView: $isPresentingTransactionsView, isPresentingInfoView: $isPresentingInfoView, chosenType: $chosenType, lastIncome: firebaseDBManager.transactions?.last {$0.type.rawValue == "Income"}?.amount ?? 0, lastOutcome: firebaseDBManager.transactions?.last {$0.type.rawValue == "Outcome"}?.amount ?? 0)
                            
                            Spacer()
                            
                            VCDetailsView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: .constant(.all), transactions: firebaseDBManager.transactions ?? [])
                            
                            Spacer()
                            
                            VCDailyRewardView(rewardModel: firebaseDBManager.rewardModel, isShowCardAfterTime: firebaseDBManager.isShowCardAfterTime, isDataFetched: firebaseDBManager.isDataFetched)
                            
                        }
                        
                        .alert(isPresented: $errorHandling) {
                            Alert(title: Text("atte"), message: Text("error"), dismissButton: .cancel(Text("OK")))
                        }
                        .padding()
                        
                    }
                    
                    VCProfileView(isShowingProfileView: $showProfileView, userModel: firebaseDBManager.userModel)
                    
                    if isPresentingInfoView {
                        InfoView(isPresentingInfoView: $isPresentingInfoView)
                    }
                    
                }
                
                .fullScreenCover(isPresented: $isPresentingTransactionsView, onDismiss: {
                    chosenType = .all
                }) {
                    VCAllTransactionsView(isPresenting: $isPresentingTransactionsView, chosenType: $chosenType, transactions: firebaseDBManager.transactions ?? [])
                    
                }
                
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
            .refreshable {
                firebaseDBManager.fetchData()
            }
        }
        else {
            VCProgressView()
        }
        
        
    }
}


struct VCHomeView_Previews: PreviewProvider {
    static var previews: some View {
        VCHomeView()
    }
}
