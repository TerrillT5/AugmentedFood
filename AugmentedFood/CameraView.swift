//
//  CameraView.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 9/21/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.

// ask to store image in photo library
// store photo reference in core data & what the name of the image was
// try to edit a photo in the app 


import UIKit
import AVKit
import Vision
import ARKit
import Photos
class CameraView: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, ARSKViewDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imageSession = AVCaptureSession()
    let imageOutput = AVCapturePhotoOutput()
    var error: NSError?
    var flashModeOff = AVCaptureDevice.FlashMode.off
    var flashModeOn = AVCaptureDevice.FlashMode.on
    
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
//    if sampleBuffer != nil {
//       let imageData = AVCaptureIma
    
//    }
    
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
 
        let theImageView: UIImageView = {
            let pictureView = UIImageView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            pictureView.frame = view.bounds
            view.addSubview(classifierText)
            return pictureView
        }()
        
        let cameraButton: UIButton = {
            let takePicture = UIButton()
            takePicture.translatesAutoresizingMaskIntoConstraints = false
            takePicture.backgroundColor = .white
            takePicture.image(for: .normal)
            return takePicture
        }()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
//            self.presentationController(imagePicker,dismiss(animated: true, completion: nil))
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
       
        let imageViewTopAnchor = theImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let imageViewRightAnchor = theImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5)
        let imageViewLeftAnchor = theImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        let imageViewWidthAnchor = theImageView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        let imageViewHeightAnchor = theImageView.heightAnchor.constraint(equalToConstant: 50)
        
        let classifiedTextTopAnchor = classifierText.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let classifiedTextRightAnchor = classifierText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let classifiedTextLeftAnchor = classifierText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let classifiedTextHeightAnchor = classifierText.heightAnchor.constraint(equalToConstant: 35)

        view.addSubview(theImageView)
        NSLayoutConstraint.activate([classifiedTextTopAnchor,classifiedTextRightAnchor,classifiedTextLeftAnchor,classifiedTextHeightAnchor,
                                      imageViewTopAnchor,imageViewRightAnchor ,imageViewLeftAnchor,imageViewWidthAnchor, imageViewHeightAnchor])
    }
    @objc func stopCamera() {
        imageSession.stopRunning()
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        let alertController = UIAlertController(title: "Alert", message: "Would you like to save photo to library?", preferredStyle: UIAlertControllerStyle.alert)
        let savePhoto = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(savePhoto)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
}



