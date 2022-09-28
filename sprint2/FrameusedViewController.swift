//
//  FrameusedViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/27/22.
//

import UIKit
import RhNotificationFramework

class FrameusedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickBtn(_ sender: Any) {
    
    
    let notif = NotificationView()
    notif.replyNotification()
    notif.notification()
    notif.action()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
