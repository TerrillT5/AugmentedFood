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
        let nextScreenButton: UIButton = {
        let continueButton = UIButton()
        continueButton.layer.cornerRadius = 10
        continueButton.layer.borderWidth = 1
        //         = UIColor.lightGray.cgColor
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
        navigationController?.pushViewController(CameraView(), animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray // Change to custom color
        view.addSubview(appName)
        view.addSubview(nextScreenButton)
        
              let topAppNameAnchor = appName.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        let rightAppNameAnchor = appName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50)
        let leftAppNameAnchor = appName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50)
        let heightAppNameAnchor = appName.heightAnchor.constraint(equalToConstant: 45)
        
        let topButtonAnchor = nextScreenButton.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 45)
        let rightButtonAnchor = nextScreenButton.rightAnchor.constraint(equalTo: view.rightAnchor , constant: 20)
        let leftButtonAnchor = nextScreenButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -20)
        let heightButtonAnchor = nextScreenButton.heightAnchor.constraint(equalToConstant: 45)
        
        nextScreenButton.addTarget(self, action: #selector(advanceToNextVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([topAppNameAnchor, rightAppNameAnchor,leftAppNameAnchor, heightAppNameAnchor,
                                     topButtonAnchor, rightButtonAnchor, leftButtonAnchor, heightButtonAnchor])
    }
    
    
}
