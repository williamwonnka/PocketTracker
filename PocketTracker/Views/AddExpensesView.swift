//
//  AddExpensesView.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI

struct AddExpensesView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismm
    
    @State private var name = ""
    @State private var gastos = ""
    
    
    
    var body: some View {
        Form {
            Section {
                TextField("Nombre del gasto", text: $name)
                VStack {
                    TextField("Monto del gasto:", text: $gastos)
                    
                    
                }
                
                .padding()
                HStack{
                    Spacer()
                    Button("Submit"){
                        DataController().addGastos(name: name, gastos: Double(gastos)!, context: managedObjContext)
                        dismm()
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AddExpensesView()
}
