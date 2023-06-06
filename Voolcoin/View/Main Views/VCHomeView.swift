//
//  Home.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 03.05.23.
//

import SwiftUI
import FirebaseAuth

struct VCHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isPresentingTransactionsView: Bool = false
    @State var errorHandling: Bool = false
    
    @State var chosenType: TransactionType = .all
    
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    private let dataGroup = DispatchGroup()
    
    var body: some View {
        NavigationView {
            ZStack {
                VCLinearGradientView()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        HStack(spacing: 15) {
                            NavigationLink(destination: VCProfileView(userModel: firebaseDBManager.userModel)) {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.gray.opacity(0.4))
                                
                                    .overlay {
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
                                
                                Text(firebaseDBManager.userModel?.name ?? "")
                                    .font(.system(size: 25, weight: .bold, design: .default))
//                                    .font(.largeTitle.bold())
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
                            .navigationBarTitle("")
                            .navigationBarBackButtonHidden(true)
                        }
                        
                        Spacer()
                        
                        VCCardView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: $chosenType, incomeTransaction: firebaseDBManager.transactions?.last {$0.type.rawValue == "Income"} ?? VCTransactionModel(type: .income, amount: 0, date: ""), outcomeTransaction: firebaseDBManager.transactions?.last {$0.type.rawValue == "Outcome"} ?? VCTransactionModel(type: .income, amount: 0, date: ""), cardAmount: firebaseDBManager.cardAmount)
                        
                        Spacer()
                        
                        VCDetailsView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: .constant(.all), transactions: firebaseDBManager.transactions ?? [])
                        
                        Spacer()
                        
                        VCDailyRewardView(rewardsState: firebaseDBManager.rewardState, rewardModel: firebaseDBManager.rewardModel, isShowCardAfterTime: firebaseDBManager.isShowCardAfterTime, isDataFetched: firebaseDBManager.isDataFetched)
                        
                    }
                    .alert(isPresented: $errorHandling) {
                        Alert(title: Text("atte"), message: Text("error"), dismissButton: .cancel(Text("OK")))
                    }
                    .padding()
                }
                
            }
            .fullScreenCover(isPresented: $isPresentingTransactionsView, onDismiss: {
                chosenType = .all
            }) {
                VCAllTransactionsView(isPresenting: $isPresentingTransactionsView, chosenType: $chosenType, transactions: firebaseDBManager.transactions ?? [])
            }
            .refreshable {
                firebaseDBManager.fetchData()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


struct VCHomeView_Previews: PreviewProvider {
    static var previews: some View {
        VCHomeView()
    }
}
