//
//  ScannerVC.swift
//  Barcode Scanner
//
//  Created by Steve Plavetzky on 11/14/21.
//

import Foundation
import AVFoundation
import UIKit

enum CameraError: String{
    case invalidDeviceInput     = "Something is wrong with the camera. We are unable to capture the input."
    case invalidScannedValue    = "The value scanned is not valid. This app scans EAN-8 and EAN-13 barcodes."
    //In a production environment, each guard let below could have it's own dedicated error, but this gets the point across for this project.
}

protocol ScannerVCDelegate: AnyObject{
    func didFind(barcode: String)
    func didSurface(error: CameraError)
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
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return //error
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
                return //error here
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return // error here
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]

        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
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
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return //error message
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return //error message
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return //error message
        }
        
        scannerDelegate?.didFind(barcode: barcode)
    }
}
