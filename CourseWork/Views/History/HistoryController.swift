//
//  HistoryController.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 28.11.20.
//

import UIKit

class HistoryController: DBViewController<History> {
    
//    private var parameters = ["id", "client name", "paid service name", "cost"]
//    private var typeOfSort = ["inscrease", "decrease"]
    
    private let distance = ["all time", "current day", "current week", "current month"]
    private let labelPrefixes = ["sum for all time:",
                                 "sum for current day:",
                                 "sum for current week:",
                                 "sum for current month:"]
    
    @IBOutlet weak var sortByPickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sumForLabel: UILabel!
    @IBOutlet weak var ndsButton: UIButton!
    
    override var storage: [History] {
        didSet {
            setupLabel(ndsButton.backgroundColor == UIColor.lightGray ? false : true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialStorage = storage
        
        
        sortByPickerView.delegate = self
        sortByPickerView.dataSource = self

        setupButton()
        setupTableView()
    }
    
    private func setupLabel(_ nds: Bool) {
        let sum = storage.reduce(0, { a, b in
            a + b.cost
        })
        
        let ndsCoef = nds ? 0.8 : 1.0
        
        sumForLabel.text! = labelPrefixes[sortByPickerView.selectedRow(inComponent: 0)] + " \(round(Double(sum) * ndsCoef)) byn"
        print(sum)
    }
    
    private func setupButton() {
        ndsButton.backgroundColor = .lightGray
        ndsButton.addTarget(self, action: #selector(handler), for: .touchUpInside)
    }
    
    @objc func handler(_ sender: UIButton) {
        
        sender.backgroundColor = sender.backgroundColor == UIColor.lightGray ? .systemGreen : .lightGray
        setupLabel(sender.backgroundColor == UIColor.lightGray ? false : true)
        
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: HistoryCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryCell.identifier)
        
        getAll(table: .history) {
            self.tableView.reloadData()
        }
    }

}

extension HistoryController: UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDFViewController" {
            let vc = segue.destination as! PDFViewController
            vc.documentData = PDFCreator.createFlyer(storage, sizeOfHead: 25, sizeOfDefault: 16)
//            checksForPDF = []
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distance.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distance[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            storage = specialStorage
            tableView.reloadData()
        case 1:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let calendar = Calendar.current
            
            storage = specialStorage.filter({ (history) -> Bool in
                let currentDay = calendar.component(.day, from: dateFormatter.date(from: history.dateTime) ?? Date())
                return currentDay == calendar.component(.day, from: Date())
            })
            tableView.reloadData()
        case 2:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            storage = specialStorage.filter({ (history) -> Bool in
                let fromTableDate = dateFormatter.date(from: history.dateTime) ?? Date()
//                let
                
                let res = Date().compare(anotherDate: fromTableDate, predicate: .week)
                return res
            })
            tableView.reloadData()
        case 3:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            storage = specialStorage.filter({ (history) -> Bool in
                let fromTableDate = dateFormatter.date(from: history.dateTime) ?? Date()
//                let
                
                let res = Date().compare(anotherDate: fromTableDate, predicate: .month)
                return res
            })
            tableView.reloadData()
        default:
            print("def")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UITableViewCell() }
        let data = storage[indexPath.row]
        cell.data = data
        return cell
    }
    
    
}

extension Date {
    
    
    enum DateType {
        case day
        case week
        case month
        case year
        case outOfYear
    }
    
    func compare(anotherDate: Date, predicate: DateType) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let calendar = Calendar.current
        
        let day1 = calendar.component(.day, from: self)
        let day2 = calendar.component(.day, from: anotherDate)
        let week1 = calendar.component(.weekOfMonth, from: self)
        let week2 = calendar.component(.weekOfMonth, from: anotherDate)
        let mon1 = calendar.component(.month, from: self)
        let mon2 = calendar.component(.month, from: anotherDate)
        let year1 = calendar.component(.year, from: self)
        let year2 = calendar.component(.year, from: anotherDate)
        
        if year1 == year2 {
            if mon1 == mon2 {
                if week1 == week2 {
                    if day1 == day2 {
                        return .day == predicate || .week == predicate || .month == predicate
                    }
                    return .week == predicate || .month == predicate
                }
                return .month == predicate
            }
            return .year == predicate
        }
        return .outOfYear == predicate
    }
    
}
