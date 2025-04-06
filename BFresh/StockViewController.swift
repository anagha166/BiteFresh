import UIKit

class StockViewController: UIViewController {
    
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
    
    private let fridgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fridge"
        label.font = .jura(size: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pantryLabel: UILabel = {
        let label = UILabel()
        label.text = "Pantry"
        label.font = .jura(size: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fridgeTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.systemGray6
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = .zero
        return table
    }()
    
    private let pantryTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.systemGray6
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = .zero
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableViews()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(fridgeLabel)
        view.addSubview(fridgeTableView)
        view.addSubview(pantryLabel)
        view.addSubview(pantryTableView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            
            fridgeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            fridgeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            fridgeTableView.topAnchor.constraint(equalTo: fridgeLabel.bottomAnchor, constant: 10),
            fridgeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fridgeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fridgeTableView.heightAnchor.constraint(equalToConstant: 200),
            
            pantryLabel.topAnchor.constraint(equalTo: fridgeTableView.bottomAnchor, constant: 30),
            pantryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            pantryTableView.topAnchor.constraint(equalTo: pantryLabel.bottomAnchor, constant: 10),
            pantryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pantryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pantryTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableViews() {
        fridgeTableView.delegate = self
        fridgeTableView.dataSource = self
        fridgeTableView.register(FridgeItemCell.self, forCellReuseIdentifier: "FridgeCell")
        
        pantryTableView.delegate = self
        pantryTableView.dataSource = self
        pantryTableView.register(PantryItemCell.self, forCellReuseIdentifier: "PantryCell")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateItems(fridgeItems: [String], pantryItems: [String]) {
        // Convert both fridge and pantry items to include expiration dates (1 week from now)
        let oneWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        self.fridgeItems = fridgeItems.map { (name: $0, expirationDate: oneWeekFromNow) }
        self.pantryItems = pantryItems.map { (name: $0, expirationDate: oneWeekFromNow) }
        
        fridgeTableView.reloadData()
        pantryTableView.reloadData()
    }
}

class FridgeItemCell: UITableViewCell {
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressFill: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(progressBar)
        progressBar.addSubview(progressFill)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: 100),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            progressFill.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: (name: String, expirationDate: Date)) {
        textLabel?.text = item.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: item.expirationDate)
        
        let now = Date()
        let totalTime = item.expirationDate.timeIntervalSince(now)
        let progress = min(max(1 - (totalTime / (7 * 24 * 60 * 60)), 0), 1) // Convert to fraction of 7 days
        
        // Calculate color based on progress (time remaining)
        let color: UIColor
        if progress <= 0.5 {
            // Green to yellow (0% to 50% time elapsed)
            let greenToYellow = progress * 2 // Scale to 0-1
            color = UIColor(
                red: greenToYellow,
                green: 1.0,
                blue: 0.0,
                alpha: 1.0
            )
        } else {
            // Yellow to red (50% to 100% time elapsed)
            let yellowToRed = (progress - 0.5) * 2 // Scale to 0-1
            color = UIColor(
                red: 1.0,
                green: 1.0 - yellowToRed,
                blue: 0.0,
                alpha: 1.0
            )
        }
        
        progressFill.backgroundColor = color
        
        // Remove any existing width constraint
        progressFill.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                progressFill.removeConstraint(constraint)
            }
        }
        
        // Add new width constraint - bar fills up as we get closer to expiration
        let widthConstraint = progressFill.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: CGFloat(progress))
        widthConstraint.isActive = true
    }
}

class PantryItemCell: UITableViewCell {
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressFill: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(progressBar)
        progressBar.addSubview(progressFill)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.widthAnchor.constraint(equalToConstant: 100),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            progressFill.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            progressFill.topAnchor.constraint(equalTo: progressBar.topAnchor),
            progressFill.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: progressBar.leadingAnchor, constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: (name: String, expirationDate: Date)) {
        textLabel?.text = item.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateLabel.text = dateFormatter.string(from: item.expirationDate)
        
        let now = Date()
        let totalTime = item.expirationDate.timeIntervalSince(now)
        let progress = min(max(1 - (totalTime / (7 * 24 * 60 * 60)), 0), 1) // Convert to fraction of 7 days
        
        // Calculate color based on progress (time remaining)
        let color: UIColor
        if progress <= 0.5 {
            // Green to yellow (0% to 50% time elapsed)
            let greenToYellow = progress * 2 // Scale to 0-1
            color = UIColor(
                red: greenToYellow,
                green: 1.0,
                blue: 0.0,
                alpha: 1.0
            )
        } else {
            // Yellow to red (50% to 100% time elapsed)
            let yellowToRed = (progress - 0.5) * 2 // Scale to 0-1
            color = UIColor(
                red: 1.0,
                green: 1.0 - yellowToRed,
                blue: 0.0,
                alpha: 1.0
            )
        }
        
        progressFill.backgroundColor = color
        
        // Remove any existing width constraint
        progressFill.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                progressFill.removeConstraint(constraint)
            }
        }
        
        // Add new width constraint - bar fills up as we get closer to expiration
        let widthConstraint = progressFill.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: CGFloat(progress))
        widthConstraint.isActive = true
    }
}

extension StockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == fridgeTableView {
            return fridgeItems.count
        } else {
            return pantryItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == fridgeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeCell", for: indexPath) as! FridgeItemCell
            cell.configure(with: fridgeItems[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PantryCell", for: indexPath) as! PantryItemCell
            cell.configure(with: pantryItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == fridgeTableView {
                fridgeItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                pantryItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

