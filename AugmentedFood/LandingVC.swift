//
//  ViewController.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 9/19/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    var snap: UISnapBehavior!
    var animateLabel: UIDynamicAnimator!
    
    // labels need gravity behavior
    var appName: UILabel = {
        let nameOfApp = UILabel()
        nameOfApp.text = "AR Food"
        nameOfApp.textColor = .blue // change custom text color
        nameOfApp.font = UIFont(name: "Times-New Roman", size: 45)
        nameOfApp.textAlignment = .center
        nameOfApp.translatesAutoresizingMaskIntoConstraints = false
        return nameOfApp
    }()
    //    let appDescription: UILabel = {
    //        let description = UILabel()
    //        description.translatesAutoresizingMaskIntoConstraints = false
    //        description.textColor = .white
    //        description.font = UIFont(name: "Times-New Roman" , size: 15)
    //        description.textAlignment = .center
    //        description.sizeToFit()
    //        description.text = "Focus "
    //        return description
    //    }()
    let nextScreenButton: UIButton = {
        let continueButton = UIButton()
        continueButton.layer.cornerRadius = 10
        continueButton.layer.borderWidth = 1
        //        continueButton.layer.borderColor = UIColor.lightGray.cgColor
        continueButton.layer.shadowColor = UIColor.black.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.5, height: 15)
        continueButton.layer.shadowRadius = 5
        continueButton.layer.shadowOpacity = 0.5
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        return continueButton
    }()
    
    func addedBehavior() {
        for label in appName.text! {
            let animateLabel = UIDynamicAnimator(referenceView: self.view)
            let originalPosition = CGPoint(x: appName.center.x, y: appName.center.y)
            appName.center = CGPoint(x: view.frame.width / 2, y: -view.frame.height)
            snap = UISnapBehavior(item: appName, snapTo: originalPosition)
            snap.damping = 0.5
            animateLabel.addBehavior(snap)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func advanceToNextVC(sender: UIButton) {
        let secondViewController = CameraView()
        secondViewController.modalPresentationStyle = .fullScreen
        // present the view controller
        navigationController?.pushViewController(CameraView(), animated: true)
        
    }
    
    //        present(secondViewController, animated: true, completion: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray // Change to custom color
        view.addSubview(appName)
        //        view.addSubview(appDescription)
        view.addSubview(nextScreenButton)
        
        //        var frameRect = CGRect(x:10, y:30, width: 80, height: 80)
        //        frameRect = CGRect(x:150, y:20, width:60, height: 60)
        //        appName = UILabel(frame: frameRect)
        
        /// behavior added to AppName
        //        let animateLabel = UIDynamicAnimator(referenceView: self.view)
        //        let originalPosition = CGPoint(x: appName.center.x, y: appName.center.y)
        //        appName.center = CGPoint(x: view.frame.width / 2, y: -view.frame.height)
        //        snap = UISnapBehavior(item: appName, snapTo: originalPosition)
        //        snap.damping = 0.5
        //        animateLabel.addBehavior(snap)
        //        self.view.layoutIfNeeded()
        
        //        animateLabel = UIDynamicAnimator(reference: self.view)
        
        //        let gravity = UIGravityBehavior(items: [appName])
        //        let vector  = CGVector(dx: 0.2, dy: 1.0)
        //        gravity.gravityDirection = vector
        //        animateLabel.addBehavior(gravity)
        
        let topAppNameAnchor = appName.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        let rightAppNameAnchor = appName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50)
        let leftAppNameAnchor = appName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50)
        let heightAppNameAnchor = appName.heightAnchor.constraint(equalToConstant: 45)
        //
        //            let topAppDescriptionAnchor = appDescription.topAnchor.constraint(equalTo: appName.bottomAnchor , constant: 100)
        //            let rightAppDescriptionAnchor = appDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20)
        //            let leftAppDescriptionAnchor = appDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -20)
        //            let heightAppDescription = appDescription.heightAnchor.constraint(equalToConstant: 45)
        
        let topButtonAnchor = nextScreenButton.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 45)
        let rightButtonAnchor = nextScreenButton.rightAnchor.constraint(equalTo: view.rightAnchor , constant: 20)
        let leftButtonAnchor = nextScreenButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -20)
        let heightButtonAnchor = nextScreenButton.heightAnchor.constraint(equalToConstant: 45)
        
        nextScreenButton.addTarget(self, action: #selector(advanceToNextVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([topAppNameAnchor, rightAppNameAnchor,leftAppNameAnchor, heightAppNameAnchor,
                                     topButtonAnchor, rightButtonAnchor, leftButtonAnchor, heightButtonAnchor])
    }
    
    
}
