//
//  network.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/17.
//

struct interfaceInfo {
    var interfaceName: String
    var ipv4: String?
    var ipv6: String?
    var existIPv4: Bool
    var existIPv6: Bool
    
    init(interfaceName: String, ipv4: String? = nil, ipv6: String? = nil, existIPv4: Bool, existIPv6: Bool) {
        self.interfaceName = interfaceName
        self.ipv4 = ipv4
        self.ipv6 = ipv6
        self.existIPv4 = existIPv4
        self.existIPv6 = existIPv6
    }

}
