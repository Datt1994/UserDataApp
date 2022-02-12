//
//  Utility.swift

import Foundation


//MARK: - DispatchQueue
public func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

public func mainThread(_ completion: @escaping () -> ()) {
    DispatchQueue.main.async {
        completion()
    }
}

//userInteractive
//userInitiated
//default
//utility
//background
//unspecified
public func backgroundThread(_ qos: DispatchQoS.QoSClass = .background , completion: @escaping () -> ()) {
    DispatchQueue.global(qos:qos).async {
        completion()
    }
}

