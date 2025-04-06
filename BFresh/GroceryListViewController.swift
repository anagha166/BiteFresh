import UIKit

protocol GroceryListViewControllerDelegate: AnyObject {
    func groceryListViewController(_ controller: GroceryListViewController, didUpdateItems items: [String])
    func groceryListViewController(_ controller: GroceryListViewController, didAddToStock item: String, expirationDate: Date)
}

class GroceryListViewController: UIViewController {
    
    weak var delegate: GroceryListViewControllerDelegate?
    var groceryItems: [String] = []
    private var checkedItems: Set<String> = []
    private let geminiService = GeminiService()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shopping List"
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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = .zero
        return table
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add more...", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(giveBackButton)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            statusLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            giveBackButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            giveBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            giveBackButton.widthAnchor.constraint(equalToConstant: 120),
            giveBackButton.heightAnchor.constraint(equalToConstant: 40),
            giveBackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func determineIfPerishable(item: String, completion: @escaping (Bool) -> Void) {
        geminiService.determineIfPerishable(item: item, completion: completion)
    }
    
    @objc private func backButtonTapped() {
        delegate?.groceryListViewController(self, didUpdateItems: groceryItems)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "Add Item", message: "Enter a new grocery item", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty else { return }
            
            self.groceryItems.append(text)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func updateStatus(_ message: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
        }
    }
    
    private func showExpirationDatePicker(for item: String) {
        let alert = UIAlertController(title: "Set Expiration Date", message: "When will \(item) expire?", preferredStyle: .alert)
        
        // Add date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a container view for the date picker
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Add the container view to the alert
        alert.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
            containerView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            alert.view.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        // Add "Don't know" button
        let dontKnowAction = UIAlertAction(title: "I don't know", style: .default) { [weak self] _ in
            self?.askGeminiForExpirationDate(item: item)
        }
        alert.addAction(dontKnowAction)
        
        // Add "Set Date" button
        let setDateAction = UIAlertAction(title: "Set Date", style: .default) { [weak self] _ in
            self?.delegate?.groceryListViewController(self!, didAddToStock: item, expirationDate: datePicker.date)
        }
        alert.addAction(setDateAction)
        
        // Add cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func askGeminiForExpirationDate(item: String) {
        updateStatus("Asking Gemini about \(item)'s expiration...")
        
        let geminiService = GeminiService()
        geminiService.getExpirationDays(for: item) { [weak self] days in
            DispatchQueue.main.async {
                if let days = days {
                    self?.updateStatus("\(item) typically expires in \(days) days")
                    let expirationDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
                    self?.delegate?.groceryListViewController(self!, didAddToStock: item, expirationDate: expirationDate)
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.updateStatus("Couldn't determine expiration for \(item). Using default of 7 days.")
                    let defaultExpiration = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                    self?.delegate?.groceryListViewController(self!, didAddToStock: item, expirationDate: defaultExpiration)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func removeItem(_ sender: UIButton) {
        let item = groceryItems[sender.tag]
        showExpirationDatePicker(for: item)
        groceryItems.remove(at: sender.tag)
        tableView.reloadData()
    }
}

extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = groceryItems[indexPath.row]
        
        
        cell.accessoryType = checkedItems.contains(item) ? .checkmark : .none
        
        if checkedItems.contains(item) {
            cell.textLabel?.textColor = .systemGray3
            cell.textLabel?.attributedText = NSAttributedString(
                string: item,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            cell.textLabel?.textColor = .label
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = item
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = groceryItems[indexPath.row]
        updateStatus("Processing \(item)...")
        
        // Remove the item from grocery list first
        groceryItems.remove(at: indexPath.row)
        checkedItems.remove(item)
        
        // Update table view
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        // Show expiration date picker
        showExpirationDatePicker(for: item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = groceryItems[indexPath.row]
            checkedItems.remove(item)
            groceryItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
} 
