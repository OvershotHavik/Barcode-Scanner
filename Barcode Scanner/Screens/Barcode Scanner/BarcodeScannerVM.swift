//
//  barcodeScannerVM.swift
//  Barcode Scanner
//
//  Created by Steve Plavetzky on 11/14/21.
//

import SwiftUI

final class BarcodeScannerVM: ObservableObject{
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String{
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusTextColor: Color{
        scannedCode.isEmpty ? .red : .green
    }
}
