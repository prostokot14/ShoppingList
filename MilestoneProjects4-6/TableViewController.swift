//
//  TableViewController.swift
//  MilestoneProjects4-6
//
//  Created by Антон Кашников on 31.05.2023.
//

import UIKit

final class TableViewController: UITableViewController {
    private var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping list"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = shoppingList[indexPath.row]
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = shoppingList[indexPath.row]
        }
        
        return cell
    }
    
    @objc private func promptForItem() {
        let alertController = UIAlertController(title: "Enter an item", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAlertAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
            guard let item = alertController?.textFields?[0].text else {
                return
            }
            
            self?.submit(item)
        }

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(submitAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }
    
    @objc private func clearList() {
        shoppingList = []
        tableView.reloadData()
    }
    
    private func submit(_ item: String) {
        shoppingList.insert(item, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
