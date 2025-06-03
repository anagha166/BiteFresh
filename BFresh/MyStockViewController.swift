import UIKit

class MyStockViewController: UIViewController {
    
    private var fridgeItems: [(name: String, expirationDate: Date)] = []
    private var pantryItems: [(name: String, expirationDate: Date)] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Stock"
        label.font = .jura(size: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ scan", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fridgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fridgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fridge"
        label.font = .jura(size: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pantryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pantryLabel: UILabel = {
        let label = UILabel()
        label.text = "Pantry"
        label.font = .jura(size: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let giveBackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 20
        button.setTitle("Give Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fridgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let pantryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scanButton)
        view.addSubview(fridgeView)
        fridgeView.addSubview(fridgeLabel)
        view.addSubview(pantryView)
        pantryView.addSubview(pantryLabel)
        view.addSubview(giveBackButton)
        view.addSubview(fridgeStackView)
        view.addSubview(pantryStackView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            
            scanButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fridgeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fridgeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fridgeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fridgeView.heightAnchor.constraint(equalToConstant: 200),
            
            fridgeLabel.topAnchor.constraint(equalTo: fridgeView.topAnchor, constant: 16),
            fridgeLabel.leadingAnchor.constraint(equalTo: fridgeView.leadingAnchor, constant: 16),
            
            pantryView.topAnchor.constraint(equalTo: fridgeView.bottomAnchor, constant: 20),
            pantryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pantryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pantryView.heightAnchor.constraint(equalToConstant: 200),
            
            pantryLabel.topAnchor.constraint(equalTo: pantryView.topAnchor, constant: 16),
            pantryLabel.leadingAnchor.constraint(equalTo: pantryView.leadingAnchor, constant: 16),
            
            giveBackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            giveBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giveBackButton.widthAnchor.constraint(equalToConstant: 120),
            giveBackButton.heightAnchor.constraint(equalToConstant: 40),
            
            fridgeStackView.topAnchor.constraint(equalTo: fridgeLabel.bottomAnchor, constant: 16),
            fridgeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            fridgeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            pantryStackView.topAnchor.constraint(equalTo: pantryLabel.bottomAnchor, constant: 16),
            pantryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            pantryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        // Add targets
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    func updateItems(fridgeItems: [(name: String, expirationDate: Date)], pantryItems: [(name: String, expirationDate: Date)]) {
        self.fridgeItems = fridgeItems
        self.pantryItems = pantryItems
        updateDisplay()
    }
    
    private func updateDisplay() {
        // Clear existing items
        fridgeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        pantryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add fridge items
        fridgeItems.forEach { item in
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = "• \(item.name)"
            label.textColor = .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.layer.cornerRadius = 4
            progressView.clipsToBounds = true
            
            // Calculate time between current date and expiration date
            let totalTime = item.expirationDate.timeIntervalSince(Date())
            let daysLeft = totalTime / (24 * 60 * 60) // Convert to days
            
            // Calculate progress (0.0 means newly added, 1.0 means at expiration date)
            let progress = max(0.0, min(1.0, Float(daysLeft) / 30.0))
            
            // Calculate color based on days left (more red as it gets closer to expiration)
            let redComponent = min(1.0, Float(30 - daysLeft) / 30.0)
            let greenComponent = max(0.0, Float(daysLeft) / 30.0)
            progressView.progressTintColor = UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: 0.0, alpha: 1.0)
            
            progressView.setProgress(progress, animated: false)
            
            container.addSubview(label)
            container.addSubview(progressView)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                
                progressView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                progressView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
                progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                progressView.heightAnchor.constraint(equalToConstant: 8)
            ])
            
            fridgeStackView.addArrangedSubview(container)
        }
        
        // Add pantry items
        pantryItems.forEach { item in
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = "• \(item.name)"
            label.textColor = .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.layer.cornerRadius = 4
            progressView.clipsToBounds = true
            
            // Calculate time between current date and expiration date
            let totalTime = item.expirationDate.timeIntervalSince(Date())
            let daysLeft = totalTime / (24 * 60 * 60) // Convert to days
            
            // Calculate progress (0.0 means newly added, 1.0 means at expiration date)
            let progress = max(0.0, min(1.0, Float(daysLeft) / 30.0))
            
            // Calculate color based on days left (more red as it gets closer to expiration)
            let redComponent = min(1.0, Float(30 - daysLeft) / 30.0)
            let greenComponent = max(0.0, Float(daysLeft) / 30.0)
            progressView.progressTintColor = UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: 0.0, alpha: 1.0)
            
            progressView.setProgress(progress, animated: false)
            
            container.addSubview(label)
            container.addSubview(progressView)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                
                progressView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                progressView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
                progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                progressView.heightAnchor.constraint(equalToConstant: 8)
            ])
            
            pantryStackView.addArrangedSubview(container)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func scanButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
}

extension MyStockViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if info[.originalImage] is UIImage {
            // Handle the scanned image here
            print("Image captured successfully")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 
