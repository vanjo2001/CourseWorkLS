//
//  PaidServiceController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 15.11.20.
//

import UIKit

class PaidServiceController: DBViewController<PaidService> {
    
    private var arrOfConsultingHoursId: [Identificator] = []
    
    @IBOutlet weak var consultingHoursIdPicker: UIPickerView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = 10
        
        setupTableView()
        setupPicker()
    }
    
    @IBAction func addPaidService(_ sender: UIButton) {
        guard let info = textView.text,
              let cost = costTextField.text else { return }
        
        guard !info.isEmpty && !cost.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        let consultingHoursId = arrOfConsultingHoursId[consultingHoursIdPicker.selectedRow(inComponent: 0)].id
        
        insert(by: id, table: .paidService(consultingHoursId: consultingHoursId, cost: Int(cost), info: info)) {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        }
        
    }
    
    
    private func setupPicker() {
        consultingHoursIdPicker.delegate = self
        consultingHoursIdPicker.dataSource = self
        
        getAllId(table: .consultingHours()) { data in
            self.arrOfConsultingHoursId = data
            self.consultingHoursIdPicker.reloadAllComponents()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PaidServiceCell.identifier, bundle: nil), forCellReuseIdentifier: PaidServiceCell.identifier)
        
        getAll(table: .paidService()) {
            self.tableView.reloadData()
        }
    }

}



extension PaidServiceController: UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfConsultingHoursId.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrOfConsultingHoursId[row].id)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaidServiceCell.identifier, for: indexPath) as? PaidServiceCell else { return UITableViewCell() }
        let data = storage[indexPath.row]
        cell.data = data
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .paidService(), by: deleted.id)
        }
    }
    
    func getAllId(table: PrivateHealthCareFacilityEndpoint.TableName, completion: @escaping ([Identificator]) -> ()) {
        NetworkEngine.request(endpoint: PrivateHealthCareFacilityEndpoint.getAllFrom(searched: table)) { (result: Result<[Identificator], Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let success):
                completion(success)
            }
        }
    }
    
    
}
