//
//  networkTableViewCell.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/17.
//

import UIKit

class networkTableViewCell: UITableViewCell {
    @IBOutlet weak var networkData: UILabel! {
        didSet {
            networkData.textColor = .white
        }
    }
    @IBOutlet weak var networkField: UILabel! {
        didSet {
            networkField.textColor = .white
        }
    }
}
