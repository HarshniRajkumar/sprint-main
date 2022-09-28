//
//  NotificationFile.swift
//  RhNotificationFramework
//
//  Created by Capgemini-DA088 on 9/25/22.
//

import Foundation
import UIKit
import UserNotifications

public class NotificationViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let notificationcenter = UNUserNotificationCenter.current()
    public override func viewDidLoad() {
        super.viewDidLoad()
        notificationcenter.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.notification()
        NotificationCenter.default.addObserver(self, selector: #selector(Loggedin), name: Notification.Name("LoggedIN"), object : nil)
    }
    @objc func Loggedin(_ notification: Notification){
        print("Logged in Error")
    }
    public func replyNotification() {
        UNUserNotificationCenter.current().delegate = self
        //custom action initiated:
        let replyaction = UNNotificationAction(identifier : "replyButton", title: "Reply",options: UNNotificationActionOptions.init(rawValue: 0))
        let markreadaction = UNNotificationAction(identifier: "MarkasReadButton", title: "Mark as Read", options: UNNotificationActionOptions.init(rawValue:0))
        //the notification type is defined:
        let Action = UNNotificationCategory(identifier: "action", actions:[replyaction,markreadaction], intentIdentifiers: [],options: [])
        UNUserNotificationCenter.current().setNotificationCategories([Action])
            }
    
    public func notification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Notification"
        notificationContent.body = "Your order has been placed successfully"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.categoryIdentifier = "action"
        let Dict : [String: String] = ["Red": "Red"]
        
        notificationContent.userInfo = Dict
        replyNotification()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:10, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger)
        notificationcenter.add(request){ (error) in
                if let error = error{
                    print("Notification Error:", error)
                }
            }
        }
    public func action() {
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions)-> Void){
            completionHandler([.banner])
        }
        func usserNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping ()->Void){
            switch response.actionIdentifier{
            case "replyButton":
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Loggedin"), object: nil)
                print("Clicked on reply button")
                break
            case "MarkasReadButton":
                print("Notification message was seen by the user")
                break
            default:
                break
            }
            completionHandler()
        }
        
    }
}
