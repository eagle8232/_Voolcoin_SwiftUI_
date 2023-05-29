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
        
        let transactionArray = [["amount": transaction.amount, "type": transaction.type.rawValue, "date": transaction.date] as [String: Any]]
        
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
    
    func saveDailyRewardsInfoToFirestore(userId: String, dailyRewardsModel: RewardModel) {
        let dailyRewardsInfoRef = db.collection("dailyRewardsInfo").document(userId)
        let dailyRewardsInfo = ["watchedCards": dailyRewardsModel.watchedCards, "rewardAmountCards": dailyRewardsModel.rewardAmount, "rewardedDate": dailyRewardsModel.rewardedDate, "watchedAmount": dailyRewardsModel.watchedAmount] as [String : Any]
        
        dailyRewardsInfoRef.getDocument { document, error in
            if let document = document, document.exists, error == nil {
                dailyRewardsInfoRef.updateData(dailyRewardsInfo)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func fetchDailyRewardsInfo() {
        
    }
    
}
