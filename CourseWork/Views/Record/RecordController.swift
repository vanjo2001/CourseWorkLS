//
//  RecordController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import UIKit

class RecordController: DBViewController<Record> {
    
    
    private var arrOfPaidServiceId: [Identificator] = []
    private var arrOfClientId: [Identificator] = []
    private var arrOfDoctorId: [Identificator] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet private weak var paidServiceIdPicker: UIPickerView!
    @IBOutlet private weak var clientIdPicker: UIPickerView!
    @IBOutlet private weak var doctorIdPicker: UIPickerView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPickers()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addRecord(_ sender: Any) {
        guard !arrOfPaidServiceId.isEmpty && !arrOfClientId.isEmpty && !arrOfDoctorId.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        
        let paidServiceId = arrOfPaidServiceId[paidServiceIdPicker.selectedRow(inComponent: 0)].id
        let clientId = arrOfClientId[clientIdPicker.selectedRow(inComponent: 0)].id
        let doctorId = arrOfDoctorId[doctorIdPicker.selectedRow(inComponent: 0)].id
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: datePicker.date)
        
        insert(by: id, table: .record(paidServiceId: paidServiceId, doctorId: doctorId, clientId: clientId, dateTime: date)) {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        }
        
    }
    
    private func setupPickers() {
        paidServiceIdPicker.delegate = self
        clientIdPicker.delegate = self
        doctorIdPicker.delegate = self
        
        getAllId(table: .paidService()) { data in
            self.arrOfPaidServiceId = data
            self.paidServiceIdPicker.reloadAllComponents()
        }
        
        getAllId(table: .client()) { data in
            self.arrOfClientId = data
            self.clientIdPicker.reloadAllComponents()
        }
        
        getAllId(table: .doctor()) { data in
            self.arrOfDoctorId = data
            self.doctorIdPicker.reloadAllComponents()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: RecordCell.identifier, bundle: nil), forCellReuseIdentifier: RecordCell.identifier)
        
        getAll(table: .record()) {
            self.tableView.reloadData()
        }
    }

}

extension RecordController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCell.identifier, for: indexPath) as? RecordCell else { return UITableViewCell() }
        let data = storage[indexPath.row]
        cell.data = data
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case _ where pickerView === paidServiceIdPicker:
            return String(arrOfPaidServiceId[row].id)
        case _ where pickerView === clientIdPicker:
            return String(arrOfClientId[row].id)
        case _ where pickerView === doctorIdPicker:
                return String(arrOfDoctorId[row].id)
        default:
            return "?"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case _ where pickerView === paidServiceIdPicker:
            return arrOfPaidServiceId.count
        case _ where pickerView === clientIdPicker:
            return arrOfClientId.count
        case _ where pickerView === doctorIdPicker:
            return arrOfDoctorId.count
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .record(), by: deleted.id)
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
