//
//  ClientController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import UIKit

class ClientController: DBViewController<Client> {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: ClientCell.identifier, bundle: nil), forCellReuseIdentifier: ClientCell.identifier)
        
        getAll(table: .client()) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addClient(_ sender: Any) {
        
        guard let name = fullNameTextField.text,
              let age = ageTextField.text,
              let address = addressTextField.text else { return }
        
        guard !name.isEmpty && !age.isEmpty && !address.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: datePicker.date)
        
        insert(by: id, table: .client(fullName: name, birthday: strDate, age: Int(age), address: address)) {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        }
    }
    
    
}

extension ClientController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClientCell.identifier, for: indexPath) as? ClientCell else { return UITableViewCell() }
        let data = storage[indexPath.row]
        cell.data = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .client(), by: deleted.id)
        }
    }
    
    
}
