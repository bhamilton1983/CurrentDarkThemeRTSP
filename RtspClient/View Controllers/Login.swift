//
//  Login.swift
//  RtspClient
//
//  Created by Brian Hamilton on 6/7/18.
//
//

import UIKit

class Login: UIViewController,UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
  
    @IBOutlet var loginScreenMainView: UIView!
    @IBOutlet weak var loginScroll: UIScrollView!
    static var username:String = ""
    static var password:String = ""
    static var ip:String = ""
    static var video:String = ""
    static var media:String = ""
    static var rtsp:String = ""
    static var controller:String = ""
    var streamToggle1 = 1
    var identity = CGAffineTransform.identity
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
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //
        gestureRecognizer.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        //
        loginScroll.minimumZoomScale = 0.5
        loginScroll.maximumZoomScale = 10.0
        loginScroll.zoomScale = 1.0
        loginScroll.layer.cornerRadius = 10
        loginScroll.layer.borderWidth = 1
        loginScroll.layer.borderColor = UIColor.white.cgColor
        loginScroll.addGestureRecognizer(rotationGesture)
        loginScroll.addGestureRecognizer(gestureRecognizer)
        loginScroll.addGestureRecognizer(pinchGesture)
   
    }
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: loginScroll)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: loginScroll)
        }
    }
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = loginScroll.transform
        case .changed,.ended:
            loginScroll.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return loginScroll
    }
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        loginScroll.transform = loginScroll.transform.rotated(by: gesture.rotation)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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

