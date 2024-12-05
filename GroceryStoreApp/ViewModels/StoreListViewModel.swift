//
//  StoreListViewModel.swift
//  GroceryStoreApp
//
//  Created by Flrorian Kasperbauer on 2024-12-05.
//

class StoreListViewModel : ObservableObject {
    
    @Published var storesIDs: [Item] = []
    private let service: ICartConnectionService
    
    init(service: ICartConnectionService) {
        self.service = service
    }
    
    func fetchItems(for storeId: String) async {
        do {
            items = try await service.fetchItems(storeId: storeId)
        } catch {
            print("Error fetching items:", error)
        }
    }
    
}
