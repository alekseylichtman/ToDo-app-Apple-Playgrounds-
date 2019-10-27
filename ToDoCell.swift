//
//  ToDoCell.swift
//  List
//
//  Created by Oleksii Kolakovskyi on 10/17/19.
//  Copyright © 2019 Aleksey. All rights reserved.
//

import UIKit

protocol ToDoCellDelegate: class {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    // Outlet
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toDoDueDate: UILabel!
    
    // Actions
    @IBAction func completeButtonTapped(_ sender: Any) {

        delegate?.checkmarkTapped(sender: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Variables
    var delegate: ToDoCellDelegate?

    // Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
