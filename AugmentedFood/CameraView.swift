//
//  CameraView.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 9/21/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.

// ask to store image in photo library
// store photo reference in core data & what the name of the image was

import UIKit
import AVKit
import Vision
import Photos

class CameraView: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate {
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imageSession = AVCaptureSession()
    let imageOutput = AVCapturePhotoOutput()
    var photoSettings = AVCapturePhotoSettings()
    
    private enum sessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var setupResult: sessionSetupResult = .success
    


//    let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
//    guard let cameras = (session?.devices.flatMap {$0}), cameras.isEmpty else { throw CameraViewError.noCamerasAvailable }

    
    let classifierText: UILabel = {
        let classifer = UILabel()
        classifer.translatesAutoresizingMaskIntoConstraints = false
        classifer.textColor = .black
        classifer.font = UIFont(name: "Times-New-Roman", size: 10)
        classifer.textAlignment = .center
        return classifer
    }()
    
   func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
        guard let results = finishedReq.results as?  [VNClassificationObservation] else { return }
        guard let firstObservation = results.first else { return }
        DispatchQueue.main.async {
        self.classifierText.text = "This appears to be a \(firstObservation.identifier)"
         }
      }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
      }
       init() {
        super.init(nibName: nil, bundle: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self,
                                         action: #selector(stopCamera))
        self.navigationItem.rightBarButtonItem = doneButton
        view.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let theView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.frame = view.bounds
            view.addSubview(classifierText)
            return view
        }()
        // https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
        let cameraButton: UIButton = {
            let takePicture = UIButton()
            takePicture.translatesAutoresizingMaskIntoConstraints = false
            takePicture.setTitle("Take Image", for: .normal)
            takePicture.setTitleColor(.white, for: .normal)
            takePicture.image(for: .normal)
            takePicture.backgroundColor = .blue
            takePicture.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
            return takePicture
        }()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access has not been granted
            break
        case .notDetermined:
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            if !granted {
               self.setupResult = .notAuthorized
            }
           self.sessionQueue.resume()
        })
          default:
             setupResult = .notAuthorized
        }
    
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        imageSession.addInput(input)
        imageSession.startRunning()
        previewLayer = AVCaptureVideoPreviewLayer(session: imageSession)
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        imageSession.addOutput(dataOutput)
       
        let textViewTopAnchor = theView.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let textViewRightAnchor = theView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2)
        let textViewLeftAnchor = theView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 2)
        let textViewWidthAnchor = theView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        let textViewHeightAnchor = theView.heightAnchor.constraint(equalToConstant: 50)
        
        let cameraButtonTopAnchor = cameraButton.topAnchor.constraint(equalTo: classifierText.topAnchor , constant: -40)
        let cameraButtonRightAnchor = cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let cameraButtonLeftAnchor = cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        let cameraButtonHeightAnchor = cameraButton.heightAnchor.constraint(equalToConstant: 35)
        
        let classifiedTextTopAnchor = classifierText.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let classifiedTextRightAnchor = classifierText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let classifiedTextLeftAnchor = classifierText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let classifiedTextHeightAnchor = classifierText.heightAnchor.constraint(equalToConstant: 35)
        
        cameraButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        view.addSubview(theView)
        view.addSubview(cameraButton)
        NSLayoutConstraint.activate([classifiedTextTopAnchor,classifiedTextRightAnchor,classifiedTextLeftAnchor,classifiedTextHeightAnchor,
                                     textViewTopAnchor,textViewRightAnchor,textViewLeftAnchor,textViewWidthAnchor,textViewHeightAnchor,
                                     cameraButtonTopAnchor,cameraButtonRightAnchor,cameraButtonLeftAnchor,cameraButtonHeightAnchor])
       }
    
        // takes picture of image from the incorrect view 
        @objc func takePhoto() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
    }

    // https://stackoverflow.com/questions/28137259/create-an-uialertaction-in-swift
    @objc func stopCamera() {
        imageSession.stopRunning()
//        imageOutput.capturePhoto(with: AVCapturePhotoOutput, delegate: self as! AVCapturePhoto)
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        let alertController = UIAlertController(title: "Alert", message: "Would you like to save image to library?", preferredStyle: UIAlertControllerStyle.alert)
        let savePhoto = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
//        UIImageWriteToSavedPhotosAlbum(imageSession, nil, nil, nil)
        
        alertController.addAction(savePhoto)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
}

//https://github.com/search?q=swift+navigation+controller+programmatically+&type=Issues&utf8=%E2%9C%93





