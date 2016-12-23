//
//  AppDelegate.swift
//  NewUserNotification
//
//  Created by liyy on 2016/12/22.
//  Copyright © 2016年 liyy. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            // Use UserNotification
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                // 用户允许进行通知
                application.registerForRemoteNotifications()
            }
        }
        registerNotificationCategory()
        
        return true
    }
    
    private func registerNotificationCategory() {
        let sayCategory: UNNotificationCategory = {
            
            let inputAction = UNTextInputNotificationAction(
                identifier: "action.input",
                title:"Input",
                options: [.foreground],
                textInputButtonTitle: "Send",
                textInputPlaceholder: "what do you want to say")
            
            let goodbyeAction = UNNotificationAction(
                identifier: "action.goodbye",
                title:"Goodbye",
                options: [.foreground])
            
            let cancelAction = UNNotificationAction(
                identifier: "cancel",
                title:"cancel",
                options: [.foreground])
            
            return UNNotificationCategory(identifier: "sayCategory", actions: [inputAction, goodbyeAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
        }()
        
        UNUserNotificationCenter.current().setNotificationCategories([sayCategory])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.hexString
        print("device token: \(tokenString)")
    }
    
    // UNUserNotificationCenterDelegate
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        completionHandler([.alert, .badge, .sound])
        print(" ===   response is \(response)");
    }

}

extension Data {
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
}
