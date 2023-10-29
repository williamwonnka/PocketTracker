//
//  Resumen.swift
//  PocketTracker
//
//  Created by Martin Sanabria on 25/10/23.
//

import SwiftUI

struct Resumen: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var moneys: FetchedResults<Money>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expenses>
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Seleccionar fecha", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle()) //
                VStack  {
                    Text("Total Gastos")
                    Text("$\(String(format: "%.2f",totalExpensesToday())) USD").foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    List {
                       ForEach(expenses) { expense in
                           if Calendar.current.isDate(expense.date!, inSameDayAs: selectedDate) {
                               NavigationLink(destination: EditExpensesView(expenses: expense)) {
                                   HStack{
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
                   }
                   .listStyle(.plain)
                }
                
                VStack {
                    HStack {
                        VStack  {
                            Text("Total fondos")
                            Text("$\(String(format: "%.2f",totalMoneyDay())) USD").foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        VStack {
                            Text("Fondos reales")
                            Text("$\(String(format: "%.2f", (totalMoneyDay() - totalExpensesToday()))) USD")
                                .foregroundColor(totalMoneyTodayColor())
                        }
                        
                    }
                    .padding()
                    
                    List {
                        ForEach(moneys) { money in
                            if Calendar.current.isDate(money.date!, inSameDayAs: selectedDate) {
                                NavigationLink(destination: EditMoneyView(moneys: money)) {
                                    HStack{
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
                    }
                    .listStyle(.plain)
                }
                
            }
            .padding()
        }
    }
    
    
    private func totalMoneyTodayColor() -> Color {
            let realFunds = totalMoneyDay() - totalExpensesToday()
            return realFunds < 0 ? .red : .green
    }
    
    private func totalMoneyDay() -> Double {
        
        var moneyDay : Double = 0
        for item in moneys{
            if Calendar.current.isDate(item.date!, inSameDayAs: selectedDate) {
                moneyDay += item.saldo
            }
        }
        return moneyDay
    }
    
    
    private func totalExpensesToday() -> Double {
        
        var expensesToday : Double = 0
        for item in expenses{
            if Calendar.current.isDate(item.date!, inSameDayAs: selectedDate) {
                expensesToday += item.gastos
            }
        }
        return expensesToday
    }
}

#Preview {
    Resumen()
}
