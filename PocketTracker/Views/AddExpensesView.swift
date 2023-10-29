//
//  AddExpensesView.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI
import UIKit

struct AddExpensesView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var moneys: FetchedResults<Money>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expenses>
    @Environment(\.dismiss) var dismm
    
    @State private var name = ""
    @State private var gastos = ""
    
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        Form {
            Section(header: Text("Agregar Gasto")) {
                TextField("Nombre del gasto", text: $name)
                VStack {
                    TextField("Monto del gasto:", text: $gastos)
                    
                    
                }
                
                .padding()
                HStack{
                    Spacer()
                    Button("Agregar"){
                        let totalFunds = totalMoneyDay() - totalExpensesToday() - (Double(gastos) ?? 0)
                        if totalFunds >= 0 {
                            DataController().addGastos(name: name, gastos: Double(gastos) ?? 0, context: managedObjContext)
                            dismm()
                        } else {
                            showingAlert = true
                        }
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                           title: Text("Fondos Insuficientes"),
                           message: Text("Agregar este gasto dejará sus fondos en negativo. ¿Desea continuar?"),
                           primaryButton: .destructive(Text("Cancelar")){
                               presentationMode.wrappedValue.dismiss()
                           },
                           secondaryButton: .default(Text("Aceptar")) {
                               DataController().addGastos(name: name, gastos: Double(gastos) ?? 0, context: managedObjContext)
                               dismm()
                           }
                       )
                        
                    }
                    Spacer()
                }
            }
        }
    }
    
    
    private func totalMoneyDay() -> Double {
        
        var moneyDay : Double = 0
        for item in moneys{
            moneyDay += item.saldo
            
        }
        return moneyDay
    }
    
    private func totalExpensesToday() -> Double {
        
        var expensesToday : Double = 0
        for item in expenses{
            expensesToday += item.gastos
        }
        return expensesToday
    }
    
}

#Preview {
    AddExpensesView()
}
