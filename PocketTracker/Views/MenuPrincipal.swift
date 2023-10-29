//
//  MenuPrincipal.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import SwiftUI

struct MenuPrincipal: View {
    @State private var selectedView = 0
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedView) {
                    ContentView().tabItem {
                        Text("Gastos")
                        Image(systemName: "cart.fill")
                    }
                    
                    Fondos().tabItem {
                        Text("Fondos")
                        Image(systemName: "creditcard.fill")
                    }
                    
                    Resumen().tabItem {
                        Text("Resumen")
                        Image(systemName: "info.circle")
                    }
                    
                    
                }
                
                
            }
        }
    }
}

#Preview {
    MenuPrincipal()
}
