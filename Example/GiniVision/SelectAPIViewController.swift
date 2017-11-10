//
//  ScreenAPIViewController.swift
//  GiniVision
//
//  Created by Peter Pult on 05/30/2016.
//  Copyright © 2016 Gini. All rights reserved.
//

import UIKit
import GiniVision
import Gini_iOS_SDK

protocol SelectAPIViewControllerDelegate:class {
    func selectAPI(viewController: SelectAPIViewController, didSelectApi api: GiniVisionAPIType)
}

/**
 View controller showing how to capture an image of a document using the Screen API of the Gini Vision Library for iOS
 and how to process it using the Gini SDK for iOS.
 */
final class SelectAPIViewController: UIViewController {
    
    @IBOutlet weak var metaInformationLabel: UILabel!
    
    weak var delegate: SelectAPIViewControllerDelegate?
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customClientId = UserDefaults.standard.string(forKey: kSettingsGiniSDKClientIdKey) ?? ""
        let clientId = customClientId != "" ? customClientId : kGiniClientId
        
        metaInformationLabel.text = "Gini Vision Library: (\(GiniVision.versionString)) / Client id: \(clientId)"
    }
    
    // MARK: User interaction
    @IBAction func launchScreenAPI(_ sender: Any) {
        delegate?.selectAPI(viewController: self, didSelectApi: .screen)
    }
    
    @IBAction func launchComponentAPI(_ sender: Any) {
        delegate?.selectAPI(viewController: self, didSelectApi: .component)
    }
}
