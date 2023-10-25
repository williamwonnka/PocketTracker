//
//  EditFoodView.swift
//  Parcial3Avanzadas
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI

struct EditExpensesView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismm
    
    var expenses : FetchedResults<Expenses>.Element
    @State private var name = ""
    @State private var gastos = ""
    
    var body: some View {
        
        Form {
            Section {
                TextField("\(expenses.nombre!)", text: $name)
                    .onAppear{
                        name = expenses.nombre!
                        gastos = String(expenses.gastos)
                    }
                VStack{
                    TextField("Monto del gasto:", text: $gastos)
                }
                .padding()
                
                HStack{
                    Spacer()
                    Button("Submit") {
                        DataController().editGastos(expense: expenses, name: name, gastos: Double(gastos)!, context: managedObjContext)
                        dismm()
                    }
                    Spacer()
                }
            }
        }
    }
}
