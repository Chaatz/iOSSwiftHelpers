//
//  UIViewController+Helpers.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - Global Methods (UIViewController)
    static func findViewController(_ view: UIView) -> UIViewController? {
        var responder: UIResponder = view as UIResponder
        while responder.isKind(of: UIView.self) {
            guard let nextResponder = responder.next else { break }
            responder = nextResponder
        }
        
        if responder.isKind(of: UIViewController.self) {
            return responder as? UIViewController
        }
        
        return nil
    }
    
    static func findTopMostPresentedViewController() -> UIViewController? {
        
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let newTopViewController = topViewController.presentedViewController {
                topViewController = newTopViewController
            }
            return topViewController
        }
        
        return nil
    }
    
    static func dismissAllPresentedViewController(_ completion: @escaping (UIViewController?) -> ()) {
        
        guard let topMostPresentedViewController = UIViewController.findTopMostPresentedViewController() else {
            completion(nil)
            return
        }
        
        // hide All presenting view controller except the root one, so in user can just see one view controller dismissal aniamtion even multiple view controllers are dismissing.
        hideAllPresentingViewControllerExceptTheRootOne(withViewController: topMostPresentedViewController)
        
        dismissPresentedViewController(topMostPresentedViewController, completion: completion)
        
    }
    
    static func dismissPresentedViewController(_ viewController: UIViewController, completion:@escaping (_: UIViewController?) -> ()) {
        if let presentingViewController = viewController.presentingViewController {
            if viewController.isBeingDismissed {
                completion(nil)
                return
            }
            let shouldApplyAnimation = !presentingViewController.view.isHidden
            viewController.dismiss(animated: shouldApplyAnimation) {
                dismissPresentedViewController(presentingViewController, completion: completion)
            }
        }
        else {
            completion(viewController)
        }
    }
    
    private static func hideAllPresentingViewControllerExceptTheRootOne(withViewController vc: UIViewController) {
        if let presentingViewController = vc.presentingViewController {
            if let _ = presentingViewController.presentingViewController {
                presentingViewController.view.isHidden = true
                hideAllPresentingViewControllerExceptTheRootOne(withViewController: presentingViewController)
            }
        }
    }
}
