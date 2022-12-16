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
