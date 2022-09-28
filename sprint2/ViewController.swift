//
//  ViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/21/22.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class ViewController: UIViewController {

    //Outlet connections given:
   
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateByFaceTouchID()
        //imageForView.layer.masksToBounds = true
        //imageForView.layer.cornerRadius = imageForView.frame.height / 2
    }
    
    //func for face touch Id:
    func authenticateByFaceTouchID(){
        let context = LAContext()
        var error: NSError?
        
        //providing reason string
        let reasonStr = "Identify yourself"
        
        //analysing the biometrics of the owner user
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonStr){
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                
        //providing if else condition for the authorization:
        if success{
            
            //show alert message
                    self?.showAlert(msgStr: "Authentication done successfully",title: "Success")
                }else{
                    
                }
            }
        }
        }
    
        else{
            
            //show alert message:
            showAlert(msgStr: "No biometric authentication available", title : "Error")
            
        }
    }
    //func to auth passcode:
   /* func passcodeauth(){
        let context: LAContext = LAContext()
        let reason = "Authentication needed to proceed"
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError){
             context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason,
        reply: { success, error in
            if success{
                print("used authenticated")
            }
            else{
                if let error = error {
                    let message = self.showmessageWithErrorCode(errorCode: error as! Int)
                    print(message)
                    
                }
            }
        })
        }
    }
    */
    //func to display Alert message
    func showAlert (msgStr : String, title : String){
        //initialize alert
        let alert = UIAlertController(title: title, message: msgStr, preferredStyle : UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok",style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated:true, completion : nil)
    }
        //func to show mobile passcode
    func showmessageWithErrorCode(errorCode: Int)-> String {
        var msgStr = ""
        switch errorCode{
            //calling local Authentication key words
        case LAError.appCancel.rawValue:
            msgStr = "Authentication was cancelled by the application"
        case LAError.authenticationFailed.rawValue:
            msgStr = "Unable to authenticate the user"
        default :
            msgStr = "common error"
        }
        return msgStr
    }

    
    
    //login tap and further func call and initialization:
    @IBAction func loginTapped(_ sender: Any) {
        let email : String = emailTF.text!
        let pswd : String = passwordTF.text!
        logintap(emailId: email, password: pswd)
    }
    
    //func logintap to understand and implement what happens while the button is tapped:
    func logintap(emailId: String, password: String){
        Auth.auth().signIn(withEmail: emailId, password: password, completion: {
            (result, error) in
            if let error = error{
                print(error.self)
                self.showAlert(msgStr: "Login attempt failed", title: "Retry!")
                
            }else{
                print("Login Successful")
                //self.showAlert(msgStr: "Login successful", title: "Success")
       //navigation:
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                self.navigationController?.pushViewController(vc, animated: true)
          
        }
        }
            )}
    
}
                           
