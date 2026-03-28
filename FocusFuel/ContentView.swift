import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var fuelManager: FuelManager
    @Environment(\.modelContext) private var context: ModelContext
    
    var body: some View {
        TabView {
            Tab("Tasks", systemImage: "checkmark.square") {
                TaskListView()
            }
            Tab("Store", systemImage: "basket") {
                StoreView()
            }
            Tab("App Lock", systemImage: "lock.shield") {
                AppLockView()
            }
        }
        .onAppear {
            fuelManager.configure(modelContext: context)
        }
        .tint(Color.Ember.accentDefault)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: [FuelTask.self, FuelBalance.self], inMemory: true)
}
