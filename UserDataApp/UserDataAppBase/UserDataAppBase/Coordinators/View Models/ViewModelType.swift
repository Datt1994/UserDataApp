import Foundation

public protocol ViewModelType {
    associatedtype CoordinatorType

    // Don't retain a coordinator in a class that conforms to this protocol.
    // For usage simplicity it's been defined as `implicitly unwrapped`
    var coordinator: CoordinatorType! { get }
}
