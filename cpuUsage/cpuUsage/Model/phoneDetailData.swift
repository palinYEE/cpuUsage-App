//
//  phoneDetailData.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/12.
//

import UIKit

struct phoneDetail {
    var phone_name: String                  /* 핸드폰 기종 */
    var host_name: String                   /* 기종 닉네임 */
    var ios_version: String                 /* ios version */
    var uuid: String                        /* uuid */
    var processor_count: Int             /* 프로세스 전체 코어 */
    var active_processor_count: Int      /* 프로세스 활성 코어 */
    var physical_memory: UInt64             /* 물리 메모리 (byte 기준)*/
    var uptime: TimeInterval                      /* uptime */
    
    init() {
        self.phone_name = UIDevice.modelName
        self.host_name = ProcessInfo.processInfo.hostName
        self.ios_version = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        self.uuid = UIDevice.current.identifierForVendor!.description
        self.processor_count = ProcessInfo.processInfo.processorCount
        self.active_processor_count = ProcessInfo.processInfo.activeProcessorCount
        self.physical_memory = ProcessInfo.processInfo.physicalMemory
        self.uptime = ProcessInfo.processInfo.systemUptime
    }
    
    func calculatorTime() -> String {
        let uptime: Int = Int(self.uptime)
        let hours: Int = Int( uptime / (60 * 60))
        let minutes: Int = Int((uptime - (60 * 60 * hours)) / 60)
        let seconds: Int = (uptime - (60 * 60 * hours) - (60 * minutes))
        
        return "\(hours) hours \(minutes) minutes \(seconds) seconds"
    }
    /*
     1 기기 모델 명을 의미합니다.
     2 기기 닉네임을 의미합니다.
     3 기기 OS 버전을 의미합니다.
     4 기기 고유 ID 값을 의미합니다.
     5 CPU 사용 코어 개수를 의미합니다. (활성화/전체)
     6 기기 전체 메모리 크기를 의미합니다.
     7 기기 처음 부팅 부터 현재까지 시간을 의미합니다.
     */
    func helpMessage(_ field: Int) -> (String, Int) {
        switch field {
        case 0:
            return ("기기 모델명을 의미합니다.", 200)
        case 1:
            return ("기기 닉네임을 의미합니다.", 200)
        case 2:
            return ("기기 OS 버전을 의미합니다.", 200)
        case 3:
            return ("기기 고유 ID 값을 의미합니다.", 200)
        case 4:
            return ("CPU 사용 코어 개수를 의미합니다. (활성화/전체)", 250)
        case 5:
            return ("기기 전체 메모리 크기를 의미합니다.", 200)
        case 6:
            return ("기기 처음 부팅 부터 현재까지 시간을 의미합니다.", 250)
        default:
            return ("not support information", 0)
        }
    }
    
    func fieldCount() ->Int {
        return 7
    }
}
