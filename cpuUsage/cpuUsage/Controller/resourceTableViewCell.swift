//
//  resourceTableViewCell.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/11.
//

import UIKit

class resourceTableViewCell: UITableViewCell {
    @IBOutlet weak var resourceFieldText: UILabel! {
        didSet {
            resourceFieldText.textColor = .white
        }
    }
    @IBOutlet weak var resourceDataText: UILabel! {
        didSet {
            resourceDataText.textColor = .white
        }
    }
}
