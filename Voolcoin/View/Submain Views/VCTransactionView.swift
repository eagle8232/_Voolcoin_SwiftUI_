//
//  VCTransactionView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 04.05.23.
//

import SwiftUI

struct VCTransactionView: View {
    
    @Binding var chosenType: TransactionType
    @EnvironmentObject var transaction: VoolcoinModel
    
    var widthSize: CGFloat = .infinity
    
    @State private var showTransaction: Bool = false
    
    var body: some View {
        if transaction.type! == chosenType.rawValue || chosenType == .all {
            HStack(spacing: 10) {
                Image(systemName: transaction.type == "Income" ? "arrow.down" : "arrow.up")
                    .foregroundColor(transaction.type == "Income" ? Color.green : Color.red)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.7), in: Circle())
                
                VStack(alignment: .leading) {
                    Text(transaction.type == "Income" ? "Income" : "Outcome")
                        .foregroundColor(.white.opacity(0.7))
                        .fontWeight(.medium)
                    Text("\((String(format: "%.1f", transaction.amount) )) voolcoins")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .lineLimit(1)
                        .frame(maxWidth: 120, alignment: .leading)
                        .foregroundColor(transaction.type == "Income" ? Color.green : Color.red)
                }
                
                Text(getDate())
                    .font(.system(size: 14))
                    .fontWeight(.thin)
                    .opacity(0.7)
                    .foregroundColor(.white)
                
            }
            .frame(width: 283, height: 45, alignment: .center)
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .offset(y: showTransaction ? 0 : 50)
            .opacity(showTransaction ? 1 : 0)
            .onAppear {
                withAnimation(.spring()) {
                    showTransaction = true
                }
            }
            .onChange(of: chosenType) { _ in
                showTransaction = false
                withAnimation(.spring()) {
                    showTransaction = true
                }
            }
        }
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, EEEE"
        let date = transaction.date
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
}

struct VCTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VCTransactionView(chosenType: .constant(.income))
    }
}
