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
        
        let textView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(classifierText)
            return view
        }()
        
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
       
        let textViewTopAnchor = textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let textViewRightAnchor = textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5)
        let textViewLeftAnchor = textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        let textViewWidthAnchor = textView.widthAnchor.constraint(equalToConstant: view.bounds.width)
        let textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: 50)
        
        let classifiedTextTopAnchor = classifierText.topAnchor.constraint(equalTo: view.topAnchor, constant: 620)
        let classifiedTextRightAnchor = classifierText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        let classifiedTextLeftAnchor = classifierText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        let classifiedTextHeightAnchor = classifierText.heightAnchor.constraint(equalToConstant: 35)
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([classifiedTextTopAnchor,classifiedTextRightAnchor,classifiedTextLeftAnchor,classifiedTextHeightAnchor,
                                      textViewTopAnchor,textViewRightAnchor,textViewLeftAnchor,textViewHeightAnchor, textViewWidthAnchor])
    }
    // https://stackoverflow.com/questions/28137259/create-an-uialertaction-in-swift
    @objc func stopCamera() {
        
    }

}

//https://github.com/search?q=swift+navigation+controller+programmatically+&type=Issues&utf8=%E2%9C%93


