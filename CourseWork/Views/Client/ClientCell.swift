//
//  ClientCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 17.11.20.
//

import UIKit

class ClientCell: UITableViewCell {
    
    static let identifier = "ClientCell"
    
    @IBOutlet weak private var id: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var data: Client! {
        didSet {
            id.text = String(data.id)
            fullName.text = data.fullName
            birthday.text = data.birthday
            age.text = String(data.age)
            address.text = data.address
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
