//
//  ViewController.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/11.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var monitorTableView: UITableView!
    var resourceData: resourceModel = .init(cpuInfo: "", memoryInfo: "")
    
    var timer: Timer?
    var timerNum: Int = 0
    
    fileprivate func loadTableView() {
        self.monitorTableView.dataSource = self
        self.monitorTableView.delegate = self
    }
    
    
    func Output_Alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)

    }
    
    var memoryUsage: String {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        let total = ProcessInfo.processInfo.physicalMemory
        let bytesInMegabyte = 1024.0 * 1024.0
        let usedMemory: Double = Double(used) / bytesInMegabyte
        let totalMemory: Double = Double(total) / bytesInMegabyte
        return String(format: "%.1f MB / %.0f MB", usedMemory, totalMemory)
    }
    
    func startTimer() {
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        timerNum = 1
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(reloadData), userInfo: nil, repeats: true)
        
    }
    
    @objc func reloadData() {
        self.resourceData.cpuInfo = self.cpuUsage
        self.resourceData.memoryInfo = self.memoryUsage
        self.monitorTableView.reloadData()
    }

    var cpuUsage: String {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return String(format: "%.1f%%", totalUsageOfCPU)
    }
    
//  phoneDetailInfoViewController 에 데이터를 전달하고 싶으면 아래 코드를 사용하세요
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? phoneDetailInfoViewController, let indexPath = monitorTableView.indexPathForSelectedRow {
//
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func timerStart(_ sender: Any) {
        Output_Alert(title: "알림", message: "타이머를 시작합니다.", text: "확인")
        startTimer()
    }
    
    @IBAction func timerEnd(_ sender: Any) {
        Output_Alert(title: "알림", message: "타이머를 멈춥니다.", text: "확인")
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceModel.init(cpuInfo: "", memoryInfo: "").fieldNum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceTableViewCell", for: indexPath) as! resourceTableViewCell
            
        switch indexPath.row {
        case 0:
            cell.resourceFieldText.text = "MODEL"
            cell.resourceDataText.text = resourceModel.init(cpuInfo: "", memoryInfo: "").modelName
        case 1:
            cell.resourceFieldText.text = "CPU USAGE"
            cell.resourceDataText.text = self.resourceData.cpuInfo
            break
        case 2:
            cell.resourceFieldText.text = "MEMORY USAGE"
            cell.resourceDataText.text = self.resourceData.memoryInfo
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "detailPhoneInfo", sender: nil)
        } else {
            if let viewWithTag = self.view.viewWithTag(toastTagValue){
                viewWithTag.removeFromSuperview()
            }
            showToast(self,self.resourceData.helpMessage(indexPath.row), .systemFont(ofSize: 12.0), 200)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

