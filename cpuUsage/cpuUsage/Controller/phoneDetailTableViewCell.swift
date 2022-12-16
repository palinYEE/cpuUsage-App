//
//  phoneDetailTableViewCell.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/12.
//

import UIKit

class phoneDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var Data: UILabel! {
        didSet {
            Data.textColor = .white
        }
    }
    @IBOutlet weak var field: UILabel! {
        didSet {
            field.textColor = .white
        }
    }
}
