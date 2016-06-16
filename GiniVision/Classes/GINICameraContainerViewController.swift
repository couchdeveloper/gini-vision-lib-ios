//
//  CameraContainerViewController.swift
//  GiniVision
//
//  Created by Peter Pult on 08/06/16.
//  Copyright © 2016 Gini. All rights reserved.
//

import UIKit

internal class GINICameraContainerViewController: UIViewController, GINIContainer {
    
    // Container attributes
    internal var containerView = UIView()
    internal var contentController = UIViewController()
    
    // User interface
    private var closeButton = UIBarButtonItem()
    private var helpButton = UIBarButtonItem()
    
    // Images
    private var closeButtonImage: UIImage? {
        return UIImageNamedPreferred(named: "navigationClose")
    }
    private var helpButtonImage: UIImage? {
        return UIImageNamedPreferred(named: "navigationHelp")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Configure content controller and call delegate method on success
        contentController = GINICameraViewController(callback: { imageData in
            guard let imageData = imageData else { return }
            let delegate = (self.navigationController as? GININavigationViewController)?.giniDelegate
            delegate?.didCapture(imageData)
        })
        
        // Configure title
        title = GINIConfiguration.sharedConfiguration.navigationBarTitleCamera
                
        // Configure colors
        view.backgroundColor = GINIConfiguration.sharedConfiguration.backgroundColor
        
        // Configure close button
        closeButton = UIBarButtonItem(image: closeButtonImage, style: .Plain, target: self, action: #selector(close))
        closeButton.title = GINIConfiguration.sharedConfiguration.navigationBarTitleCloseButton
        if let s = closeButton.title where !s.isEmpty {
            closeButton.image = nil
        } else {
            // Set title `nil` because an empty string will cause problems in UI
            closeButton.title = nil
        }
        
        // Configure help button
        helpButton = UIBarButtonItem(image: helpButtonImage, style: .Plain, target: self, action: #selector(help))
        helpButton.title = GINIConfiguration.sharedConfiguration.navigationBarTitleHelpButton
        if let s = helpButton.title where !s.isEmpty {
            helpButton.image = nil
        } else {
            // Set title `nil` because an empty string will cause problems in UI
            helpButton.title = nil
        }
        
        // Configure view hierachy
        view.addSubview(containerView)
        navigationItem.setLeftBarButtonItem(closeButton, animated: false)
        navigationItem.setRightBarButtonItem(helpButton, animated: false)
        
        // Add constraints
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add content to container view
        displayContent(contentController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close() {
        let delegate = (navigationController as? GININavigationViewController)?.giniDelegate
        delegate?.didCancelCapturing()
    }
    
    @IBAction func help() {
        // TODO: Implement call
        print("GiniVision: Wants to open help")
    }
    
    // MARK: Constraints
    private func addConstraints() {
        let superview = self.view
        
        // Container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        UIViewController.addActiveConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: 0)
        UIViewController.addActiveConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: 0)
        UIViewController.addActiveConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: 0)
        UIViewController.addActiveConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: 0)
    }

}
