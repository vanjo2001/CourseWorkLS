//
//  ConsultingHourController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import UIKit

class ConsultingHourController: DBViewController<ConsultingHours> {
    
    private var parameters = ["id", "info"]
    private var typeOfSort = ["inscrease", "decrease"]
    
    @IBOutlet weak var sortByPickerView: UIPickerView!
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var infoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sortByPickerView.delegate = self
        sortByPickerView.dataSource = self
        
        getAll(table: .consultingHours()) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addConsultingHours(_ sender: UIButton) {
        guard let text = infoTextField.text else { return }
        guard !text.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        
        insert(by: id, table: .consultingHours(info: text), completion: {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        })
    }
    

}

extension ConsultingHourController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            storage = predicate ? storage.sorted(by: { $0.info < $1.info }) : storage.sorted(by: { $0.info > $1.info })
        default:
            break
        }

        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let data = storage[indexPath.row]
        
        let label = UILabel(frame: CGRect(x:0, y:0, width:150, height:20))
        label.text = "time: " + data.info
        cell.accessoryView = label
        cell.textLabel?.text = "id: \(data.id)"
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .consultingHours(), by: deleted.id)
        }
    }
    
    
}
