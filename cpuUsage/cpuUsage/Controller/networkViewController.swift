//
//  networkViewController.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/17.
//

import UIKit

class networkViewController: UIViewController {

    @IBOutlet weak var networkTableView: UITableView!
    fileprivate var interfaceInfoData: interfaceDatas?
    fileprivate var multiTableViewFlagTest: Bool = false
    
    fileprivate func networkTableViewLoad() {
        self.networkTableView.dataSource = self
        self.networkTableView.delegate = self
    }

    override func viewDidLoad() {
        interfaceInfoData = getIpAddress()
        if interfaceInfoData == nil {
            print("[error] no interface data ")
        }
        print(interfaceInfoData)
        networkTableViewLoad()
        super.viewDidLoad()
    }
}

extension networkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "networkTableViewCell", for: indexPath) as! networkTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.networkField.text = "Interface"
            cell.networkData.text = String(interfaceInfoData?.count ?? 0)
            break
        default:
            cell.networkField.text = "field"
            cell.networkData.text = "data"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* TEST */
        if !self.multiTableViewFlagTest {
            self.multiTableViewFlagTest = true
            tableView.beginUpdates()
            tableView.insertRows(at:[IndexPath(row: indexPath.row + 1, section: 0)], with: .left)
            tableView.endUpdates()
        } else {
            self.multiTableViewFlagTest = false
            tableView.beginUpdates()
            tableView.deleteRows(at:[IndexPath(row: indexPath.row + 1, section: 0)], with: .right)
            tableView.endUpdates()
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
