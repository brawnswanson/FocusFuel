import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(ContextManager.self) var contextManager
    
    var body: some View {
        TabView {
            Tab("Tasks", systemImage: "checkmark.square") {
                TaskListView(viewModel: TaskListViewModel(context: contextManager.context))
            }
            Tab("Store", systemImage: "basket") {
                StoreView(viewModel: StoreViewModel(context: contextManager.context))
            }
            Tab("App Lock", systemImage: "lock.shield") {
                AppLockView()
            }
        }
        .tint(Color.Ember.accentDefault)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .modelContainer(for: [FuelTask.self, FuelBalance.self], inMemory: true)
}
