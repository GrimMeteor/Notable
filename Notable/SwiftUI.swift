import SwiftUI

struct Item: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
}

class DataViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    init() {
        loadJSON()
    }
    
    func loadJSON() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedItems = try JSONDecoder().decode([Item].self, from: data)
            DispatchQueue.main.async {
                self.items = decodedItems
            }
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = DataViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.items) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                }
                .padding()
            }
            .navigationTitle("JSON Data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
