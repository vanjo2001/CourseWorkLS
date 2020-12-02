//
//  DoctorViewController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 14.11.20.
//

import UIKit

class DoctorController: DBViewController<Doctor> {
    
    private var arrOfSpecializationId: [Identificator] = []
    
    @IBOutlet weak var specializationIdPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var LOETextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupPicker()
        
    }
    
    private func setupPicker() {
        specializationIdPicker.dataSource = self
        specializationIdPicker.delegate = self
        
        getAllId(table: .specialization()) { data in
            self.arrOfSpecializationId = data
            self.specializationIdPicker.reloadAllComponents()
        }
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: DoctorCell.identifier, bundle: nil), forCellReuseIdentifier: DoctorCell.identifier)
        
        getAll(table: .doctor()) {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func addDoctor(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let age = ageTextField.text,
              let LOE = LOETextField.text else { return }
        
        guard !name.isEmpty && !age.isEmpty && !LOE.isEmpty else { return }
        
        let id = (storage.last?.id ?? 0) + 1
        
        let specId = arrOfSpecializationId[specializationIdPicker.selectedRow(inComponent: 0)].id
        let resAge = Int(age)
        let resLOE = Int(LOE)
        
        insert(by: id,
               table: .doctor(specializationId: specId, fullName: name, age: resAge, employmentLength: resLOE)) {
            self.tableView.insertRows(at: [IndexPath(row: self.storage.count-1, section: 0)], with: .fade)
        }
        
    }
    
    
    
}

extension DoctorController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfSpecializationId.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrOfSpecializationId[row].id)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DoctorCell.identifier, for: indexPath) as? DoctorCell else { return UITableViewCell() }
        let data = storage[indexPath.row]
        cell.data = data
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = storage.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delete(table: .doctor(), by: deleted.id)
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
