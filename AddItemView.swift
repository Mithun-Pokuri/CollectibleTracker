import SwiftUI
import PhotosUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = CollectibleViewModel()
    @State private var selectedPhoto: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Name", text: $vm.name)
                    TextField("Brand", text: $vm.brand)
                    TextField("Color", text: $vm.color)
                    TextField("Year", value: $vm.year, formatter: NumberFormatter())
                    Picker("Type", selection: $vm.type) {
                        Text("Diecast Car").tag("diecastCar")
                        Text("Book").tag("book")
                        Text("Other").tag("other")
                    }
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $vm.notes)
                        .frame(height: 100)
                }

                Section(header: Text("Photo")) {
                    if let image = vm.photo {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                        Text("Select Photo")
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                vm.photo = image
                            }
                        }
                    }
                }

                Section {
                    Button("Save") {
                        vm.save(context: viewContext)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Item")
        }
    }
}