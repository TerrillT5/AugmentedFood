//
//  CameraView.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 9/21/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.
//

import UIKit
import AVKit
import Vision
import ARKit

/// https://www.appcoda.com/coreml-introduction/ 9/4/17
/// change it to a live camera if i can

// WATCH THIS FOR CUSTOM CAMERA https://www.youtube.com/watch?v=Zv4cJf5qdu0 9/7/17
class CameraView: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, ARSKViewDelegate, UINavigationControllerDelegate {
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    let barCodeDetector = VNDetectBarcodesRequest()
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model =  try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as?  [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            print(firstObservation.identifier,firstObservation.confidence)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        previewView = UIView(frame: CGRect(x: 0,
        //                                           y: 0,
        //                                           width: UIScreen.main.bounds.size.width,
        //                                           height: UIScreen.main.bounds.size.height))
        //        previewView.contentMode = UIViewContentMode.scaleAspectFit
        //        view.addSubview(previewView)
        //
        //        boxView = UIView(frame: self.view.frame)
        //        view.addSubview(boxView)
        //        self.setupAVCapture()
        
        let classifierText: UILabel = {
            let classifier = UILabel()
            classifier.translatesAutoresizingMaskIntoConstraints = false
            classifier.text = "This appears to be a \(barCodeDetector)"
            classifier.textColor = .black
            classifier.font = UIFont(name: "Times-New-Roman", size: 10)
            classifier.textAlignment = .center
            return classifier
        }()
        //        let imageView: UIImageView = {
        //            let image = UIImageView()
        //            image.translatesAutoresizingMaskIntoConstraints = false
        //            UIGraphicsBeginImageContext(CGSize(width:  299, height: 299))
        //            return image
        //        }()
        let imageSession = AVCaptureSession()
        imageSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        imageSession.addInput(input)
        imageSession.startRunning()
        
        var previewLayer: AVCaptureVideoPreviewLayer?
        previewLayer = AVCaptureVideoPreviewLayer(session: imageSession)
        previewLayer?.frame = view.bounds
        //        previewLayer.frame =  CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 350) \\\\ *************
        view.layer.addSublayer(previewLayer!)
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        imageSession.addOutput(dataOutput)
        //
        let classifiedTextTopAnchor = classifierText.topAnchor.constraint(equalTo: view.topAnchor, constant: 500)
        let classifiedTextRightAnchor = classifierText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let classifiedTextLeftAnchor = classifierText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let classifiedTextHeightAnchor = classifierText.heightAnchor.constraint(equalToConstant: 35)
        
        
        //        view.addSubview(imageView)
        view.addSubview(classifierText)
        NSLayoutConstraint.activate([classifiedTextTopAnchor,classifiedTextRightAnchor,classifiedTextLeftAnchor,
                                     classifiedTextHeightAnchor])
        
    }
}
