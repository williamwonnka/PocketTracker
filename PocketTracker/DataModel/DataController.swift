//
//  DataController.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import Foundation
import CoreData


class DataController: ObservableObject {

    
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
    
   
    
    func addGastos(name: String, gastos: Double, context:NSManagedObjectContext){
        let expenses = Expenses(context: context)
        expenses.id = UUID()
        expenses.date = Date()
        expenses.nombre = name
        expenses.gastos = gastos
        
        save(context: context)
    }
    
    func editGastos(expense: Expenses, name: String, gastos: Double, context: NSManagedObjectContext){
        expense.date = Date()
        expense.nombre = name
        expense.gastos = gastos
        
        save(context: context)
    }
}
    
