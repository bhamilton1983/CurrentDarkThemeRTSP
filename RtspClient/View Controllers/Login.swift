//
//  Login.swift
//  RtspClient
//
//  Created by Brian Hamilton on 6/7/18.
//  Copyright © 2018 Andres Rojas. All rights reserved.
//

import UIKit

class Login: UIViewController {
    
  
    static var username:String = ""
    static var password:String = ""
    static var ip:String = ""
    static var video:String = ""
    static var media:String = ""
    static var rtsp:String = ""
    static var controller:String = ""
    var streamToggle1 = 1
 //  var user = UserProfile(userName: String(username), passWord: String(password), address: String(ip), input: String (videoinput), stream: String(media), RTSPSTREAM: String(rtsp))?
    
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var ipaddress: UITextField!
    
    @IBOutlet weak var compButton: UIButton!
    @IBOutlet weak var inputSelector: UISegmentedControl!
   
    func textFieldShouldReturn(ipaddress: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    @IBAction func inputSegemetSelector(_ sender: Any) {
        switch inputSelector.selectedSegmentIndex
        {
        case 0:
            Login.video = "videoinput_1"
        case 1:
            Login.video = "videoinput_2"
        default:
            break
    }
    
    }
    @IBAction func setCompButton1Tapped(_ sender: Any) {
        
        if streamToggle1 == 1 {
            Login.media = "h264_1"
         compButton.setTitle("H.264", for: UIControl.State.normal)
            streamToggle1 = 2
        } else {
            if streamToggle1 == 2 {
                Login.media = "mjpeg_1"
               compButton.setTitle("MJPEG", for: UIControl.State.normal)
                
                streamToggle1 = 1
    }
    
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
     
    }
    @IBAction func setButtonTapped(_ sender: Any) {
        Login.username = userText.text!
        Login.password = passWord.text!
        Login.ip = ipaddress.text!
      //  Login.video = videoinput.text!
       // Login.media = stream.text!
        Login.rtsp =  "rtsp://\(Login.username):\(Login.password)@\(Login.ip)/\(Login.video)/\(Login.media)/media.stm"
        
        print(Login.rtsp)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
