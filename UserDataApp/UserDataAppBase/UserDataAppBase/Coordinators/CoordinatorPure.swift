import UIKit

public enum TransitionType {
    case push(animated: Bool)
    case present(animated: Bool)
    case pop(animated: Bool)
    case popToRoot(animated: Bool)
    case dismiss(animated: Bool, completion: (() -> ())?)
    case popVC(_ vc: UIViewController)
}
 
open class CoordinatorPure {

    private weak var rootViewController: UIViewController?

    public var navigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    public var tabController: UITabBarController? {
        return rootViewController as? UITabBarController
    }

    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    open func start() { }
    open func stop() { }

    // MARK: Transitions
    public func transitionTo<T>(_ viewModel: T?, type: TransitionType = .push(animated: true)) {
        // Can be nil (when popping the vc)
        let viewController = self.viewController(for: viewModel)

        switch type {

        case .push(let animated):
            assert(viewController != nil, "A view model is not implemented")
            navigationController?.pushViewController(viewController!, animated: animated)

        case .present(let animated):
            assert(viewController != nil, "A view model is not implemented")
            navigationController?.present(viewController!, animated: animated)

        case .pop(let animated):
            navigationController?.popViewController(animated: animated)

        case .popToRoot(let animated):
            navigationController?.popToRootViewController(animated: animated)

        case .dismiss(let animated, let completion):
            rootViewController!.dismiss(animated: animated, completion: completion)
            
        case .popVC(let vc):
            guard var vcs = navigationController?.viewControllers, let vcIndex = vcs.firstIndex(of: vc) else { return }
            vcs.remove(at: vcIndex)
            navigationController?.viewControllers = vcs
        }
    }

    open func viewController<T>(for viewModel: T?) -> UIViewController? {
        return nil
    }

    // MARK: Helpers
    public func pop(animated: Bool = true) {
        transitionTo(nil as Int? /*any VM*/, type: .pop(animated: animated))
    }
    
    public func pop(vc: UIViewController) {
        transitionTo(nil as Int? /*any VM*/, type: .popVC(vc))
    }

    public func popToRoot(animated: Bool = true) {
        transitionTo(nil as Int?, type: .popToRoot(animated: animated))
    }

    public func dismiss(animated: Bool = true, completion: (() -> ())? = nil) {
        transitionTo(nil as Int?, type: .dismiss(animated: animated, completion: completion))
    }
}
