//
//  BarcodeTextScannerApp.swift
//  BarcodeTextScanner
//
//  Created by Matheus Pinheiro on 04/04/24.
//

import SwiftUI

@main
struct BarcodeTextScannerApp: App {
    
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
