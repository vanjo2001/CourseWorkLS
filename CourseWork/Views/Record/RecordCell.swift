//
//  RecordCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 18.11.20.
//

import UIKit

class RecordCell: UITableViewCell {
    
    static let identifier = "RecordCell"

    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var paidServiceId: UILabel!
    @IBOutlet weak var doctorId: UILabel!
    @IBOutlet weak var clientId: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    var data: Record! {
        didSet {
            id.text = String(data.id)
            paidServiceId.text = String(data.paidServiceId)
            doctorId.text = String(data.doctorId)
            clientId.text = String(data.clientId)
            dateTime.text = data.dateTime
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
