//
//  SwipeNavigationController.swift
//
//  Created by datt on 22/01/20.
//

import UIKit

open class SwipeNavigationController: UINavigationController {
    
//    /// Set the style for all controllers in the navigation stack
//    public override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
//
//    public override var childForStatusBarStyle: UIViewController? {
//        return nil
//    }
    
    // MARK: - Lifecycle
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        navigationItem.backBarButtonItem?.isEnabled = true
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to be in here, not in init
        setup()
    }
    
    // MARK: - Overrides
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
    
    
    //    let simpleOver = SimpleOver()
}

// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
    
    
    
}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

extension SwipeNavigationController : UIViewControllerTransitioningDelegate {
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        //        if (toVC.isKind(of: HomeVC.self) && (operation == .push)) || (fromVC.isKind(of: HomeVC.self) && (operation == .pop))  {
        //            simpleOver.popStyle = (operation == .pop)
        //            return simpleOver
        //        }
        return nil
    }
}
