//
//  Persistence.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 03.05.23.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer

    static let shared = PersistenceController()

    // Convenience
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    static var preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Companies
        let newTransaction = VoolcoinModel(context: viewContext)
        newTransaction.date = Date()

        shared.save(context: viewContext)
        
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "--REPLACEME--") // else UnsafeRawBufferPointer with negative count
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func addTransaction(date: Date, type: String, amount: Double) {

        let voolcoinModel = VoolcoinModel(context: viewContext)

        voolcoinModel.date = Date()
        voolcoinModel.type = type
        voolcoinModel.amount = amount

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
        func save(context: NSManagedObjectContext) {
            do {
                try context.save()
                print("Data saved successfully. WUHU!!!")
            } catch {
                // Handle errors in our database
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    
    // Better save
//    func saveContext() {
//        let context = container.viewContext
//
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                fatalError("Error: \(error.localizedDescription)")
//            }
//        }
//    }
}
