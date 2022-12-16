//
//  phoneDetailInfoViewController.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/12.
//

import UIKit

class phoneDetailInfoViewController: UIViewController {

    @IBOutlet weak var phoneDetailTableView: UITableView!
    var phoneDetailData: phoneDetail = .init()
    var uptimeTmer: Timer?
    var uptimeString: String = ""
    
    func startUptimeTimer() {
        if uptimeTmer != nil && uptimeTmer!.isValid {
            uptimeTmer!.invalidate()
        }
        uptimeTmer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(reloadTimerData), userInfo: nil, repeats: true)
    }
    
    @objc func reloadTimerData() {
        self.uptimeString = phoneDetail.init().calculatorTime()
        self.phoneDetailTableView.reloadData()
    }
    
    fileprivate func loadTableView() {
        self.phoneDetailTableView.dataSource = self
        self.phoneDetailTableView.delegate = self
    }
    
    override func viewDidLoad() {
        self.title = "Phone Detail Information"
        
        super.viewDidLoad()
        loadTableView()
        startUptimeTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        uptimeTmer?.invalidate()
        uptimeTmer = nil
    }
    
}

extension phoneDetailInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.phoneDetailData.fieldCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneDetailTableViewCell", for: indexPath) as! phoneDetailTableViewCell
        switch indexPath.row {
        case 0:
            cell.field.text = "Device Model"
            cell.Data.text = self.phoneDetailData.phone_name
            break
        case 1:
            cell.field.text = "Device Name"
            cell.Data.text = self.phoneDetailData.host_name
            break
        case 2:
            cell.field.text = "OS Version"
            cell.Data.text = self.phoneDetailData.ios_version
            break
        case 3:
            cell.field.text = "UUID"
            cell.Data.text = self.phoneDetailData.uuid
            break
        case 4:
            cell.field.text = "CPU Core Usage (active/total)"
            cell.Data.text = "\(String(self.phoneDetailData.active_processor_count)) / \(String(self.phoneDetailData.processor_count))"
            break
        case 5:
            cell.field.text = "Memory (GB)"
            cell.Data.text = "\(String(format: "%.2f", Double(self.phoneDetailData.physical_memory) / Double(1000000000))) GB"
            break
        case 6:
            cell.field.text = "Uptime"
            cell.Data.text = uptimeString
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewWithTag = self.view.viewWithTag(toastTagValue) {
                viewWithTag.removeFromSuperview()
        }
        let helpMessage: (String, Int) = self.phoneDetailData.helpMessage(indexPath.row)
        showToast(self, helpMessage.0, .systemFont(ofSize: 12.0), helpMessage.1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
