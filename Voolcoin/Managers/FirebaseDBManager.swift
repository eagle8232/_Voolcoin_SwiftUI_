//
//  FirebaseDBManager.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/4/23.
//

import Foundation

class FirebaseDBManager: ObservableObject {
    @Published var transactions: [VCTransactionModel]?
    @Published var userModel: VCUserModel?
    @Published var rewardModel: VCRewardModel?
    
    @Published var cardAmount: Double = 0.0
    @Published var errorHandling: Bool = false
    
    @Published var isDataFetched: Bool = false
    @Published var isShowCardAfterTime: Bool = false
    
    let dataGroup = DispatchGroup()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        dataGroup.enter()
        DatabaseViewModel().fetchTransactions { transactions, success in
            defer { self.dataGroup.leave() }
            if let transactions {
                self.transactions = transactions
                self.errorHandling = !success
            } else {
                
            }
        }
        
        dataGroup.enter()
        DatabaseViewModel().fetchUserData { userModel, success in
            defer { self.dataGroup.leave() }
            if let userModel {
                self.userModel = userModel
                self.errorHandling = !success
            } else {
                // Handle error
            }
        }
        
        dataGroup.enter()
        DatabaseViewModel().fetchDailyRewards { rewardModel, success in
            defer { self.dataGroup.leave() }
            if let rewardModel = rewardModel {
                self.rewardModel = rewardModel
                self.errorHandling = !success
            } else {
                // Handle error
            }
        }
        
        dataGroup.notify(queue: .main) {
            self.calculateCardAmount()
            self.calculateDailyRewardsCardTime()
            self.isDataFetched = true
        }
    }
    
    func calculateCardAmount() {
        cardAmount = transactions?.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    func calculateDailyRewardsCardTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatKey.wholeFormat.rawValue
        let date = dateFormatter.date(from: rewardModel?.rewardedDate ?? "")
        
        if timeDifference(date1: Date(), date2: date ?? Date()) {
            isShowCardAfterTime = true
            
            rewardModel = VCDailyRewardsViewModel().saveDefaultRewardInfo()
            UserDefaults.standard.removeObject(forKey: "lastReward")
        }
        
        
        
    }
    
    
    func timeDifference(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)
        
        if let minutes = components.minute {
            return abs(minutes) >= 5
        }
        
        return false
    }
}
