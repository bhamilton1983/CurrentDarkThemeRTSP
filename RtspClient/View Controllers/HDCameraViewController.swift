//
//  HDCameraViewController.swift
//  RtspClient
//
//  Created by Brian Hamilton on 6/5/18.
//  Copyright © 2018 Andres Rojas. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreML
import Vision
import ReplayKit
import QuartzCore

class HDCameraViewController: UIViewController, RPPreviewViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate {
   
    
    @IBOutlet weak var cameraScroll: UIScrollView!
    @IBOutlet weak var controlScroll: UIScrollView!
    
    var identity = CGAffineTransform.identity
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var hideControlViews: UISegmentedControl!
    let recorder = RPScreenRecorder.shared()
    private var isRecording = false
   

    @IBOutlet var HDimageView: UIImageView!
    var video: RTSPPlayer!
    static var timer = Timer()
    @IBOutlet weak var playPause: UIButton!
    static var playRate:Double = 0.0
    var toggleState = 1
    
    @IBOutlet weak var zoomControlContainer: UIView!
    @IBOutlet weak var sideControlContainer: UIView!
    @IBAction func playAction(_ sender: Any) {
        
      
        let normalImage = UIImage(named: "play_active_48.png")
        let selectedImage = UIImage(named: "pause_active_48.png")

        if toggleState == 1 {
            starttime ()
            playPause.isSelected = true
            playPause.isHighlighted = true
            playPause.setImage(normalImage, for: UIControl.State.normal)
            toggleState = 2
        }
            else {
            
            if toggleState == 2 {
                    stoptime()
                    playPause.isSelected = false
                    playPause.isHighlighted = false
                    playPause.setImage(selectedImage, for: UIControl.State.selected)
                    toggleState = 1
                
            }
            
        }
    }

    @IBOutlet weak var videoSaver: UIButton!
    @IBAction func makeVideoFile(_ sender: Any) {
        
     
        
    }
    
 
 
    @IBAction func hideControlChange(_ sender: Any) {
        
        switch hideControlViews.selectedSegmentIndex
        {
        case 0:
        
            zoomControlContainer.isHidden = true
            sideControlContainer.isHidden = true
       
        case 1:
        
            zoomControlContainer.isHidden = false
            sideControlContainer.isHidden = false
        default:
            break
    }
    }
 
    @IBOutlet weak var savePhoto: UIButton!
    
    
    @IBOutlet weak var classificationLabel: UILabel!
    
    @IBOutlet weak var classificationButton: UIButton!
    
    @IBAction func classificationActionButton(_ sender: Any) {
        
        classificationProcess(video.currentImage)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         
        video = RTSPPlayer(video: "\(Login.rtsp)", usesTcp: false)
        video.outputWidth = Int32(1920)
        video.outputHeight = Int32(1080)
        video.seekTime(0.0)
    //set up scroll layer
       let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
       let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let pinchGesture1 = UIPinchGestureRecognizer(target: self, action: #selector(scale1))
        let rotationGesture1 = UIRotationGestureRecognizer(target: self, action: #selector(rotate1))
        let gestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(handlePan1))
       gestureRecognizer1.delegate = self
      pinchGesture1.delegate = self
      rotationGesture1.delegate = self
       gestureRecognizer.delegate = self
      pinchGesture.delegate = self
       rotationGesture.delegate = self
       controlScroll.minimumZoomScale = 0.5
     controlScroll.maximumZoomScale = 10.0
     controlScroll.zoomScale = 1.0
       cameraScroll.minimumZoomScale = 0.5
      cameraScroll.maximumZoomScale = 10.0
      cameraScroll.zoomScale = 1.0
       cameraScroll.addGestureRecognizer(pinchGesture)
       cameraScroll.addGestureRecognizer(rotationGesture)
      cameraScroll.addGestureRecognizer(gestureRecognizer)
     cameraScroll.addSubview(HDimageView)
      cameraScroll.addSubview(controlScroll)
       controlScroll.addSubview(zoomControlContainer)
       controlScroll.addSubview(sideControlContainer)
      controlScroll.addGestureRecognizer(pinchGesture1)
     controlScroll.addGestureRecognizer(rotationGesture1)
     controlScroll.addGestureRecognizer(gestureRecognizer1)
      controlScroll.layer.borderWidth = 1
   controlScroll.layer.borderColor = UIColor.black.cgColor
//
    }
    
    //save photo to camera roll
    @IBAction func savePhotoTapped(_ sender: Any) {
       
        
        let imageRepresentation = HDimageView.image!.pngData()
        let imageData = UIImage(data: imageRepresentation!)
        UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
  
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        cameraScroll.transform = cameraScroll.transform.rotated(by: gesture.rotation)

    }
    @objc func rotate1(_ gesture: UIRotationGestureRecognizer) {
        controlScroll.transform = cameraScroll.transform.rotated(by: gesture.rotation)
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cameraScroll
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer1(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = cameraScroll.transform
        case .changed,.ended:
           cameraScroll.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    @objc func scale1(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = controlScroll.transform
        case .changed,.ended:
           controlScroll.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: cameraScroll)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: cameraScroll)
        }
    }
    @IBAction func handlePan1(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: controlScroll)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: controlScroll)
        }
    }
        func starttime () {
            
            HDCameraViewController.timer = Timer.scheduledTimer(timeInterval: HDCameraViewController.playRate, target: self, selector: #selector( HDCameraViewController.update), userInfo: nil, repeats: true)
                HDCameraViewController.timer.fire()
        }
        
        func stoptime () {
            
            HDCameraViewController.timer.invalidate()
        }


    @objc func update(timer: Timer) {
        if(!video.stepFrame()){
            timer.invalidate()
            video.closeAudio()
        }
     
        HDimageView.image = video.currentImage
     
    
    }

    
    
    
    
    

    
    
    
    
    
    
    func classificationProcess(_ image: UIImage) {
        HDimageView.image = image
        
        guard let pixelBuffer = image.pixelBuffer(width: 299, height: 299) else {
            return
        }
        //I have `Use of unresolved identifier 'Inceptionv3'` error here when I use New Build System (File > Project Settings)   ¯\_(ツ)_/¯
        let model = Inceptionv3()
        do {
            let output = try model.prediction(image: pixelBuffer)
            let probs = output.classLabelProbs.sorted { $0.value > $1.value }
            if let prob = probs.first {
                classificationLabel.text = "\(prob.key) \(prob.value)"
            }
        }
        catch {
            self.presentAlertController(withTitle: title,
                                        message: error.localizedDescription)
        }
    }
   
  
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
