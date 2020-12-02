//
//  HistoryCellTableViewCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 28.11.20.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let identifier: String = "HistoryCell"
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var paidServiceName: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var data: History! {
        didSet {
            id.text = String(data.id)
            clientName.text = data.clientName
            paidServiceName.text = data.paidServiceName
            cost.text = String(data.cost)
            date.text = data.dateTime
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
