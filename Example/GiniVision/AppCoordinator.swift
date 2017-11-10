//
//  AppCoordinator.swift
//  GiniVision_Example
//
//  Created by Enrique del Pozo Gómez on 11/10/17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import Foundation
import UIKit
import GiniVision

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    
    var screenAPIViewController: UIViewController?
    
    var rootViewController: UIViewController {
        return selectAPIViewController
    }
    
    lazy var selectAPIViewController: SelectAPIViewController = {
        let selectAPIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectAPIViewController") as! SelectAPIViewController
        selectAPIViewController.delegate = self
        return selectAPIViewController
    }()
    
    lazy var giniConfiguration: GiniConfiguration = {
        let giniConfiguration = GiniConfiguration()
        giniConfiguration.debugModeOn = true
        giniConfiguration.fileImportSupportedTypes = .pdf_and_images
        giniConfiguration.openWithEnabled = true
        giniConfiguration.navigationBarItemTintColor = UIColor.white
        giniConfiguration.customDocumentValidations = { document in
            // As an example of custom document validation, we add a more strict check for file size
            let maxFileSize = 5 * 1024 * 1024
            if document.data.count > maxFileSize {
                throw DocumentValidationError.custom(message: "Diese Datei ist leider größer als 5MB")
            }
        }
        return giniConfiguration
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        self.showSelectAPIScreen()
    }
    
    fileprivate func showSelectAPIScreen() {
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    fileprivate func showScreenAPI(withImportedDocument document:GiniVisionDocument? = nil) {
        let screenAPICoordinator = ScreenAPICoordinator(configuration: giniConfiguration, importedDocument: document)
        screenAPICoordinator.delegate = self
        add(childCoordinator: screenAPICoordinator)

        rootViewController.present(screenAPICoordinator.rootViewController, animated: true, completion: nil)
    }
    
    fileprivate func showComponentAPI(withImportedDocument document:GiniVisionDocument? = nil) {
        let componentAPICoordinator = ComponentAPICoordinator(document: document, configuration: giniConfiguration)
        componentAPICoordinator.delegate = self
        componentAPICoordinator.start()
        add(childCoordinator: componentAPICoordinator)
        
        rootViewController.present(componentAPICoordinator.rootViewController, animated: true, completion: nil)
    }
    
    fileprivate func showOpenWithSwitchDialog(forDocument document: GiniVisionDocument) {
        // This is only a shortcut for demo purposes since if the current root view controller is not
        // the ScreenAPIViewController (a GiniVisionDelegate), it won't do anything.
        popToRootViewControllerIfNeeded()
        
        // 4. Create an alert which allow users to open imported file either with the ScreenAPI or the ComponentAPI
        let alertViewController = UIAlertController(title: "Importierte Datei", message: "Möchten Sie die importierte Datei mit dem ScreenAPI oder ComponentAPI verwenden?", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Screen API", style: .default) {[weak self] _ in
            self?.showScreenAPI(withImportedDocument: document)
        })        
        alertViewController.addAction(UIAlertAction(title: "Component API", style: .default) { [weak self] _ in
            self?.showComponentAPI(withImportedDocument: document)
        })
        
        rootViewController.present(alertViewController, animated: true, completion: nil)
        
    }
    
    fileprivate func showExternalDocumentNotValidDialog() {
        // 4.1. Create alert which shows an error pointing out that it is not a valid document
        let alertViewController = UIAlertController(title: "Ungültiges Dokument", message: "Dies ist kein gültiges Dokument", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alertViewController.dismiss(animated: true, completion: nil)
        })
    }
    
    func processExternalDocument(withUrl url: URL, sourceApplication: String?) {
        // 1. Read data imported from url
        let data = try? Data(contentsOf: url)
        
        // 2. Build the document
        let documentBuilder = GiniVisionDocumentBuilder(data: data, documentSource: .appName(name: sourceApplication))
        documentBuilder.importMethod = .openWith
        let document = documentBuilder.build()
        
        do {
            try document?.validate()
            showOpenWithSwitchDialog(forDocument: document!)
        } catch {
            showExternalDocumentNotValidDialog()
        }
    }
    
    fileprivate func popToRootViewControllerIfNeeded() {
        self.childCoordinators.forEach { coordinator in
            coordinator.rootViewController.dismiss(animated: true, completion: nil)
            self.remove(childCoordinator: coordinator)
        }
    }
}

// MARK: SelectAPIViewControllerDelegate

extension AppCoordinator: SelectAPIViewControllerDelegate {
    
    func selectAPI(viewController: SelectAPIViewController, didSelectApi api: GiniVisionAPIType) {
        switch api {
        case .screen:
            showScreenAPI()
        case .component:
            showComponentAPI()
        }
    }
}

// MARK: ScreenAPICoordinatorDelegate

extension AppCoordinator: ScreenAPICoordinatorDelegate {
    func screenAPI(coordinator: ScreenAPICoordinator, didFinish: ()) {
        coordinator.rootViewController.dismiss(animated: true, completion: nil)
        self.remove(childCoordinator: coordinator)
    }
}

// MARK: ComponentAPICoordinatorDelegate

extension AppCoordinator: ComponentAPICoordinatorDelegate {
    func componentAPI(coordinator: ComponentAPICoordinator, didFinish: ()) {
        coordinator.rootViewController.dismiss(animated: true, completion: nil)
        self.remove(childCoordinator: coordinator)
    }
}
