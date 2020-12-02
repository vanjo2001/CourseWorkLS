//
//  PaidServiceCell.swift
//  CourseWork
//
//  Created by IvanLyuhtikov on 18.11.20.
//

import UIKit

class PaidServiceCell: UITableViewCell {
    
    static let identifier = "PaidServiceCell"

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var consultingHoursId: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var data: PaidService! {
        didSet {
            id.text = String(data.id)
            consultingHoursId.text = String(data.consultingHoursId)
            cost.text = String(data.cost)
            info.text = String(data.info)
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
