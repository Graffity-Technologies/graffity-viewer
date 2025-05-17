//
//  QRCodeScannerViewController.swift
//  Graffity Viewer
//
//  Created by Thaworn Kangwansinghanat on 17/5/2568 BE.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let prefixUrl = "https://viewer.graffity.app/id"
    
    // Callback for when QR code is scanned
    var onQRCodeScanned: ((String) -> Void)?
    
    // For styling
    private let scanWindow = UIView()
    private let errorLabel = UILabel()
    private var errorMessage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupScanWindow()
        setupErrorLabel()
        setupBackButton()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    private func setupScanWindow() {
        // Create a centered scan window
        scanWindow.translatesAutoresizingMaskIntoConstraints = false
        scanWindow.layer.borderColor = UIColor.white.cgColor
        scanWindow.layer.borderWidth = 2.0
        scanWindow.layer.cornerRadius = 16.0
        scanWindow.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
        view.addSubview(scanWindow)
        
        NSLayoutConstraint.activate([
            scanWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanWindow.widthAnchor.constraint(equalToConstant: 300),
            scanWindow.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupErrorLabel() {
        // Setup the error/info label at the bottom
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.text = errorMessage ?? "Scan QR Code from a project page in Graffity Console"
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.87)
        
        view.addSubview(containerView)
        containerView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            errorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 48),
            errorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -48),
            errorLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func setupBackButton() {
        // Add a back button
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: configuration), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showError("Camera not available")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showError("Could not initialize camera")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showError("Could not add video input")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showError("Could not add metadata output")
            return
        }
        
        // Setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        
        // Add a semi-transparent overlay to darken the screen except for the scan window
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.insertSubview(overlayView, at: 1)
        
        // Start the capture session in a background thread
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        
        // Calculate the rect of interest to focus on the scan window
        DispatchQueue.main.async {
            // Convert scan window frame to coordinates in the capture video
            if let previewLayer = self.previewLayer {
                // Adjust metadataOutput's rectOfInterest to match the scanWindow
                let scanWindowRect = self.view.convert(self.scanWindow.frame, to: self.view)
                let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanWindowRect)
                metadataOutput.rectOfInterest = rectOfInterest
            }
        }
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.errorLabel.text = message
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Make sure we only process the QR code once
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if stringValue.hasPrefix(prefixUrl) {
                // Extract token value from URL query parameters
                do {
                    if let url = URL(string: stringValue), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                        if let tokenValue = components.queryItems?.first(where: { $0.name == "token" })?.value {
                            // Pass the token back with Bearer prefix
                            onQRCodeScanned?("Bearer \(tokenValue)")
                            dismiss(animated: true)
                            return
                        }
                    }
                    
                    // If we couldn't extract a token, show error
                    showError("Invalid QR Code. Please scan QR Code from a project page in Graffity Console")
                }
            } else {
                showError("Invalid QR Code. Please scan QR Code from a project page in Graffity Console")
            }
        }
        
        // Restart scanning after delay if we didn't process a successful code
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            if !self.isBeingDismissed {
                self.captureSession.startRunning()
            }
        }
    }
}
