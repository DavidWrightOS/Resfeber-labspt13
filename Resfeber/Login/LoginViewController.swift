//
//  LoginViewController.swift
//  LabsScaffolding
//
//  Created by Spencer Curtis on 7/23/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import UIKit
import OktaAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    
    let profileController = ProfileController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationSuccessful,
                                               object: nil,
                                               queue: .main,
                                               using: checkForExistingProfile)
        
        NotificationCenter.default.addObserver(forName: .oktaAuthenticationExpired,
                                               object: nil,
                                               queue: .main,
                                               using: alertUserOfExpiredCredentials)
        
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: Any) {
        UIApplication.shared.open(ProfileController.shared.oktaAuth.identityAuthURL()!)
    }
    
    // MARK: - Private Methods
    
    fileprivate func setupView() {
        // Sets logoImageView to render as a template image and sets the color to ResfeberRed
        logoImageView.image = logoImageView.image?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = UIColor(named: "ResfeberRed")
        
        // Sets edge insets for button text
        signInButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        signInButton.layer.cornerRadius = 5
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        signInButton.layer.shadowOpacity = 0.4
        signInButton.layer.shadowRadius = 5
        signInButton.layer.shouldRasterize = true
        signInButton.layer.masksToBounds =  false
        
        // Only displays shadow on button in light mode
        if traitCollection.userInterfaceStyle == .dark {
            signInButton.layer.shadowColor = nil
        } else {
            signInButton.layer.shadowColor = UIColor(named: "ResfeberDark")?.cgColor
        }
        
    }
    
    private func alertUserOfExpiredCredentials(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentSimpleAlert(with: "Your Okta credentials have expired",
                           message: "Please sign in again",
                           preferredStyle: .alert,
                           dismissText: "Dimiss")
        }
    }
    
    // MARK: Notification Handling
    
    private func checkForExistingProfile(with notification: Notification) {
        checkForExistingProfile()
    }
    
    private func checkForExistingProfile() {
        profileController.checkForExistingAuthenticatedUserProfile { [weak self] (exists) in
            
            guard let self = self,
                self.presentedViewController == nil else { return }
            
            if exists {
                self.performSegue(withIdentifier: "ShowDetailProfileList", sender: nil)
            } else {
                self.performSegue(withIdentifier: "ModalAddProfile", sender: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalAddProfile" {
            guard let addProfileVC = segue.destination as? AddProfileViewController else { return }
            addProfileVC.delegate = self
        }
    }
}

// MARK: - Add Profile Delegate

extension LoginViewController: AddProfileDelegate {
    func profileWasAdded() {
        checkForExistingProfile()
    }
}
