//
//  SearchBar.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 07.05.2021.
//

import SwiftUI
import Alamofire

// Search bar with auto hide/show
struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>, searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            search()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
}

// Search bar without auto hide/show
//struct SearchBar: View {
//    @EnvironmentObject var stocksData: StocksData
//
//    @Binding var searchText: String
//    @Binding var showCancelButton: Bool
//
//    var body: some View {
//        HStack {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                TextField("Search", text: $searchText,
//                          onCommit: {
//                            print("onCommit")
//                          }
//                )
//                .foregroundColor(.primary)
//                .onTapGesture {
//                    stocksData.stocks.removeAll()
//                    showCancelButton = true
//                }
//                .onChange(of: searchText, perform: { text in
//                            stocksData.getYahooQuote(symbol: text) { quoteParent in
//                                let quoteResponse = quoteParent.quoteResponse
//                                if quoteResponse.error == nil && quoteResponse.result?.first != nil {
//                                    stocksData.stocks = quoteResponse.result ?? []
//                                } else {
//                                    stocksData.stocks = [Stock(symbol: "No results for \"\(searchText)\"")]
//                                }
//                            }
//                })
//                Button(action: {
//                    self.searchText = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
//                }
//            }
//            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//            .foregroundColor(.secondary)
//            .background(Color(.secondarySystemBackground))
//            .cornerRadius(10.0)
//            if showCancelButton {
//                Button("Cancel") {
//                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
//                    self.searchText = ""
//                    self.showCancelButton = false
//                }
//                .foregroundColor(Color(.systemBlue))
//            }
//        }
//        .padding(.horizontal)
//        .navigationBarHidden(showCancelButton)
//    }
//}
//
//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//    }
//}
//
//struct ResignKeyboardOnDragGesture: ViewModifier {
//    var gesture = DragGesture().onChanged{_ in
//        UIApplication.shared.endEditing(true)
//    }
//    func body(content: Content) -> some View {
//        content.gesture(gesture)
//    }
//}
//
//extension View {
//    func resignKeyboardOnDragGesture() -> some View {
//        return modifier(ResignKeyboardOnDragGesture())
//    }
//}
