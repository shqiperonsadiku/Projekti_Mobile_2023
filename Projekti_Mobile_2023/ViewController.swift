//
//  ViewController.swift
//  Projekti_Mobile_2023
//
//  Created by Shqiperon on 11.8.23.
//

import UIKit

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Today"])
        //segmentedControl.addTarget(ViewController.self, action: #selector(filterSegmentChanged(_:)), for: .valueChanged)
        segmentedControl.addTarget(self, action: #selector(filterSegmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()

    private var models = [ToDoListItem]()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let filterButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         title = "To Do List"
        
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds

        view.addSubview(filterSegmentedControl)
        filterSegmentedControl.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 30)

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        filterButtonsContainer.addSubview(filterSegmentedControl)
        NSLayoutConstraint.activate([
            filterSegmentedControl.leadingAnchor.constraint(equalTo: filterButtonsContainer.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: filterButtonsContainer.trailingAnchor, constant: -16),
            filterSegmentedControl.topAnchor.constraint(equalTo: filterButtonsContainer.topAnchor, constant: 20),
            filterSegmentedControl.bottomAnchor.constraint(equalTo: filterButtonsContainer.bottomAnchor, constant: -20)
        ])

        stackView.addArrangedSubview(filterButtonsContainer)
        stackView.addArrangedSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }

    @objc private func filterSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // Show all items
            getAllItems()
        } else {
            // Show tasks for today
            getTodayItems()
        }
    }
    
     @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let alertController = presentedViewController as? UIAlertController,
              let submitAction = alertController.actions.last else {
            return
        }
        
        if let text = textField.text, !text.isEmpty {
            submitAction.isEnabled = text.count <= 40
        } else {
            submitAction.isEnabled = false
        }
    }

    @objc private func didTapAdd() {
        
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Task name"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                self?.createItem(name: text)
            }
        }
        submitAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        cell.textLabel?.text = model.name
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 30),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -30),
        ])
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            // MARK: you are WORKING IN HERE
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self]_ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newName: newName)
            }))
            
            
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }

    // Alert function
    func showAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: Core Data functions

    func getTodayItems() {
        let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        fetchRequest.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", startDate as NSDate, endDate as NSDate)
        
        do {
            models = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            // Handle error
        }
    }

    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // error
        }
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
            showAlert(with: "Task created successfully")
        }
        catch {
            print("Task failed to create!")
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
            showAlert(with: "Task deleted successfully")
        }
        catch {
            print("Task failed to delete!")
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
            showAlert(with: "Task updated successfully")
        }
        catch {
           print("Task failed to update!")
        }
    }

}

