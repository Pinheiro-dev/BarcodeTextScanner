//
//  ContentView.swift
//  BarcodeTextScanner
//
//  Created by Matheus Pinheiro on 04/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        switch vm.dataScannerAcessStatus {
            case .scannerAvailable:
                mainView
            case .cameraNotAvailable:
                Text("Yout device doesn't have a camera")
            case .scannerNotAvailable:
                Text("Yout device doesn't have support for scannig barcode with this app")
            case .cameraAccessNotGranted:
                Text("Please provide access to the camera in settings")
            case .notDetermined:
                Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems
        )
    }
}

#Preview {
    ContentView()
}
