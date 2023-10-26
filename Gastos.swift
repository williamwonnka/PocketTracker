//
//  Gastos.swift
//  Proyecto
//
//  Created by Martin Sanabria on 23/10/23.
//

import SwiftUI

struct cash: Identifiable {
    var id = UUID() // Unique identifier for each habit
    var name: String
    var precio: String
    var fecha_gasto: Date
}
struct Gastos: View {
    @State private var nombre = ""
    @State private var precio = ""
    @State private var fecha_gasto = Date()
    @State private var gastos = [cash]()
    var body: some View {
        VStack{
            HStack{
                Form {
                    Section(header: Text("Gastos").font(.title)) {
                        TextField("Nombre del gasto", text: $nombre).keyboardType(.default)
                        TextField("Cantidad de dinero", text: $precio).keyboardType(.numberPad)
                        DatePicker("Fecha del gasto", selection: $fecha_gasto, displayedComponents: [.date])
                                                   .datePickerStyle(.automatic)
                    }
                }
                
            }
            
            Button(action: {
                if !nombre.isEmpty, !precio.isEmpty {
                    let gast = cash(name: nombre, precio: precio, fecha_gasto: fecha_gasto)
                    gastos.append(gast)
                    nombre = ""
                    precio = ""
                }
            }) {
                Text("Agregar").padding().background(Color.blue).foregroundColor(.white).cornerRadius(8)
            }
            
            
            
            List {
                ForEach(gastos) { cash in
                    Text("Gasto: \(cash.name)\n Monto: \(cash.precio)\n Fecha de gasto: \(cash.fecha_gasto)")
                }
            }
            .padding()
        }
    }
}

#Preview {
    Gastos()
}
