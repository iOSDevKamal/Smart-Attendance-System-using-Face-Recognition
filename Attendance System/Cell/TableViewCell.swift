//
//  TableViewCell.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-08-04.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
