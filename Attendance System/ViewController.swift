//
//  ViewController.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-07-25.
//

import UIKit
import AWSS3
import Warhol
import Alamofire
import SVProgressHUD

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var adminView: UIView!
    @IBOutlet weak var adminViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var studentAdminName: UILabel!
    
    let bucketName = "kamal9797"
    var attendanceDates = [String]()
    var refreshControl = UIRefreshControl()
    var gID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = UIColor.clear
        
        tableView.rowHeight = 50
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableFooterView = UIView()
        
        if let value = UserDefaults.standard.dictionary(forKey: "login") as? [String:Any] {
            let idValue = value["id"] as! [String:Any]
            let id = idValue["S"] as! String
            if id == "00000" {
                adminViewHeightConstant.constant = 50
                nameViewHeightConstant.constant = 0
                self.view.layoutIfNeeded()
            }
            else {
                adminViewHeightConstant.constant = 0
                nameViewHeightConstant.constant = 0
                self.view.layoutIfNeeded()
            }
            let val1 = value["first_name"] as! [String:Any]
            let val2 = value["last_name"] as! [String:Any]
            let first_name = val1["S"] as! String
            let last_name = val2["S"] as! String
            nameLbl.text = "\(first_name) \(last_name)"
            
            gID = id
            getData(id: id)
        }
        else {
            adminViewHeightConstant.constant = 0
            nameViewHeightConstant.constant = 0
            self.view.layoutIfNeeded()
        }
        
        self.view.gradient(colors: [UIColor.init(named: "MainColor")!, UIColor.init(named: "SecondaryColor")!])
    }
    
    @objc func refresh(sender:AnyObject) {
        getData(id: gID)
        refreshControl.endRefreshing()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if searchBar.text!.count > 0 {
            //Do Action
            gID = searchBar.text!
            getData(id: searchBar.text!)
            
            studentAdminName.text = ""
            nameViewHeightConstant.constant = 50
            self.view.layoutIfNeeded()
        }
        else {
            nameViewHeightConstant.constant = 0
            self.view.layoutIfNeeded()
            self.view.makeToast("Enter the Student ID")
        }
    }
    
    //MARK: Searchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            tableView.isHidden = true
            
            nameViewHeightConstant.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func getData(id:String) {

        tableView.isHidden = true
        
        let url = "https://1o739743u5.execute-api.us-east-1.amazonaws.com/getV1/putdyanamodb"
        let param : [String:Any] = [
            "id" : id,
        ]
        
        AF.request(url, method: .get, parameters: param).responseJSON { result in
            if let value = result.value as? [String:Any] {
                if value["Count"] as! Int == 0 {
                    //Account Not Found
                }
                else if value["Count"] as! Int == 1 {
                    //Account found
                    if let items = value["Items"] as? [[String:Any]] {
                        let item = items[0]
                        
                        //Display admin search student name
                        let val1 = item["first_name"] as! [String:Any]
                        let val2 = item["last_name"] as! [String:Any]
                        let first_name = val1["S"] as! String
                        let last_name = val2["S"] as! String
                        self.studentAdminName.text = "Student Name : \(first_name) \(last_name)"
                        
                        
                        if let attendance = item["attendance"] as? [String:Any] {
                            let dates = (attendance["S"] as! String).split(separator: ",")
                            print(dates)
                            
                            self.attendanceDates = dates.map({ dateStr in
                                let isoDate = dateStr
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let date = dateFormatter.date(from:String(isoDate))!
                                print(date)
                                
                                dateFormatter.dateFormat = "dd MMM, yyyy | hh:mm a"
                                let str = dateFormatter.string(from: date)
                                
                                return str
                            })
                            
                            self.attendanceDates = self.attendanceDates.reversed()
                            self.tableView.reloadData()
                            
                            if self.attendanceDates.count > 0 {
                                self.tableView.isHidden = false
                            }
                            else {
                                self.tableView.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let parti = attendanceDates[indexPath.row]
        cell.dateLbl.text = parti
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Date"
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 40))
        headerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        let headerLabel = UILabel(frame: CGRect(x: 80, y: 10, width:
                                                    self.view.frame.width, height: 20))
        headerLabel.font = UIFont(name: "Verdana", size: 14)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Date"
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        let att = UILabel(frame: CGRect(x: self.view.frame.width - 100, y: 10, width:
                                                    self.view.frame.width, height: 20))
        att.font = UIFont(name: "Verdana", size: 14)
        att.textColor = UIColor.white
        att.text = "Attendance"
        att.sizeToFit()
        headerView.addSubview(att)
        
        return headerView
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "login")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.topView.frame
        rectShape.position = self.topView.center
        rectShape.path = UIBezierPath(roundedRect: self.topView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 16, height: 16)).cgPath
        self.topView.layer.mask = rectShape
        
        logoutBtn.layer.cornerRadius = logoutBtn.bounds.height/2
    }
    
    @IBAction func punchInAction(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        SVProgressHUD.show(withStatus: "Progressing...")
        SVProgressHUD.setBackgroundColor(UIColor.init(named: "MainColor")!)
        SVProgressHUD.setForegroundColor(UIColor.white)

        print(image.size)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "image.jpeg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  0.5) {
            do {
                try data.write(to: fileURL)
                print("file saved")
                uploadFile(fileUrl: fileURL, fileName: fileName)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func downloadFiles() {
        
        let fileName = "image.jpeg"
        
        let downloadFilePath = NSTemporaryDirectory().appending(fileName)
        let downloadingFileURL = NSURL.fileURL(withPath: downloadFilePath)
        
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest!.bucket = bucketName
        downloadRequest!.key  = fileName
        downloadRequest!.downloadingFileURL = downloadingFileURL
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager.download(downloadRequest!).continueWith { task in
            DispatchQueue.main.async {
                if task.error != nil {
                    print("Error downloading")
                    
                }
                else {
                    print("Download complete")
                    let image = UIImage(contentsOfFile: downloadFilePath)
                }
            }
            return nil
        }
    }

    func uploadFile(fileUrl: URL, fileName : String) {   //1
        
        let localImageUrl = fileUrl
        
        let request = AWSS3TransferManagerUploadRequest()!
        request.bucket = bucketName
        request.key = fileName
        request.body = localImageUrl
        request.acl = .publicReadWrite
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded")
                
                SVProgressHUD.dismiss {
                    SVProgressHUD.showSuccess(withStatus: "Attedance Recorded Successfully!")
                }
            }
            SVProgressHUD.dismiss()
            return nil
        }
    }
}

