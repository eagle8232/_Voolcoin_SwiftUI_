//
//  Home.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 03.05.23.
//

import SwiftUI

struct VCHomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isPresentingTransactionsView: Bool = false
    @State var chosenType: TransactionType = .all
    @State var cardAmount: Double = 0.0
    
    @FetchRequest(entity: VoolcoinModel.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    var transactions: FetchedResults<VoolcoinModel>
    
    var body: some View {
        NavigationView {
            ZStack {
                VCLinearGradientView()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        HStack(spacing: 15) {
                            NavigationLink(destination: VCProfileView()) {
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
                                
                                Text("Kamran")
                                    .font(.largeTitle.bold())
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
                        
                        VCCardView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: $chosenType, cardAmount: cardAmount, lastIncome: transactions.first {$0.type == "Income"}?.amount ?? 0, lastOutcome: transactions.first {$0.type == "Outcome"}?.amount ?? 0)
                        
                        Spacer()
                        
                        VCDetailsView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: .constant(.all))
                        
                        Spacer()
                        
                        VCDailyRewardView()
                        
                    }
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $isPresentingTransactionsView, onDismiss: {
                chosenType = .all
            }) {
                VCTransactionVieww(isPresenting: $isPresentingTransactionsView, chosenType: $chosenType)
            }
            .onDisappear {
                cardAmount = 0
                print("on dissapear")
            }
            .onAppear {
                for i in 0..<transactions.count {
                    cardAmount += transactions[i].amount
                }
                print("on appear")
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
