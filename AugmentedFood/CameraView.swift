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

class CameraView: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate, ARSKViewDelegate, UINavigationControllerDelegate {
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    let imageSession = AVCaptureSession()

    let classifierText: UILabel = {
        let classifer = UILabel()
        classifer.translatesAutoresizingMaskIntoConstraints = false
        classifer.textColor = .black
        classifer.font = UIFont(name: "Times-New-Roman", size: 10)
        classifer.textAlignment = .center
        return classifer
    }()
  
internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let model =  try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
        guard let results = finishedReq.results as?  [VNClassificationObservation] else { return }
        guard let firstObservation = results.first else { return }
        DispatchQueue.main.async {
          self.classifierText.text = "This appears to be a \(firstObservation.identifier as String)"
             }
    }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target:#selector(stopCamera), action:"Done")
        navigationItem.rightBarButtonItem = doneButton
        
        
        view.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target:#selector(stopCamera), action:"Done")
//        navigationItem.rightBarButtonItem = doneButton
//        imageSession.sessionPreset = .photo
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
        
        let classifiedTextTopAnchor = classifierText.topAnchor.constraint(equalTo: view.topAnchor, constant: 500)
        let classifiedTextRightAnchor = classifierText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let classifiedTextLeftAnchor = classifierText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let classifiedTextHeightAnchor = classifierText.heightAnchor.constraint(equalToConstant: 35)
        
        view.addSubview(classifierText)
        NSLayoutConstraint.activate([classifiedTextTopAnchor,classifiedTextRightAnchor,classifiedTextLeftAnchor,
                                     classifiedTextHeightAnchor])
    }
    
    @objc func stopCamera() {
        imageSession.stopRunning()
        
        
        
    }
    
    
}
