//
//  VCDetailsView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/4/23.
//

import SwiftUI

struct VCDetailsView: View {
    
    @Binding var isPresentingTransactionsView: Bool
    @Binding var chosenType: TransactionType
    @Binding var transactions: [VCTransactionModel]
    
    var maxNumberOfTransactionShown: Int = 0
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack {
                    Text("Transactions")
                        .font(.title2.bold())
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                        .foregroundColor(.white)
                    
                    Button {
                        isPresentingTransactionsView = true
                        chosenType = .all
                    } label: {
                        Text("See all")
                            .font(.system(size: 15, weight: .medium, design: .default))
                            .opacity(0.7)
                            .padding(.bottom)
                            .foregroundColor(.green)
                    }
                }
                
                VStack {
                    ForEach(Array(transactions.enumerated()), id: \.1.date) { (index, transactionModel) in
                        if index < 3 {
                            VCTransactionView(chosenType: $chosenType, transaction: transactions[transactions.count - index - 1])
                        }
                    }

                }
                
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            
            
        }
    }
}

struct VCDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VCDetailsView(isPresentingTransactionsView: .constant(true), chosenType: .constant(.all), transactions: .constant([VCTransactionModel(type: .income, amount: 0.0, date: "")]))
    }
}
