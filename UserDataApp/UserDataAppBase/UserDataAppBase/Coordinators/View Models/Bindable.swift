import UIKit

// MARK: - Bindable
public protocol Bindable {

    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

/// Optional methods
extension Bindable {
    public func bindViewModel() { }
}

// MARK: - UIViewController
public extension Bindable where Self: UIViewController {

    mutating func attachViewModel(_ viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
