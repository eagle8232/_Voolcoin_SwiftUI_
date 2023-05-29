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
    @State var chosenType: TransactionType = .all
    @State var cardAmount: Double = 0.0
    
    @State var transactions: [VCTransactionModel] = []
    @State var userModel: VCUserModel?
    
    var body: some View {
        NavigationView {
            ZStack {
                VCLinearGradientView()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        HStack(spacing: 15) {
                            NavigationLink(destination: VCProfileView(userModel: userModel)) {
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
                                
                                Text(userModel?.name ?? "????")
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
                        
                        VCCardView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: $chosenType, cardAmount: cardAmount, lastIncome: transactions.last {$0.type.rawValue == "Income"}?.amount ?? 0, lastOutcome: transactions.last {$0.type.rawValue == "Outcome"}?.amount ?? 0)
                        
                        Spacer()
                        
                        VCDetailsView(isPresentingTransactionsView: $isPresentingTransactionsView, chosenType: .constant(.all), transactions: $transactions)
                        
                        Spacer()
                        
                        VCDailyRewardView()
                        
                    }
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $isPresentingTransactionsView, onDismiss: {
                chosenType = .all
            }) {
                VCTransactionVieww(isPresenting: $isPresentingTransactionsView, chosenType: $chosenType, transactions: $transactions)
            }
            .onDisappear {
                cardAmount = 0
                print("on dissapear")
            }
            .refreshable {
                setData()
            }
            .onAppear {
                for i in 0..<transactions.count {
                    cardAmount += transactions[i].amount
                }
                
                setData()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func fetchTransactions(completion: @escaping (([VCTransactionModel]?) -> Void)) {
        var transactions: [VCTransactionModel] = []
        if let userId = Auth.auth().currentUser?.uid {
            print(userId)
            DatabaseViewModel().fetchTransactionsFromFirestore(userId: userId) { entries, error in
                if let entries = entries, error == nil {
                    for entry in entries {
                        let transaction = VCTransactionModel(type: TransactionType(rawValue: entry["type"] as? String ?? "Income") ?? .income, amount: entry["amount"] as? Double ?? 0.0, date: entry["date"] as? String ?? "")
                        transactions.append(transaction)
                    }
                    completion(transactions)
                    print(transactions)
                }
            }
        }
    }
    
    func fetchUserData(completion: @escaping ((VCUserModel?) -> Void)) {
        var userModel: VCUserModel?
        
        if let userId = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
            DatabaseViewModel().fetchUserModel(userId: userId) { user, error in
                if let user = user, error == nil {
                    userModel = VCUserModel(name: user["name"] as! String, email: email)
                    completion(userModel)
                } else if let error = error {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
    func setData() {
        fetchTransactions { transactions in
            if let transactions {
                self.transactions = transactions
            }
        }
        
        fetchUserData { userModel in
            if let userModel {
                self.userModel = userModel
            }
        }
    }
}


struct VCHomeView_Previews: PreviewProvider {
    static var previews: some View {
        VCHomeView()
    }
}
