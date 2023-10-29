//
//  EditMoneyView.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import Foundation
import SwiftUI


struct EditMoneyView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismm
    
    var moneys : FetchedResults<Money>.Element
    @State private var saldo = ""
    
    var body: some View {
        
        Form {
            Section (header: Text("Editar Fondo")) {
                TextField("\(moneys.saldo)", text: $saldo)
                    .onAppear{
                        saldo = String(moneys.saldo)
                    }
                VStack{
                    TextField("Fondos:", text: $saldo)
                }
                .padding()
                
                HStack{
                    Spacer()
                    Button("Actualizar") {
                        MoneyController().editFondos(money: moneys, saldoActual: Double(saldo)!, context: managedObjContext)
                        dismm()
                    }
                    Spacer()
                }
            }
        }
    }
}
