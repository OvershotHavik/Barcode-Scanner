//
//  ScannerVC.swift
//  Barcode Scanner
//
//  Created by Steve Plavetzky on 11/14/21.
//

import Foundation
import AVFoundation
import UIKit

protocol ScannerVCDelegate: AnyObject{
    func didFind(barcode: String)
}


final class ScannerVC: UIViewController{
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return //error
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
                return //error here
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            return // error here
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]

        } else {
            return // error here
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let safePreviewLayer = previewLayer{
            safePreviewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(safePreviewLayer)
        }
        
        captureSession.startRunning()
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            return //error message
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            return //error message
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            return //error message
        }
        
        scannerDelegate?.didFind(barcode: barcode)
    }
}
