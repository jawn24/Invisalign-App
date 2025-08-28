import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

struct ProductsView: View {
    let products: [Product] = [
        Product(name: "Cleaning Crystals", url: URL(string: "https://www.amazon.com/dp/B00G9TZ5NM")!),
        Product(name: "Removal Tool", url: URL(string: "https://www.amazon.com/dp/B07R8JMLQG")!)
    ]
    
    var body: some View {
        NavigationView {
            List(products) { product in
                Link(destination: product.url) {
                    Text(product.name)
                }
            }
            .navigationTitle("Products")
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
