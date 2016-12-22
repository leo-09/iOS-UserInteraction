//
//  ViewController.swift
//  NewUserNotification
//
//  Created by liyy on 2016/12/22.
//  Copyright © 2016年 liyy. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func sendNotification(_ sender: UIButton) {
        
        // 1. 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "time interval Notification"
        content.body = "my first notification"
        
        // 2. 创建发送触发
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // 3. 发送请求标识符
        let requestIdentifier = "com.liyy.notification"
        
        // 4. 创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 将请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
    }
}

