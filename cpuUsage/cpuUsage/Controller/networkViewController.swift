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
    var tableViewInterfaceData: [Any] = []
    
    fileprivate func networkTableViewLoad() {
        self.networkTableView.dataSource = self
        self.networkTableView.delegate = self
    }

    override func viewDidLoad() {
        self.interfaceInfoData = getIpAddress()
        self.tableViewInterfaceData.append(self.interfaceInfoData as Any)
        if interfaceInfoData == nil {
            print("[error] no interface data ")
        }
        networkTableViewLoad()
        super.viewDidLoad()
    }
}

extension networkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewInterfaceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: networkTableViewCell?
        let member = self.tableViewInterfaceData[indexPath.row]
        
        if let level1 = member as? interfaceDatas {
            cell = (tableView.dequeueReusableCell(withIdentifier: "networkCellLevel1", for: indexPath) as! networkTableViewCell)
            cell?.networkField.text = "Interface Total Count"
            cell?.networkData.text = String(level1.count)
        } else if let level2 = member as? interfaceData {
            cell = (tableView.dequeueReusableCell(withIdentifier: "networkCellLevel2", for: indexPath) as! networkTableViewCell)
            cell?.networkField.text = "\(level2.interfaceName)"
            cell?.networkData.text = String(level2.interface.count)
            
        } else if let level3 = member as? interfaceInfo {
            cell = (tableView.dequeueReusableCell(withIdentifier: "networkCellLevel3", for: indexPath) as! networkTableViewCell)
            if level3.existIPv4 {
                cell?.networkField.text = "IPv4"
                cell?.networkData.text = level3.ipv4
            } else if level3.existIPv6 {
                cell?.networkField.text = "IPv6"
                cell?.networkData.text = level3.ipv6
            } else {
                cell?.networkField.text = "error"
                cell?.networkData.text = "error"
            }
            
        } else {
            return UITableViewCell()
        }
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
             networkCellLevel1 : 전체 interface 개수
             networkCellLevel2 : 인터페이스 별 개수
             networkCellLevel3 : 각 인터페이스의 세부 정보
         */
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let member = self.tableViewInterfaceData[row]
        var ipsArr: [IndexPath] = []
        if var level1 = member as? interfaceDatas {
            if !level1.isExpended {
                for (index, value) in level1.data.enumerated() {
                    self.tableViewInterfaceData.insert(value, at: row + index + 1)
                    let ip = IndexPath(row: row + index + 1, section: 0)
                    ipsArr.append(ip)
                }
                level1.isExpended = true
                self.tableViewInterfaceData[row] = level1
                tableView.beginUpdates()
                tableView.insertRows(at: ipsArr, with: .left)
                tableView.endUpdates()
            } else {
                level1.isExpended = false
                for i in 1..<self.tableViewInterfaceData.count {
                    self.tableViewInterfaceData.remove(at: row + 1)
                    let ip = IndexPath(row: row + i, section: 0)
                    ipsArr.append(ip)
                }
                self.tableViewInterfaceData[row] = level1
                tableView.beginUpdates()
                tableView.deleteRows(at: ipsArr, with: .right)
                tableView.endUpdates()
            }
        } else if var level2 = member as? interfaceData {
            if !level2.isExpended {
                for (index, value) in level2.interface.enumerated() {
                    self.tableViewInterfaceData.insert(value, at: row + index + 1)
                    let ip = IndexPath(row: row + index + 1, section: 0)
                    ipsArr.append(ip)
                }
                level2.isExpended = true
                self.tableViewInterfaceData[row] = level2
                tableView.beginUpdates()
                tableView.insertRows(at: ipsArr, with: .left)
                tableView.endUpdates()
            } else {
                level2.isExpended = false
                for i in 0..<level2.interface.count {
                    self.tableViewInterfaceData.remove(at: row + 1)
                    let ip = IndexPath(row: row + i + 1, section: 0)
                    ipsArr.append(ip)
                }
                self.tableViewInterfaceData[row] = level2
                tableView.beginUpdates()
                tableView.deleteRows(at: ipsArr, with: .right)
                tableView.endUpdates()
            }
           
        }
    }
    
    
}
