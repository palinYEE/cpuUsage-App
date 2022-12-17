//
//  utils.swift
//  cpuUsage
//
//  Created by yoon-yeoungjin on 2022/12/14.
//

import UIKit

let toastTagValue:Int = 1000

/*
    그 화면 밑에 작은 버튼 없는 텍스트 알림 창 만드는 코드 - subview 를 통해서 알림.
    우리는 이걸 toast message 라고 하기로 했어요.
 */
func showToast(_ viewController:UIViewController, _ message: String, _ font: UIFont, _ width: Int) {
    let toastLabel = UILabel(frame: CGRect(x: Int(viewController.view.frame.size.width)/2 - width/2, y: Int(viewController.view.frame.size.height) - 100, width: width, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.tag = toastTagValue
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    viewController.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}

func getIpAddress() -> [interfaceInfo]? {
    var result: [interfaceInfo] = []
    
    var address: String?
    
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    print("===================")
    print("* getIpAddress TEST ")
    
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            let name = String(cString: interface.ifa_name)
            // Convert interface address to a human readable string:
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)
            
//            print(name, type(of: name), address, type(of: address))
            
            /* ipv4 */
            if addrFamily == UInt8(AF_INET) {
                result.append(.init(interfaceName: name, ipv4:address, existIPv4: true, existIPv6: false))
            } else {    /* ipv6 */
                result.append(.init(interfaceName: name,ipv6:address , existIPv4: false, existIPv6: true))
            }
            
        }
    }
    freeifaddrs(ifaddr)
    return result
}
