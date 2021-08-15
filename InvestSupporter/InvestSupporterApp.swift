//
//  InvestSupporterApp.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 07.05.2021.
//

import SwiftUI

@main
struct InvestSupporterApp: App {
    let stock = StocksViewModel()
//    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            InvestDataView(stocksViewModel: stock)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
//        .onChange(of: scenePhase) { (newScenePhase) in
//            switch newScenePhase {
//            case .background:
//                print("Scene is in background")
//                persistenceController.save()
//            case .inactive:
//                print("Scene is inactive")
//            case .active:
//                print("Scene is active")
//            @unknown default:
//                print("Wrong case!")
//            }
//        }
    }
}
