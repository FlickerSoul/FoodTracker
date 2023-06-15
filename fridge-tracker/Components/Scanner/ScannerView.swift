//
//  ScannerView.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/13/23.
//

import AVFoundation
import SwiftUI
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private let captureSession = AVCaptureSession()
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    var screenGeometry: CGRect! = nil
    
    private var cameraPermission = false
    
    private let requestQueue = DispatchQueue(label: "camera request queue")
    
    private var callbackWhenFound: ((String) -> Void)? = nil
    
    override func viewDidLoad() {
        checkCameraPermission()
        
        requestQueue.async {
            [unowned self] in
            guard cameraPermission else { return }
            self.setupCaptureSession()
        }
    }
    
    private func attachInput(videoDevice: AVCaptureDevice) {
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
    }
    
    private func attachOutput(videoDevice: AVCaptureDevice) {
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .code128]
        }
    }
    
    private func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        
        attachInput(videoDevice: videoDevice)
        attachOutput(videoDevice: videoDevice)
        
        screenGeometry = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenGeometry.width, height: screenGeometry.height)
        previewLayer.videoGravity = .resizeAspectFill
        
        requestQueue.async { [unowned self] in
            self.view.layer.addSublayer(self.previewLayer)
            self.captureSession.startRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(code: stringValue)
        }

        dismiss(animated: true)
    }
    
    private func failed(detail msg: String) {
        let ac = UIAlertController(title: "Scanning not supported", message: "Detail error: \(msg).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func foundCode(code: String) {
        callbackWhenFound?(code)
    }
    
    func registerCallback(of action: @escaping (String) -> Void) -> Self {
        callbackWhenFound = action
        
        return self
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermission = true
        case .notDetermined:
            requestCameraPermission()
        default:
            cameraPermission = false
        }
    }
    
    private func requestCameraPermission() {
        requestQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { permission in
            self.cameraPermission = permission
            self.requestQueue.resume()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            requestQueue.async { [unowned self] in
                self.captureSession.stopRunning()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            requestQueue.async { [unowned self] in
                self.captureSession.startRunning()
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

struct ScannerView: UIViewControllerRepresentable {
    let callback: (String) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ScannerViewController().registerCallback(of: callback)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    NavigationView {
        ScannerView { code in
            print(code)
        }
    }
}
