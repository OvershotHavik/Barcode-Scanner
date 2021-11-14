//
//  BarcodeScannerView.swift
//  Barcode Scanner
//
//  Created by Steve Plavetzky on 11/13/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                              message: "Something is wrong with the camera. We are unable to capture the input.", dismissButton: .default(Text("OK")))
    static let invalidScannedType = AlertItem(title: "Invalid Scanned Type",
                                              message: "The value scanned is not valid. This app scans EAN-8 and EAN-13 barcodes.", dismissButton: .default(Text("OK")))
}


struct BarcodeScannerView: View {
    @State private var scannedCode = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView{
            VStack{
                ScannerView(scannedCode: $scannedCode, alertItem: $alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Spacer()
                    .frame(height: 60)
                
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scannedCode.isEmpty ? "Not yet scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red : .green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $alertItem) { alertItem in
                Alert(title: Text(alertItem.title),
                      message: Text(alertItem.message),
                      dismissButton: alertItem.dismissButton)
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
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
