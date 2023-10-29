//
//  ContentView.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI
import CoreData
import UIKit


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expenses>
    
    @State public var showingAddView = false
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    VStack{
                        Text("Desde:")
                        DatePicker("Seleccione una fecha", selection: Binding(get: {
                            selectedStartDate ?? expenses.last?.date ?? Date()
                        }, set: { newValue in
                            selectedStartDate = newValue
                        }), in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                    }
                   
                    VStack {
                        Text("Hasta:")
                        DatePicker("Seleccione una fecha", selection: Binding(get: {
                            selectedEndDate ?? Date()
                        }, set: { newValue in
                            selectedEndDate = newValue
                        }), in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                    }
                    Spacer()
                    
                }
                .padding()
                
                Text("$\(String(format: "%.2f", totalExpenses())) USD").foregroundColor(.gray)
                    .padding(.horizontal)
                
                List {
                    ForEach(expenses) { expense in
                        if isExpenseWithinSelectedRange(expense.date) {
                            NavigationLink(destination: EditExpensesView(expenses: expense)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(expense.nombre!)").bold()
                                        Text("$\(String(format: "%.2f", expense.gastos)) USD").foregroundColor(.red)
                                    }
                                    Spacer()
                                    Text(calcTimeSince(date: expense.date!))
                                        .foregroundColor(.gray)
                                        .italic()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Gastos")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Agregar", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddExpensesView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func isExpenseWithinSelectedRange(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        if let startDate = selectedStartDate, let endDate = selectedEndDate {
            return date >= startDate && date <= endDate
        }
        return true
    }
    
    private func totalExpenses() -> Double {
        return expenses.filter { isExpenseWithinSelectedRange($0.date) }.reduce(0) { $0 + $1.gastos }
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}


#Preview {
    ContentView()
}
