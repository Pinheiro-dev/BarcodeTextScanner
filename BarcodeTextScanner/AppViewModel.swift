//
//  AppViewModel.swift
//  BarcodeTextScanner
//
//  Created by Matheus Pinheiro on 04/04/24.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

enum ScanType: String {
    case barcode, text
}

enum DataScannerAcessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAcessStatus: DataScannerAcessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recognizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)"
        } else {
            return "Recognized \(recognizedItems.count) item(s)"
        }
    }
    
    var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        
        return hasher.finalize()
    }
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAcessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                dataScannerAcessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
                
            case .restricted, .denied:
                dataScannerAcessStatus = .cameraAccessNotGranted
            
            case .notDetermined:
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted {
                    dataScannerAcessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
                } else {
                    dataScannerAcessStatus = .cameraAccessNotGranted
                }
                
            default:
                break
        }
        
    }
}
