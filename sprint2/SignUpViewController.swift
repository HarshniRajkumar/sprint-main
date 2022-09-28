//
//  SignUpViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/21/22.
//

import Foundation
import UIKit
import FirebaseAuth
import CoreData


class SignUpViewController: UIViewController {
//outlets connected:
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
 //initializing the alert
    let UserContext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
        var alerts: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //what has to occur when signUp tapped:
    @IBAction func signUpTapped(_ sender: Any) {
        let duplicatemailId = validateEmail(emailText: email.text!)
        let names = validateName(nameText: nameTF.text!)
        let checkemail = validateEmail(emailIdText: email.text!)
        let mobilenumber = validateNumber(mobile: phoneTF.text!)
        let password = validatePassword(passtext: passwordTF.text!)
        let confirmpassword = isPasswordsame(passtext: passwordTF.text!, confirmpasswordtext: passwordTF.text!)
   //when all the error are rectified and the text fields confine to proper login metrices the following occurs:
        if duplicatemailId && names && checkemail && mobilenumber && password && confirmpassword == true {
            let persondetail = Empdetails(context: UserContext)
            persondetail.name = nameTF.text
            persondetail.password = passwordTF.text
            persondetail.phoneNumber = confirmPassword.text
            persondetail.emailtext = email.text
    // do and catch used to save data and identify error:
            do{
            try self.UserContext.save()
        }
        catch(let error){
            print(error.localizedDescription)
        }
        }
        //email and password text fields initialization for authentication purposes:
        let email : String = email.text!
        let passwd : String = passwordTF.text!
        registerUser(emailId: email, password: passwd)
   }
    
    //func to denote and enable user login using firebase authentication:
    func registerUser(emailId: String, password: String) {
        Auth.auth().createUser(withEmail: emailId, password: password, completion: {
            (result, error)-> Void in
            if let error = error {
                print(error.localizedDescription)
    }
            else{
                print("Registered Successfully!")
            }
    }
        
        )}
        //func to show alert messages
    func showAlertmsgs(){
        guard alerts.count > 0 else{return }
        let alertmessage = alerts.first
        //func to remove alert msgs:
        func removeAlertmsgs(){
            
            self.alerts.removeFirst()
            self.showAlertmsgs()
        }
        let alertController = UIAlertController(title: "Incorrect", message: alertmessage, preferredStyle: .alert)
        alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController.addAction(UIAlertAction(title:"ok", style:.default){
            (action) in removeAlertmsgs()
        })
        self.present(alertController, animated: true)
    }
    //email validation:
    func validateEmail(emailText: String)->Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 != 0}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Empdetails> = Empdetails.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", argumentArray: ["emailtext", emailText])
        // do and catch to rectify errors:
        var result: [NSManagedObject] = []
        do{
            result = try context.fetch(request)
            
            if result.count == 1 {
                alerts.append("Email id already exist")
                showAlertmsgs()
            }
        }
        catch(let error){
            print(error.localizedDescription)
        }
        return result.count == 0
    }
    
    //name validation:
    func validateName(nameText: String)-> Bool
    {
        var res: Bool = false
        let regex = "^[A-Za-z]{4,15}$"
        do{
            let expression = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let validName = expression.firstMatch(in: nameText, options: [], range: NSRange(location: 0, length: nameText.count)) != nil
            if validName{
                res = true
            }
            else{
                alerts.append("Name is invalid")
            showAlertmsgs()
            }
        }
        catch (let error){
            print(error.localizedDescription)
        }
         return res
        }
    //validate email regex to if the user gives proper mail id:
    func validateEmail(emailIdText: String)-> Bool{
        var result : Bool = false
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z-z0-9.-]+\\.[A-Za-z]{2,64}"
        do{
            let exp = try NSRegularExpression(pattern : regex, options: [.caseInsensitive])
            let validateEmail = exp.firstMatch(in: emailIdText, options: [], range: NSRange(location: 0, length: emailIdText.count)) != nil
            
            if validateEmail{
                result = true
            }
            else{
                alerts.append("Email is invalid")
                showAlertmsgs()
            }
        }
        catch( let error)
        {
            print(error.localizedDescription)
        }
        return result
    }
    
    //func to validate the user mobile number based on regex
    func validateNumber(mobile: String)-> Bool{
        var result : Bool = false
        let regex = "^[0-9]{10}$"
        do{
            let exp = try NSRegularExpression(pattern: regex)
            let validateMobileNumber = exp.firstMatch(in: mobile, options: [], range: NSRange(location: 0, length: mobile.count)) != nil
            if validateMobileNumber{
                result = true
            }
            else{
                alerts.append("phone number is invalid")
                showAlertmsgs()
            }
        }
        catch(let error){
            print(error.localizedDescription)
        }
        return result
    }
    
    //func to validate password based on the following regex
    func validatePassword(passtext: String) -> Bool{
        let regex = "^(?=.*[A-Z])(?=.*[$@$#!%?&])(?=.*[0-9])(?=.*[a-z]).{6,15}$"
        
        let validPassword = NSPredicate(format: "SELF MATCHES %@", regex)
        return validPassword.evaluate(with: passtext)
        
    }
    
    //func to confirm whether both the passwords match:
    func isPasswordsame(passtext: String, confirmpasswordtext: String)-> Bool{
        var result : Bool = false
    
        if passtext == confirmpasswordtext  && passtext.count > 0  {
            result = true
            print("Password approved")
        }
        else{
            alerts.append("Confirm Password does not match")
            showAlertmsgs()
        }
        return result
    }
}
    
