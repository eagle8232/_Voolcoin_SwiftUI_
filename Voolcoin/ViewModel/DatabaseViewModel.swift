//
//  SaveDataViewModel.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/26/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseViewModel {
    
    let db = Firestore.firestore()

    //MARK: - Save & Fetch Transactions -
    
    func saveTransactionsToFirestore(userId: String, transaction: VCTransactionModel) {
        let transactionRef = db.collection("transactions").document(userId)
        
        let transactionArray = [
            [
                "amount": transaction.amount,
                "type": transaction.type.rawValue,
                "date": transaction.date
            ] as [String: Any]
        ]
        
        transactionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update the data
                transactionRef.updateData([
                    "entries": FieldValue.arrayUnion(transactionArray)
                ]) { error in
                    if let error = error {
                        print("Error updating transaction info in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Transaction info updated successfully.")
                    }
                }
            } else {
                // Document doesn't exist, set the data for the first time
                transactionRef.setData([
                    "entries": transactionArray
                ]) { error in
                    if let error = error {
                        print("Error saving transaction info to Firestore: \(error.localizedDescription)")
                    } else {
                        print("Transaction info saved successfully.")
                    }
                }
            }
        }
    }
    
    func fetchTransactionsFromFirestore(userId: String, completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        let transactionRef = db.collection("transactions").document(userId)
        
        transactionRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let entries = data["entries"] as? [[String: Any]] {
                    completion(entries, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
}

extension DatabaseViewModel {
    
    //MARK: - Save & Fetch User Data -
    
    func saveUserModelToFirestore(userId: String, userModel: VCUserModel? = nil, completion: @escaping ((Bool, Error?) -> Void)){
        let userRef = db.collection("user").document(userId)
        
        if let userModel = userModel {
            let user = ["name": userModel.name] as [String: Any]
            
            userRef.updateData(user) { error in
                if let error = error {
                    print("Error updating userModel info in Firestore: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    print("UserModel info updated successfully.")
                    completion(true, nil)
                }
            }
        } else {
            let userModel = makeName()
            
            checkUsernameIfExists(username: userModel.name) { exists in
                guard let exists = exists else {return}
                
                if exists {
                    completion(false, nil)
                } else {
                    let user = ["name": userModel.name] as [String: Any]
                    userRef.setData(user) {error in
                        if let error = error {
                            print("Error updating userModel info in Firestore: \(error.localizedDescription)")
                            completion(true, error)
                        } else {
                            print("UserModel info set successfully.")
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserModel(userId: String, completion: @escaping ((([String: Any])?, Error?) -> Void)) {
        let userRef = db.collection("user").document(userId)
        
        userRef.getDocument { document, error in
            if error == nil, let document = document, document.exists {
                
                if let data = document.data() {
                    completion(data, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}


extension DatabaseViewModel {
    
    //MARK: - Check usernames -
    
    func makeName() -> VCUserModel {
        guard let name = Auth.auth().currentUser?.displayName else {return VCUserModel(name: "", email: "")}
        guard let email = Auth.auth().currentUser?.email else {return VCUserModel(name: "", email: "")}
        
        let userModel = VCUserModel(name: name, email: email)
        return userModel
    }

    //Checks if username exists in database
    
    func checkUsernameIfExists(username: String, completion: @escaping ((Bool?) -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        //username = zevs1418 & userModel["username"] = zevs1418 --- Example
        
        fetchUserModel(userId: userId) { userModel, error in
            if let userModel = userModel, error == nil {
                if username == userModel["name"] as! String {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print(error?.localizedDescription)
                completion(false)
            }
        }
    }
}

extension DatabaseViewModel {
    
    //MARK: - Save & fetch daily rewards info -
    
    func saveDailyRewardsInfoToFirestore(userId: String, dailyRewardsModel: VCRewardModel) {
        let dailyRewardsInfoRef = db.collection("dailyRewardsInfo").document(userId)
        print(dailyRewardsModel)
        let dailyRewardsInfo = [
            "watchedCards": dailyRewardsModel.watchedCards,
            "rewardAmountCards": dailyRewardsModel.rewardAmount,
            "rewardedDate": dailyRewardsModel.rewardedDate,
            "watchedAmount": dailyRewardsModel.watchedAmount
        ] as [String : Any]
        
        dailyRewardsInfoRef.getDocument { document, error in
            if let document = document, document.exists, error == nil {
                dailyRewardsInfoRef.updateData(dailyRewardsInfo) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Succeeded")
                    }
                }
            } else {
                dailyRewardsInfoRef.setData(dailyRewardsInfo) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Succeeded")
                    }
                }
            }
        }
    }
    
    func fetchDailyRewardsInfo(userId: String, completion: @escaping (([String: Any])?, Error?) -> Void) {
        let dailyRewardsInfoRef = db.collection("dailyRewardsInfo").document(userId)
        
        dailyRewardsInfoRef.getDocument { document, error in
            if let document = document, document.exists, error == nil {
                if let data = document.data() {
                    print(data)
                    completion(data, nil)
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
    }
    
}

//MARK: - Fetching data from Firebase with Models

extension DatabaseViewModel {
    
    //Fetching transactions
    func fetchTransactions(completion: @escaping (([VCTransactionModel]?, Bool) -> Void)) {
        var transactions: [VCTransactionModel] = []
        if let userId = Auth.auth().currentUser?.uid {
            print(userId)
            DatabaseViewModel().fetchTransactionsFromFirestore(userId: userId) { entries, error in
                if let entries = entries, error == nil {
                    for entry in entries {
                        let transaction = VCTransactionModel(type: TransactionType(rawValue: entry["type"] as? String ?? "Income") ?? .income, amount: entry["amount"] as? Double ?? 0.0, date: entry["date"] as? String ?? "")
                        transactions.append(transaction)
                    }
                    completion(transactions, true)
                    print(transactions)
                } else {
                    print("erroooooooooorrr in loading")
                    completion(nil, false)
                }
            }
        }
    }
    
    //Fetching user data
    func fetchUserData(completion: @escaping ((VCUserModel?, Bool) -> Void)) {
        var userModel: VCUserModel?
        
        if let userId = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
            DatabaseViewModel().fetchUserModel(userId: userId) { user, error in
                if let user = user, error == nil {
                    userModel = VCUserModel(name: user["name"] as! String, email: email)
                    completion(userModel, true)
                } else if let error = error {
                    print(error)
                    print("erroooooooooorrr in loading")
                    completion(nil, false)
                }
            }
        }
    }
    
    //Fetching daily rewards
    func fetchDailyRewards(completion: @escaping ((VCRewardModel?, Bool) -> Void)){
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        DatabaseViewModel().fetchDailyRewardsInfo(userId: userId) { data, error in
            if let data = data, error == nil {
                
                guard let rewardAmountCards = data["rewardAmountCards"] as? [String: Double],
                      let watchedCards = data["watchedCards"] as? [String: Bool],
                      let watchedAmount = data["watchedAmount"] as? Int,
                      let rewardedDate = data["rewardedDate"] as? String else {return}
                
                let rewardModel = VCRewardModel(watchedCards: watchedCards, rewardAmount: rewardAmountCards, watchedAmount: watchedAmount, rewardedDate: rewardedDate)
                
                completion(rewardModel, true)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, false)
            }
        }
    }
    
}
