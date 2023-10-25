//
//  ContentView.swift
//  PocketTracker
//
//  Created by macbook pro on 25/10/23.
//

import SwiftUI
import CoreData


struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expenses>
    
    @State private var showingAddView = false
    
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("$\(String(format: "%.2f",totalExpensesToday())) USD").foregroundColor(.gray)
                    .padding(.horizontal)
                List{
                    ForEach(expenses) { expenses in
                        NavigationLink(destination: EditExpensesView(expenses: expenses)) {
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(expenses.nombre!)")
                                        .bold()
                                    Text("$\(String(format: "%.2f", expenses.gastos)) USD").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date:expenses.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Gastos")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("add food", systemImage: "plus.circle")
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
    private func totalExpensesToday() -> Double {
        
        var expensesToday : Double = 0
        for item in expenses{
            if Calendar.current.isDateInToday(item.date!){
                expensesToday += item.gastos
            }
        }
        return expensesToday
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation{
            offsets.map { expenses[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context:managedObjContext)
        }
    }
}

#Preview {
    ContentView()
}
