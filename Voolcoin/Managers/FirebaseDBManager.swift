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
    
    @Published var rewardState: RewardsState = .unwatched
    
    @Published var cardAmount: Double = 0.0
    @Published var errorHandling: Bool = false
    
    @Published var isDataFetched: Bool = false
    @Published var isShowCardAfterTime: Bool = false
    
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        
        let dataGroup = DispatchGroup()
        let databaseViewModel = DatabaseViewModel()
        
        dataGroup.enter()
        databaseViewModel.fetchTransactions { [weak self] transactions, success in
            defer { dataGroup.leave() }
            DispatchQueue.main.async {
                if let transactions = transactions {
                    self?.transactions = transactions
                    self?.errorHandling = !success
                } else {
                    // New user
                    self?.transactions = []
                    self?.isDataFetched = true
                    print("transactions mode worked")
                }
            }
        }
        
        dataGroup.enter()
        databaseViewModel.fetchUserData { [weak self] userModel, success in
            defer { dataGroup.leave() }
            DispatchQueue.main.async {
                if let userModel = userModel {
                    self?.userModel = userModel
                    self?.errorHandling = !success
                } else {
                    // Handle error
                    self?.isDataFetched = true
                    print("user data mode worked")
                }
            }
        }
        
        
        dataGroup.enter()
        databaseViewModel.fetchDailyRewards { [weak self] rewardModel, success in
            defer { dataGroup.leave() }
            DispatchQueue.main.async {
                if let rewardModel = rewardModel {
                    self?.rewardModel = rewardModel
                    self?.errorHandling = !success
                    print("rewardModel has data")
                } else {
                    // Handle error
                    self?.rewardModel = VCDailyRewardsViewModel().saveDefaultRewardInfo()
                    self?.isDataFetched = true
                    print("saveDefaultRewardInfo")
                }
            }
        }
        
        dataGroup.notify(queue: .main) { [weak self] in
            print("notified")
            self?.calculateCardAmount()
            self?.calculateDailyRewardsCardTime()
            self?.isDataFetched = true
        }
    }

    
    func calculateCardAmount() {
        cardAmount = transactions?.reduce(0) { $0 + $1.amount } ?? 0
    }
    
    func calculateDailyRewardsCardTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatKey.wholeFormat.rawValue
        let date = dateFormatter.date(from: rewardModel?.rewardedDate ?? "")
        
        if timeDifference(date1: Date(), date2: date ?? Date()) && rewardModel?.watchedAmount == 3 {
            isShowCardAfterTime = true
            
            rewardModel = VCDailyRewardsViewModel().saveDefaultRewardInfo()
            UserDefaults.standard.removeObject(forKey: "lastReward")
        }
        
        //Change status of rewardState
        rewardState = (rewardModel?.watchedAmount ?? 0) == 3 ? .watched : .unwatched
    }
    
    
    func timeDifference(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)
        
        if let minutes = components.minute {
//            return abs(minutes) >= 5
            return abs(minutes) >= 1440
        }
        
        return false
    }
    
    func setDefaultValue() {
        self.rewardModel = VCDailyRewardsViewModel().saveDefaultRewardInfo()
        rewardState = .unwatched
        userModel = nil
        rewardModel = nil
        transactions = nil
        cardAmount = 0
    }
}
