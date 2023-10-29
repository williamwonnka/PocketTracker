//
//  MoneyController.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import Foundation
import CoreData

class MoneyController: ObservableObject {
    
    let container = NSPersistentContainer(name: "ExpensesModel")
    
    init(){
        container.loadPersistentStores {
            desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data saved")
            }
            catch {
            print("Data not saved")
            }
        }
    
    func addFondos(saldoActual: Double, context:NSManagedObjectContext){
        let money = Money(context: context)
        money.id = UUID()
        money.saldo = saldoActual
        money.date = Date()
        save(context: context)
    }
    
    func editFondos(money: Money, saldoActual: Double, context: NSManagedObjectContext){
        money.saldo = saldoActual
        save(context: context)
    }
    
    
    
}
