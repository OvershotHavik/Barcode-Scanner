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
    
    /*
     @State private var isShowingAlert = false

     basic alert triggered when the isShowingAlert switches to true, which was triggered by this temporary button:
     Button{
         isShowingAlert = true
     } label: {
         Text("tap me!")
     }
     .alert(isPresented: $isShowingAlert) {
         Alert(title: Text("Test"), message: Text("This is a test"), dismissButton: .default(Text("ok")))
     }
     */
}
