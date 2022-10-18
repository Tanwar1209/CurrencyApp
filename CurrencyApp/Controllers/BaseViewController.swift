//
//  BaseViewController.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
public class BaseViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    func parseNetworkError(error: NetworkError) {
        var errorMessage = ""
        switch error {
        case .invalidURL(let message):
            errorMessage = message
        case .invalidResponse(let message):
            errorMessage = message
        case .decodingError(let message):
            errorMessage = message
        case .genericError(let message):
            errorMessage = message
        case .internetError(let message):
            errorMessage = message
        }
        showErrorView(errorMessage: errorMessage)
    }
    func showErrorView(errorMessage: String) {
        let errorDialogMessage = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorDialogMessage.addAction(okAction)
        self.present(errorDialogMessage, animated: true, completion: nil)
    }
}

extension BaseViewController: ProgressBarViewable {}

extension Reactive where Base: BaseViewController {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    internal var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { vcObject, active in
            if active {
                vcObject.startAnimating()
            } else {
                vcObject.stopAnimating()
            }
        })
    }
}

public extension BaseViewController {
    func add(asChildViewController viewController: UIViewController, to parentView: UIView) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        parentView.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = parentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
}
