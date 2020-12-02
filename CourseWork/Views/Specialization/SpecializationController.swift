//
//  SpecializationViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import UIKit

class SpecializationController: DBViewController<Specialization> {
    
    private let parameters = ["id", "name"]
    private let typeOfSort = ["inscrease", "decrease"]
    
    
    
    @IBOutlet weak var sortByPickerView: UIPickerView!
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var specializationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sortByPickerView.delegate = self
        sortByPickerView.dataSource = self
        
        getAll(table: .specialization()) {
            self.tableView.reloadData()
        }
        
    }
    
    
    @IBAction func addSpecialization(_ sender: Any) {
        
        guard let text = specializationField.text else { return }
        guard !text.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        
        insert(by: id, table: .specialization(name: text), completion: {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        })
    }
}


extension SpecializationController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let data = storage[indexPath.row]
        
        let label = UILabel(frame: CGRect(x:0, y:0, width:100, height:20))
        label.text = "name: " + data.name
        cell.accessoryView = label
        cell.textLabel?.text = "id: \(data.id)"
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .specialization(), by: deleted.id)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return parameters.count
        default:
            return typeOfSort.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return parameters[row]
        default:
            return typeOfSort[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var predicate = true
        
        if pickerView.selectedRow(inComponent: 1) == 1 {
            predicate = false
        }
        
        switch pickerView.selectedRow(inComponent: 0) {
        case 0:
            storage = predicate ? storage.sorted(by: { $0.id < $1.id }) : storage.sorted(by: { $0.id > $1.id })
        case 1:
            storage = predicate ? storage.sorted(by: { $0.name < $1.name }) : storage.sorted(by: { $0.name > $1.name })
        default:
            break
        }

        tableView.reloadData()
    }
    
}


