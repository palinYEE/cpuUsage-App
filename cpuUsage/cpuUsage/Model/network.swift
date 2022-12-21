//
//  network.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/17.
//

struct interfaceDatas {
    var count: Int = 0
    var data: [interfaceData] = []
    var isExpended: Bool = false
    
    init(count: Int, data: [interfaceData]) {
        self.count = count
        self.data = data
        self.isExpended = false
    }
}

struct interfaceData {
    var interfaceName: String
    var interface: [interfaceInfo] = []
    var isExpended: Bool = false
    
    init(interfaceName: String, interface: [interfaceInfo]) {
        self.interfaceName = interfaceName
        self.interface = interface
    }
}

struct interfaceInfo {
    var ipv4: String?
    var ipv6: String?
    var existIPv4: Bool
    var existIPv6: Bool
    var isExpended: Bool = false
    
    init(ipv4: String? = nil, ipv6: String? = nil, existIPv4: Bool, existIPv6: Bool) {
        self.ipv4 = ipv4
        self.ipv6 = ipv6
        self.existIPv4 = existIPv4
        self.existIPv6 = existIPv6
        self.isExpended = false
    }

}
