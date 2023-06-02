//
//  VCTransactionVieww.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import SwiftUI
import Charts
import FirebaseAuth

struct VCAllTransactionsView: View {
    
    @Binding var isPresenting: Bool
    @State var currentTime = Date()
    @Binding var chosenType: TransactionType
    
    @State var amount: Double?
    @State var date: Date?
    @State var type: TransactionType = .income
    
    @State private var currentDate = Date()
    
    @Binding var transactions: [VCTransactionModel]
    
    @State var transactionModels: [VCTransactionModel] = []
    
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                VCLinearGradientView()
                
                VStack {
                    HStack {
                        
                        Button {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate)!
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .overlay {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                        
                        DatePicker("Pick a date", selection: $currentDate, displayedComponents: .date)
                            .labelsHidden()
                    
                    
                        Button {
                            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate)!
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .overlay {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                        
                    }
                    .padding()
                    
                    VCSegmentedControl(chosenType: $chosenType)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(Array(transactions.enumerated()).reversed(), id: \.1.date) { (index, transactionModel) in
                            if isSameDay(currentDateString: currentDate.toString(format: "yyyy-MM-dd HH:mm:ss"), rewardedDateString: transactionModel.date) {
                                VCTransactionView(chosenType: $chosenType, transaction: transactionModel)
                            }
                        }
                        
                    }
                    .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        Button {
                            isPresenting = false
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .overlay {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                        
                    }
                }
                .navigationTitle("Transactions")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
    }
    
    func isSameDay(currentDateString: String, rewardedDateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let currentDate = dateFormatter.date(from: currentDateString) else {return false}
        guard let rewardedDate = dateFormatter.date(from: rewardedDateString) else {return false}
        
        let calendar = Calendar.current
        
        let components1 = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let components2 = calendar.dateComponents([.day, .month, .year], from: rewardedDate)
        
        return components1.day == components2.day
    }
}

struct VCTransactionVieww_Previews: PreviewProvider {
    static var previews: some View {
        VCAllTransactionsView(isPresenting: .constant(true), chosenType: .constant(.all), transactions: .constant([VCTransactionModel(type: .income, amount: 5.43, date: "")]))
    }
}
