//
//  AppDelegate.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-07-25.
//

import UIKit
import AWSS3
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        
        initializeS3()
        
        return true
    }
    
    func initializeS3() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
           identityPoolId:"us-east-1:dbaa4f7c-5b17-4f88-9307-5a3fbe5485a0")

        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
}

