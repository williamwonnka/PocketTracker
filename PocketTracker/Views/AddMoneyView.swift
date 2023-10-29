//
//  AddMoneyView.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import SwiftUI

struct AddMoneyView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var isPresented: Bool  // Agrega este binding
    
    @State private var saldo = ""
    
    var body: some View {
        Form {
            Section(header: Text("Agregar Fondos"))  {
                VStack {
                    TextField("Ingresar Fondos:", text: $saldo)
                    
                    
                }
                
                .padding()
                HStack{
                    Spacer()
                    Button("Agregar"){
                        MoneyController().addFondos(saldoActual: Double(saldo)!, context: managedObjContext)
                        isPresented = false
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AddMoneyView(isPresented: .constant(true))
}
