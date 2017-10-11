//
//  NoResultViewController.swift
//  GiniVision
//
//  Created by Peter Pult on 22/08/2016.
//  Copyright © 2016 Gini. All rights reserved.
//

import UIKit

protocol NoResultsScreenDelegate:class {
    func didTapRetry()
}

class NoResultViewController: UIViewController {
    
    @IBOutlet var rotateImageView: UIImageView!
    var delegate:NoResultsScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rotateImageView.image = rotateImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func retry(_ sender: AnyObject) {
        delegate?.didTapRetry()
    }
}