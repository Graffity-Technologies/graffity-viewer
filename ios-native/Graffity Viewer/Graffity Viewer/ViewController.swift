//
//  ViewController.swift
//  Graffity Viewer
//
//  Created by Thaworn Kangwansinghanat on 17/5/2568 BE.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private let prefixToken = "Bearer "
    private let tokenTextField = UITextField()
    private let arModeSelector = UISegmentedControl(items: ["Point Cloud & Image Anchor", "World & Image Anchor", "Face Anchor"])
    private let launchARButton = UIButton()
    private let scanQRButton = UIButton()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let whereToGetTokenButton = UIButton()
    private let cloneFromGithubButton = UIButton()
    private let dividerStackView = UIStackView()
    
    private var latitude: Double?
    private var longitude: Double?
    private var isLoading = false
    
    // URLs for the buttons
    private let docTokenURL = URL(string: "https://developers.graffity.tech/quick-start/graffity-console#create-access-token")
    private let githubCloneURL = URL(string: "https://github.com/Graffity-Technologies/graffity-viewer")
    private let consoleURL = URL(string: "https://console.graffity.tech")
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
        setupActions()
        
        // Setup tap gesture to dismiss keyboard when tapping outside
        setupTapGestureToDismissKeyboard()
        
        // Try to load app clip parameters if available
        checkForAppClipParameters()
    }
    
    private func setupTapGestureToDismissKeyboard() {
        // Add tap gesture recognizer to dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow other tap gestures to work
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        // Setup logo
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "LaunchImage")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup title
        titleLabel.text = "" // AR Viewer
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
        titleLabel.textColor = .label // Dynamic color that adapts to light/dark mode
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openConsoleURL))
        titleLabel.addGestureRecognizer(tapGesture)
        
        // Setup token text field
        tokenTextField.placeholder = "Enter project access token"
        tokenTextField.borderStyle = .roundedRect
        tokenTextField.autocorrectionType = .no
        tokenTextField.autocapitalizationType = .none
        tokenTextField.textColor = .label // Dynamic color that adapts to light/dark mode
        tokenTextField.font = UIFont.systemFont(ofSize: 16) // Set font size to 16
        tokenTextField.returnKeyType = .done // Set return key to "Done"
        tokenTextField.delegate = self // Set delegate to handle keyboard events
        tokenTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup AR mode selector
        arModeSelector.selectedSegmentIndex = 0
        arModeSelector.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup launch AR button
        launchARButton.setTitle("Launch AR", for: .normal)
        launchARButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        launchARButton.backgroundColor = UIColor(red: 25/255, green: 166/255, blue: 182/255, alpha: 1)
        launchARButton.setTitleColor(.white, for: .normal) // Keep white for contrast on colored background
        launchARButton.layer.cornerRadius = 8
        launchARButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup divider
        dividerStackView.axis = .horizontal
        dividerStackView.alignment = .center
        dividerStackView.translatesAutoresizingMaskIntoConstraints = false
        
//        let leftDivider = createDivider()
        let orLabel = UILabel()
        orLabel.text = "OR"
        orLabel.font = UIFont.systemFont(ofSize: 12)
        orLabel.textColor = .secondaryLabel // Dynamic secondary text color
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
//        let rightDivider = createDivider()
        
//        dividerStackView.addArrangedSubview(leftDivider)
        dividerStackView.addArrangedSubview(orLabel)
//        dividerStackView.addArrangedSubview(rightDivider)
//        dividerStackView.setCustomSpacing(16, after: leftDivider)
//        dividerStackView.setCustomSpacing(16, after: orLabel)
        
        // Setup scan QR button
        scanQRButton.setTitle("Scan QR Code", for: .normal)
        scanQRButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        scanQRButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        scanQRButton.tintColor = UIColor(red: 25/255, green: 166/255, blue: 182/255, alpha: 1)
        scanQRButton.setTitleColor(.label, for: .normal) // Dynamic color for text
        scanQRButton.layer.borderWidth = 1
        scanQRButton.layer.borderColor = UIColor.systemGray4.cgColor
        scanQRButton.layer.cornerRadius = 8
        scanQRButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        scanQRButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup "Where to get token?" button
        whereToGetTokenButton.setTitle("Where to get a project access token?", for: .normal)
        whereToGetTokenButton.setTitleColor(.link, for: .normal) // Dynamic link color
        whereToGetTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        whereToGetTokenButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup "Clone from Github" button
        cloneFromGithubButton.setTitle("Clone this app from GitHub", for: .normal)
        cloneFromGithubButton.setTitleColor(.link, for: .normal) // Dynamic link color
        cloneFromGithubButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cloneFromGithubButton.setImage(UIImage(systemName: "code"), for: .normal)
        cloneFromGithubButton.tintColor = .link // Dynamic link color
        cloneFromGithubButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        cloneFromGithubButton.semanticContentAttribute = .forceRightToLeft
        cloneFromGithubButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(tokenTextField)
        view.addSubview(arModeSelector)
        view.addSubview(launchARButton)
        view.addSubview(dividerStackView)
        view.addSubview(scanQRButton)
        view.addSubview(whereToGetTokenButton)
        view.addSubview(cloneFromGithubButton)
    }
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .separator // Dynamic separator color
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return divider
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo constraints
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            // Token text field constraints
            tokenTextField.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            tokenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            tokenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            tokenTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // AR mode selector constraints
            arModeSelector.topAnchor.constraint(equalTo: tokenTextField.bottomAnchor, constant: 16),
            arModeSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            arModeSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            // Launch AR button constraints
            launchARButton.topAnchor.constraint(equalTo: arModeSelector.bottomAnchor, constant: 16),
            launchARButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            launchARButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            launchARButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Divider constraints
            dividerStackView.topAnchor.constraint(equalTo: launchARButton.bottomAnchor, constant: 16),
            dividerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dividerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            // Scan QR button constraints
            scanQRButton.topAnchor.constraint(equalTo: dividerStackView.bottomAnchor, constant: 16),
            scanQRButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scanQRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            scanQRButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Where to get token button constraints
            whereToGetTokenButton.bottomAnchor.constraint(equalTo: cloneFromGithubButton.topAnchor, constant: -12),
            whereToGetTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Clone from Github button constraints
            cloneFromGithubButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cloneFromGithubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        launchARButton.addTarget(self, action: #selector(launchARButtonTapped), for: .touchUpInside)
        scanQRButton.addTarget(self, action: #selector(scanQRButtonTapped), for: .touchUpInside)
        whereToGetTokenButton.addTarget(self, action: #selector(whereToGetTokenTapped), for: .touchUpInside)
        cloneFromGithubButton.addTarget(self, action: #selector(cloneFromGithubTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func launchARButtonTapped() {
        guard validateToken() else { return }
        self.navigateToARView()
        // iOS don't need warning
//        showARSafetyWarning()
    }
    
    @objc private func scanQRButtonTapped() {
        // Present the QR code scanner
        let qrScannerVC = QRCodeScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        qrScannerVC.onQRCodeScanned = { [weak self] token in
            self?.tokenTextField.text = token
        }
        present(qrScannerVC, animated: true)
    }
    
    @objc private func whereToGetTokenTapped() {
        if let url = docTokenURL {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func cloneFromGithubTapped() {
        if let url = githubCloneURL {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openConsoleURL() {
        if let url = consoleURL {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Helper Methods
    
    private func validateToken() -> Bool {
        guard let token = tokenTextField.text, !token.isEmpty else {
            showAlert(title: "Error", message: "Please enter a project access token")
            return false
        }
        
        guard token.hasPrefix(prefixToken) else {
            showAlert(title: "Error", message: "Invalid token format. Token must start with '\(prefixToken)'")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showARSafetyWarning() {
        let alert = UIAlertController(title: "AR Safety Warning", message: nil, preferredStyle: .alert)
        
        // Create the attributed string for the message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 8
        
        let messageText = """
        This app uses AR. Please ensure the following before proceeding:
        
        👨‍👩‍👧‍👦 Parental Supervision: Parental supervision is highly recommended for younger users.
        
        👁️ Stay Aware of Surroundings: Always be mindful of your real-world environment to avoid physical hazards.
        
        By continuing, you acknowledge that you have read and understood these safety precautions.
        """
        
        let attributedMessage = NSMutableAttributedString(
            string: messageText,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        
        // Make the title bold
        let titleRange = (messageText as NSString).range(of: "This app uses AR. Please ensure the following before proceeding:")
        attributedMessage.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], range: titleRange)
        
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
            self?.navigateToARView()
        }))
        
        present(alert, animated: true)
    }
    
    private func navigateToARView() {
        let arVC = ARViewController()
        arVC.accessToken = tokenTextField.text
        
        // Set the AR mode based on selection
        switch arModeSelector.selectedSegmentIndex {
        case 0:
            arVC.arMode = "Point Cloud & Image Anchor"
        case 1:
            arVC.arMode = "World & Image Anchor"
        case 2:
            arVC.arMode = "Face Anchor"
        default:
            arVC.arMode = "World & Image Anchor"
        }
        
        // Pass location if available
        arVC.latitude = latitude
        arVC.longitude = longitude
        
        // Present the AR view controller
        arVC.modalPresentationStyle = .fullScreen
        present(arVC, animated: true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when Done button is tapped
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - App Clip Parameters
    
    private func checkForAppClipParameters() {
        isLoading = true
        
        // Check for parameters in UserDefaults (saved by AppDelegate)
        if let parameters = UserDefaults.standard.dictionary(forKey: "AppClipParameters") as? [String: String] {
            if tokenTextField.text?.isEmpty ?? true, let token = parameters["token"] {
                tokenTextField.text = prefixToken + token
            }
            
            if let latString = parameters["lat"], let lat = Double(latString) {
                latitude = lat
            }
            
            if let longString = parameters["long"], let long = Double(longString) {
                longitude = long
            }
        }
        
        isLoading = false
    }
}

