//
//  SignUpVC.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-08-04.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import Toast_Swift

class SignUpVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var studentIDTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxtField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxtField.isSecureTextEntry = true
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if !studentIDTxtField.isValidate() {
            studentIDTxtField.errorMessage = "Student ID"
        }
        else if !firstNameTxtField.isValidate() {
            firstNameTxtField.errorMessage = "First Name"
        }
        else if !lastNameTxtField.isValidate() {
            lastNameTxtField.errorMessage = "Last Name"
        }
        else if !emailTxtField.isValidate() {
            emailTxtField.errorMessage = "Email ID"
        }
        else if !passwordTxtField.isValidate() {
            passwordTxtField.errorMessage = "Password"
        }
        else {
            //Sign up
            
            let url = "https://1o739743u5.execute-api.us-east-1.amazonaws.com/getV1/putdyanamodb"
            let param : [String:Any] = [
                "id" : studentIDTxtField.text!,
            ]
            
            AF.request(url, method: .get, parameters: param).responseJSON { result in
                if let value = result.value as? [String:Any] {
                    if value["Count"] as! Int == 0 {
                        //Account Not Found
                        self.signUp()
                    }
                    else if value["Count"] as! Int == 1 {
                        //Account found
                        self.view.makeToast("Account Already Found!...Please Sign In!")
                    }
                }
            }
        }
    }
    
    func signUp() {
        let url = "https://1o739743u5.execute-api.us-east-1.amazonaws.com/v1/putdyanamodb"
        
        let header:HTTPHeaders = [
            "Content-Type" : "application/json",
        ]
        
        let param : [String:String] = [
            "id":studentIDTxtField.text!,
            "first_name":firstNameTxtField.text!,
            "last_name":lastNameTxtField.text!,
            "email":emailTxtField.text!,
            "password":passwordTxtField.text!,
        ]
        
        var request =  URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
        let bodyStr = jsonToString(json: param)
        request.httpBody = bodyStr.data(using: .utf8)
        request.headers = header
        
        AF.request(request).responseJSON { value in
            let result = value.result
            switch result {
            case .success :
                self.dismiss(animated: true, completion: nil)
            case .failure :
                self.view.makeToast("Something went wrong!")
            }
        }
    }
    
    func jsonToString(json:[String:String]) -> String {
        let dic = json
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    
    override func viewDidLayoutSubviews() {
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize.zero
        topView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
