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
    
    func saveTransactionsToFirestore(userId: String, transaction: VCTransactionModel) {
        db.collection("transactions").document(userId).setData([
            "amount": transaction.amount,
            "type": transaction.type.rawValue,
            "date": transaction.date
        ]) { error in
            if let error = error {
                print("Error saving transaction info to Firestore: \(error.localizedDescription)")
                
            } else {
                
            }
        }
    }
    
    func fetchTransactions(userId: String, completion: @escaping (([VCTransactionModel]?) -> Void)) {
        db.collection("transactions").document(userId).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let document = document {
                let amounts = document.get("amount") as? [Double] ?? []
                let types = document.get("type") as? [String] ?? []
                let dates = document.get("date") as? [Date] ?? []
                
                var transactions: [VCTransactionModel]?
                for index in 0..<types.count {
                    let transaction = VCTransactionModel(type: types[index] == "Income" ? .income : .outcome, amount: amounts[index], date: dates[index])
                    transactions?.append(transaction)
                }
                completion(transactions)
                
            }
        }
    }
}
