//
//  VoolcoinManager.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 11.05.23.
//

import Foundation
import CoreData

class VoolcoinManager: NSObject, ObservableObject {
    
    @Published var transactionItems: [VoolcoinModel] = [VoolcoinModel]()
    
    let container: NSPersistentContainer = NSPersistentContainer(name: "VoolcoinModel")
    
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in
            
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addTransaction(type: TransactionType, amount: Double, date: Date, context: NSManagedObjectContext) {
        let transaction = VoolcoinModel(context: context)
        transaction.type = type.rawValue
        transaction.amount = amount
        transaction.date = date
        
        save(context: context)
    }
    
}
