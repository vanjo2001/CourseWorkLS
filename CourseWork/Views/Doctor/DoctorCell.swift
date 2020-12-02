//
//  DoctorCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 17.11.20.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    static let identifier = "DoctorCell"
    
    @IBOutlet weak private var id: UILabel!
    @IBOutlet weak private var specializationType: UILabel!
    @IBOutlet weak private var fullName: UILabel!
    @IBOutlet weak private var age: UILabel!
    @IBOutlet weak private var employmentLength: UILabel!
    
    var data: Doctor! {
        didSet {
            id.text = String(data.id)
            specializationType.text = String(data.specializationId)
            fullName.text = data.fullName
            age.text = String(data.age)
            employmentLength.text = String(data.lengthOfEmployment)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
