//
//  ViewController.swift
//  AugmentedFood
//
//  Created by Terrill Thorne on 9/19/17.
//  Copyright © 2017 Terrill Thorne. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    var appName: UILabel = {
        let nameOfApp = UILabel()
        nameOfApp.text = "AR Food"
        nameOfApp.textColor = .white
        nameOfApp.font = UIFont(name: "Helvetica", size: 25)
        nameOfApp.textAlignment = .center
        nameOfApp.translatesAutoresizingMaskIntoConstraints = false
        return nameOfApp
    }()
    let nextScreenButton: UIButton = {
        let continueButton = UIButton()
        continueButton.frame.size.width = 25
        continueButton.frame.size.height = 45
        continueButton.layer.shadowColor = UIColor.black.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.5, height: 15)
        continueButton.layer.shadowRadius = 5
        continueButton.layer.shadowOpacity = 0.5
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        return continueButton
    }()
    
    @objc func advanceToNextVC(sender: UIButton) {
        let secondViewController = CameraView()
        secondViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(CameraView(), animated: true)
    }
    override func viewDidLoad() {
    super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0.48, green: 0.65, blue: 0.70, alpha: 1)
        view.addSubview(appName)
        view.addSubview(nextScreenButton)
        let topAppNameAnchor = appName.topAnchor.constraint(equalTo: view.topAnchor, constant: 120)
        let rightAppNameAnchor = appName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50)
        let leftAppNameAnchor = appName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50)
        let heightAppNameAnchor = appName.heightAnchor.constraint(equalToConstant: 45)

        let topButtonAnchor = nextScreenButton.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 50)
        let rightButtonAnchor = nextScreenButton.rightAnchor.constraint(equalTo: view.rightAnchor , constant: 20)
        let leftButtonAnchor = nextScreenButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -20)
        let heightButtonAnchor = nextScreenButton.heightAnchor.constraint(equalToConstant: 45)
        nextScreenButton.addTarget(self, action: #selector(advanceToNextVC), for: .touchUpInside)
        NSLayoutConstraint.activate([topAppNameAnchor, rightAppNameAnchor,leftAppNameAnchor, heightAppNameAnchor,
                                     topButtonAnchor, rightButtonAnchor, leftButtonAnchor, heightButtonAnchor])
    }
    
    
}
