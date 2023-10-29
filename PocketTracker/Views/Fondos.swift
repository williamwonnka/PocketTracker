//
//  Fondos.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import SwiftUI

struct Fondos: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var moneys: FetchedResults<Money>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expenses>
    
    @State private var showingAddView = false
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    VStack {
                        Text("Desde:")
                        DatePicker("Seleccione una fecha", selection: Binding(get: {
                            selectedStartDate ?? moneys.last?.date ?? Date()
                        }, set: { newValue in
                            selectedStartDate = newValue
                        }), in: ...Date(), displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                    }
                    
                    VStack{
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
                
                HStack {
                    VStack {
                        Text("Total fondos")
                        Text("$\(String(format: "%.2f", totalMoney())) USD").foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Fondos reales")
                        Text("$\(String(format: "%.2f", (totalMoney() - totalExpenses()))) USD")
                            .foregroundColor(totalMoneyColor())
                    }
                }
                .padding()
                
                List {
                    ForEach(moneys) { money in
                        if isMoneyWithinSelectedRange(money.date) {
                            NavigationLink(destination: EditMoneyView(moneys: money)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("$\(String(format: "%.2f", money.saldo)) USD").foregroundColor(.green)
                                    }
                                    Spacer()
                                    Text(calcTimeSince(date: money.date!))
                                        .foregroundColor(.gray)
                                        .italic()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteMoney)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Fondos")
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
                AddMoneyView(isPresented: $showingAddView)
            }
        }
    }
    
    private func isMoneyWithinSelectedRange(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        if let startDate = selectedStartDate, let endDate = selectedEndDate {
            return date >= startDate && date <= endDate
        }
        return true
    }
    
    private func totalMoney() -> Double {
        return moneys.filter { isMoneyWithinSelectedRange($0.date) }.reduce(0) { $0 + $1.saldo }
    }
    
    private func deleteMoney(offsets: IndexSet) {
        withAnimation {
            offsets.map { moneys[$0] }.forEach(managedObjContext.delete)
            MoneyController().save(context: managedObjContext)
        }
    }
    
    private func totalExpenses() -> Double {
        return expenses.filter { isMoneyWithinSelectedRange($0.date) }.reduce(0) { $0 + $1.gastos }
    }
    
    private func totalMoneyColor() -> Color {
        let realFunds = totalMoney() - totalExpenses()
        return realFunds < 0 ? .red : .green
    }
}


#Preview {
    Fondos()
}
