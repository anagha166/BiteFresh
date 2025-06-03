//
//  ViewController.swift
//  BFresh
//
//  Created by Anagha Kamath on 4/5/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ByteFresh"
        label.font = .jura(size: 34, weight: .bold)
        label.textColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        button.layer.cornerRadius = 22 // Following 44pt minimum touch target
        button.titleLabel?.font = .jura(size: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let calendarLabel: UILabel = {
        let label = UILabel()
        label.font = .jura(size: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current Week"  // Default text, will be updated in viewDidLoad
        return label
    }()
    
    private let weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4  // Reduced spacing between days
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let groceryListButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groceryListLabel: UILabel = {
        let label = UILabel()
        label.text = "Grocery List"
        label.font = .jura(size: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let groceryItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let addGroceryButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ Add more...", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var groceryItems: [String] = ["Eggs", "Bacon", "Tomatoes"] {
        didSet {
            updateGroceryItemsDisplay()
        }
    }
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Ideas"
        label.font = .jura(size: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.systemGray6
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    private var recipes: [(name: String, ingredients: [String], url: String)] = [
        ("Classic Breakfast", ["Eggs", "Bacon"], "https://www.allrecipes.com/recipe/221286/classic-breakfast/"),
        ("BLT Sandwich", ["Bacon", "Tomatoes"], "https://www.simplyrecipes.com/recipes/blt_sandwich/"),
        ("Egg & Tomato Scramble", ["Eggs", "Tomatoes"], "https://www.foodnetwork.com/recipes/food-network-kitchen/egg-and-tomato-scramble-3364539")
    ]
    
    private let myStockButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 16
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let myStockLabel: UILabel = {
        let label = UILabel()
        label.text = "My Stock"
        label.font = .jura(size: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myStockItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let addStockButton: UIButton = {
        let button = UIButton()
        button.setTitle("View", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyStockImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "refrigerator.fill")
            imageView.tintColor = .systemGray3
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    private var fridgeItems: [(name: String, expirationDate: Date)] = []
    private var pantryItems: [(name: String, expirationDate: Date)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        updateCalendarLabel()
        setupCalendarDays()
        setupMyStockSection()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add scrollView and contentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews to contentView
        contentView.addSubview(logoLabel)
        contentView.addSubview(scanButton)
        contentView.addSubview(calendarView)
        calendarView.addSubview(calendarLabel)
        calendarView.addSubview(weekStackView)
        contentView.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(groceryListButton)
        buttonsStackView.addArrangedSubview(myStockButton)
        contentView.addSubview(recipeLabel)
        contentView.addSubview(recipeTableView)
        
        setupGroceryListSection()
        setupMyStockSection()
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Logo and Scan button
            logoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            logoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            scanButton.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor),
            scanButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            scanButton.widthAnchor.constraint(equalToConstant: 100),
            scanButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Calendar
            calendarView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 24),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            calendarView.heightAnchor.constraint(equalToConstant: 120),
            
            calendarLabel.topAnchor.constraint(equalTo: calendarView.topAnchor, constant: 16),
            calendarLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 16),
            
            weekStackView.topAnchor.constraint(equalTo: calendarLabel.bottomAnchor, constant: 12),
            weekStackView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 16),
            weekStackView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -16),
            weekStackView.bottomAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: -16),
            
            // Buttons Stack - Remove fixed height
            buttonsStackView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // Recipe Section
            recipeLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 24),
            recipeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            recipeTableView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 16),
            recipeTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            recipeTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            recipeTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        // Add targets
        myStockButton.addTarget(self, action: #selector(myStockTapped), for: .touchUpInside)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
    }
    
    private func updateCalendarLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        dateFormatter.dateFormat = "MMM d"
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "America/Los_Angeles") ?? calendar.timeZone
        
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - 1 // Get to Sunday
        
        if let sunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today),
           let saturday = calendar.date(byAdding: .day, value: 6, to: sunday) {
            let startDate = dateFormatter.string(from: sunday)
            let endDate = dateFormatter.string(from: saturday)
            calendarLabel.text = "\(startDate)-\(endDate)"
        }
    }
    
    private func createDayView(dayName: String, date: Int, isCurrentDay: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let dayLabel = UILabel()
        dayLabel.text = dayName
        dayLabel.font = .jura(size: 13, weight: .medium)
        dayLabel.textAlignment = .center
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = "\(date)"
        dateLabel.font = .jura(size: 15, weight: .semibold)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(dayLabel)
        container.addSubview(dateLabel)
        
        if isCurrentDay {
            container.backgroundColor = UIColor.systemGray4
            container.layer.cornerRadius = 8
        }
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 60),  // Increased height
            
            dayLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
        
        return container
    }
    
    private func setupCalendarDays() {
        // Remove existing day views
        weekStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "America/Los_Angeles") ?? calendar.timeZone
        
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - 1 // Get to Sunday
        
        guard let sunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) else { return }
        
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let currentWeekday = calendar.component(.weekday, from: today) - 1 // 0-based index
        
        for i in 0...6 {
            guard let date = calendar.date(byAdding: .day, value: i, to: sunday) else { continue }
            let dayOfMonth = calendar.component(.day, from: date)
            let dayView = createDayView(dayName: dayNames[i], date: dayOfMonth, isCurrentDay: i == currentWeekday)
            weekStackView.addArrangedSubview(dayView)
        }
    }
    
    private func createGroceryItemLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = "• " + text
        label.textColor = .darkGray
        return label
    }
    
    private func updateGroceryItemsDisplay() {
        // Clear existing items
        groceryItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add top 3 items
        let topItems = Array(groceryItems.prefix(3))
        topItems.forEach { item in
            groceryItemsStackView.addArrangedSubview(createGroceryItemLabel(item))
        }
    }
    
    private func setupGroceryListSection() {
        // Convert button to tappable view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(groceryListTapped))
        groceryListButton.addGestureRecognizer(tapGesture)
        groceryListButton.isUserInteractionEnabled = true
        
        // Add subviews
        groceryListButton.addSubview(groceryListLabel)
        groceryListButton.addSubview(groceryItemsStackView)
        groceryListButton.addSubview(addGroceryButton)
        
        NSLayoutConstraint.activate([
            groceryListLabel.topAnchor.constraint(equalTo: groceryListButton.topAnchor, constant: 16),
            groceryListLabel.leadingAnchor.constraint(equalTo: groceryListButton.leadingAnchor, constant: 16),
            
            groceryItemsStackView.topAnchor.constraint(equalTo: groceryListLabel.bottomAnchor, constant: 16),
            groceryItemsStackView.leadingAnchor.constraint(equalTo: groceryListButton.leadingAnchor, constant: 16),
            groceryItemsStackView.trailingAnchor.constraint(equalTo: groceryListButton.trailingAnchor, constant: -16),
            
            addGroceryButton.topAnchor.constraint(equalTo: groceryItemsStackView.bottomAnchor, constant: 8),  // Reverted back to 8
            addGroceryButton.leadingAnchor.constraint(equalTo: groceryListButton.leadingAnchor, constant: 16),
            addGroceryButton.bottomAnchor.constraint(equalTo: groceryListButton.bottomAnchor, constant: -16)
        ])
        
        // Add target for add button
        addGroceryButton.addTarget(self, action: #selector(groceryListTapped), for: .touchUpInside)
        
        // Initial display
        updateGroceryItemsDisplay()
    }
    
    @objc private func groceryListTapped() {
        let groceryListVC = GroceryListViewController()
        groceryListVC.groceryItems = groceryItems // Pass the grocery items to the grocery list view controller
        groceryListVC.delegate = self // Set up delegation to receive updates
        navigationController?.pushViewController(groceryListVC, animated: true)
    }
    
    @objc private func myStockTapped() {
        let stockVC = StockViewController()
        stockVC.updateItems(fridgeItems: fridgeItems.map { $0.name }, pantryItems: pantryItems.map { $0.name })
        navigationController?.pushViewController(stockVC, animated: true)
    }
    
    @objc private func scanButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    private func createStockItemLabel(_ item: (name: String, expirationDate: Date), isFridge: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDate).day ?? 0
        label.text = "• \(item.name): \(daysLeft) days left!"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Create attributed string to make days count red
        let attributedString = NSMutableAttributedString(string: label.text!)
        let range = (label.text! as NSString).range(of: "\(daysLeft) days left!")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        label.attributedText = attributedString
        
        container.addSubview(label)
        
        if isFridge {
            let progressBar = UIProgressView(progressViewStyle: .bar)
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            progressBar.progressTintColor = .systemGreen
            progressBar.trackTintColor = .systemGray4
            progressBar.layer.cornerRadius = 2
            progressBar.clipsToBounds = true
            
            // Calculate progress (0.0 to 1.0)
            let totalDays = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDate).day ?? 7
            let progress = Float(totalDays) / 7.0 // Assuming 7 days is the maximum
            progressBar.progress = min(progress, 1.0)
            
            container.addSubview(progressBar)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                
                progressBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
                progressBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                progressBar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                progressBar.heightAnchor.constraint(equalToConstant: 4),
                progressBar.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        return container
    }
    
    private func updateMyStockDisplay() {
        // Clear existing items
        myStockItemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Combine and sort all items by expiration date
        let allItems = (fridgeItems.map { ($0, true) } + pantryItems.map { ($0, false) })
            .sorted { $0.0.expirationDate < $1.0.expirationDate }
        
        // Take top 3 items closest to expiration
        let topItems = Array(allItems.prefix(3))
        topItems.forEach { item, isFridge in
            myStockItemsStackView.addArrangedSubview(createStockItemLabel(item, isFridge: isFridge))
        }
    }
    
    private func setupMyStockSection() {
        // Add subviews
        myStockButton.addSubview(myStockLabel)
        myStockButton.addSubview(myStockItemsStackView)
        myStockButton.addSubview(addStockButton)
        
        // Add some test items with different expiration dates
        let calendar = Calendar.current
        let today = Date()
        
        NSLayoutConstraint.activate([
            myStockLabel.topAnchor.constraint(equalTo: myStockButton.topAnchor, constant: 16),
            myStockLabel.leadingAnchor.constraint(equalTo: myStockButton.leadingAnchor, constant: 16),
            
            myStockItemsStackView.topAnchor.constraint(equalTo: myStockLabel.bottomAnchor, constant: 16),
            myStockItemsStackView.leadingAnchor.constraint(equalTo: myStockButton.leadingAnchor, constant: 16),
            myStockItemsStackView.trailingAnchor.constraint(equalTo: myStockButton.trailingAnchor, constant: -16),
            
            addStockButton.topAnchor.constraint(equalTo: myStockItemsStackView.bottomAnchor, constant: 16),
            addStockButton.leadingAnchor.constraint(equalTo: myStockButton.leadingAnchor, constant: 16),
            addStockButton.bottomAnchor.constraint(equalTo: myStockButton.bottomAnchor, constant: -16)
        ])
        
        // Add target for add button
        addStockButton.addTarget(self, action: #selector(myStockTapped), for: .touchUpInside)
        
        // Initial display
        updateMyStockDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update recipe table view height based on content
        let recipeTableHeight = recipeTableView.contentSize.height
        recipeTableView.heightAnchor.constraint(equalToConstant: recipeTableHeight).isActive = true
        
        // Calculate the maximum height needed between grocery list and stock
        let groceryListContentHeight = groceryListLabel.frame.height +
                                     (groceryItemsStackView.frame.height * 3) + // Space for 3 items
                                     addGroceryButton.frame.height +
                                     48 // padding (16 * 3)
        
        let myStockContentHeight = myStockItemsStackView.frame.height + 32 // padding (16 * 2)
        
        // Use the larger of the two heights for both boxes, with a minimum height of 200
        let boxHeight = max(groceryListContentHeight, myStockContentHeight, 200)
        
        // Set both boxes to the same height
        groceryListButton.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
        myStockButton.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        
        // Configure cell
        cell.textLabel?.text = recipe.name
        cell.backgroundColor = .clear
        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipes[indexPath.row]
        
        if let url = URL(string: recipe.url) {
            UIApplication.shared.open(url)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // Handle the scanned image here
            print("Image captured successfully")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ViewController: GroceryListViewControllerDelegate {
    func groceryListViewController(_ controller: GroceryListViewController, didUpdateItems items: [String]) {
        self.groceryItems = items
    }
    
    func groceryListViewController(_ controller: GroceryListViewController, didAddToStock item: String, expirationDate: Date) {
        DispatchQueue.main.async {
            // First determine if the item is perishable
            let geminiService = GeminiService()
            geminiService.determineIfPerishable(item: item) { isPerishable in
                DispatchQueue.main.async {
                    if isPerishable {
                        self.fridgeItems.append((name: item, expirationDate: expirationDate))
                    } else {
                        self.pantryItems.append((name: item, expirationDate: expirationDate))
                    }
                    
                    // Update the stock page if it's currently visible
                    if let stockVC = self.navigationController?.topViewController as? StockViewController {
                        stockVC.updateItems(fridgeItems: self.fridgeItems.map { $0.name }, pantryItems: self.pantryItems.map { $0.name })
                    }
                }
            }
        }
    }
    
    // Keep the old method for backward compatibility
    func groceryListViewController(_ controller: GroceryListViewController, didAddToStock item: String, isPerishable: Bool) {
        let oneWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        if isPerishable {
            self.fridgeItems.append((name: item, expirationDate: oneWeekFromNow))
        } else {
            self.pantryItems.append((name: item, expirationDate: oneWeekFromNow))
        }
        
        // Update the stock page if it's currently visible
        if let stockVC = self.navigationController?.topViewController as? StockViewController {
            stockVC.updateItems(fridgeItems: self.fridgeItems.map { $0.name }, pantryItems: self.pantryItems.map { $0.name })
        }
    }
}

