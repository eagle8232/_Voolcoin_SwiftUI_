//
//  VCTransactionVieww.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import SwiftUI
import Charts
import FirebaseAuth

struct VCTransactionVieww: View {
    
    @Binding var isPresenting: Bool
    @State var currentTime = Date()
    @Binding var chosenType: TransactionType
    
    @State var amount: Double?
    @State var date: Date?
    @State var type: TransactionType = .income
    
    @State private var currentDate = Date()
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var transaction: VoolcoinModel
    
    @FetchRequest(entity: VoolcoinModel.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)])
    var transactions: FetchedResults<VoolcoinModel>
    
    
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
                        ForEach(transactions) { transactionModel in
                            if isSameDay(currentDate: currentDate, rewardedDate: transactionModel.date ?? Date()) {
                                VCTransactionView(chosenType: $chosenType)
                                    .environmentObject(transactionModel)
                            }
                        }
                        .ignoresSafeArea()
                    }
                    
                    .padding(.bottom, 30)
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
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    DatabaseViewModel().fetchTransactions(userId: userId) { transactions in
                        print(transactions)
                    }
                }
            }
            
        }
        
    }
    
    func isSameDay(currentDate: Date, rewardedDate: Date) -> Bool {
        let calendar = Calendar.current
        
        let components1 = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let components2 = calendar.dateComponents([.day, .month, .year], from: rewardedDate)
        
        return components1.day == components2.day
    }
}

struct VCTransactionVieww_Previews: PreviewProvider {
    static var previews: some View {
        VCTransactionVieww(isPresenting: .constant(true), chosenType: .constant(.all))
    }
}
