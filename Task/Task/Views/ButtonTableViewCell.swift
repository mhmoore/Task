//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var primaryLabel: UILabel!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBAction func buttonTapped(_ sender: ButtonTableViewCell) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    func updateButton(_ isComplete: Bool) {
        if isComplete == false {
            completeButton.setImage(UIImage(named: "incomplete"), for: .normal)
        } else {
            completeButton.setImage(UIImage(named: "complete"), for: .normal)
        }
    }
}

extension ButtonTableViewCell {
    
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}




