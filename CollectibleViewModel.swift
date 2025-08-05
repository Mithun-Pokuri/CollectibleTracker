import Foundation
import SwiftUI
import CoreData

class CollectibleViewModel: ObservableObject {
    @Published var name = ""
    @Published var brand = ""
    @Published var year: Int = Calendar.current.component(.year, from: Date())
    @Published var color = ""
    @Published var type = "diecastCar"
    @Published var notes = ""
    @Published var photo: UIImage?

    func save(context: NSManagedObjectContext) {
        let newItem = CollectibleItem(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.brand = brand
        newItem.year = Int16(year)
        newItem.color = color
        newItem.type = type
        newItem.notes = notes
        newItem.createdAt = Date()

        if let imageData = photo?.jpegData(compressionQuality: 0.8) {
            newItem.photo = imageData
        }

        do {
            try context.save()
        } catch {
            print("❌ Failed to save item: \(error.localizedDescription)")
        }
    }
}