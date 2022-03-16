//
//  SignVC.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-08-04.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class SignVC: UIViewController {
    
    @IBOutlet weak var studentIDTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passTxtField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = UserDefaults.standard.value(forKey: "login") as? [String:Any] {
            self.performSegue(withIdentifier: "homeSegue", sender: nil)
        }
        
        self.view.gradient(colors: [UIColor.init(named: "MainColor")!, UIColor.init(named: "SecondaryColor")!])
        
        studentIDTxtField.applyCommonDesign()
        passTxtField.applyCommonDesign()
        passTxtField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        studentIDTxtField.text?.removeAll()
        passTxtField.text?.removeAll()
    }
    
    @IBAction func signINAction(_ sender: Any) {
        if !studentIDTxtField.isValidate() {
            studentIDTxtField.errorMessage = "Student ID / Prof. ID"
        }
        else if !passTxtField.isValidate() {
            passTxtField.errorMessage = "Password"
        }
        else {
            //Sign In
            authentication()
        }
    }
    
    func authentication() {
        let url = "https://1o739743u5.execute-api.us-east-1.amazonaws.com/getV1/putdyanamodb"
        let param : [String:Any] = [
            "id" : studentIDTxtField.text!,
        ]
        
        AF.request(url, method: .get, parameters: param).responseJSON { result in
            if let value = result.value as? [String:Any] {
                if value["Count"] as! Int == 0 {
                    //Account Not Found
                    self.view.makeToast("Account Not Found!")
                }
                else {
                    if let items = value["Items"] as? [[String:Any]] {
                        let item = items[0]
                        if let pass = item["password"] as? [String:Any] {
                            if let passValue = pass["S"] as? String {
                                if passValue == self.passTxtField.text! {
                                    //Login Successfully
                                    self.view.makeToast("Login Successfully!")
                                    
                                    UserDefaults.standard.setValue(item, forKey: "login")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                                }
                                else {
                                    self.view.makeToast("Wrong Password!")
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.view.makeToast("Something Went Wrong!")
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.performSegue(withIdentifier: "singUpSegue", sender: nil)
    }
}
