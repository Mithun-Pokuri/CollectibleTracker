import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \\CollectibleItem.createdAt, ascending: false)],
        animation: .default)
    private var items: FetchedResults<CollectibleItem>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack(alignment: .top) {
                        if let data = item.photo, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading) {
                            Text(item.name ?? "Untitled")
                                .font(.headline)
                            Text(item.brand ?? "")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("My Collection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddItemView()) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
}