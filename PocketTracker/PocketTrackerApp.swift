//
//  PocketTrackerApp.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI

@main
struct PocketTrackerApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
