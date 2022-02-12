//
//  RxExtensions.swift
//  UserDataAppBase
//
//  Created by Datt Patel on 11/02/22.
//

import Foundation
import RxCocoa

public extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(_ element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }

    func add(_ elements: [Element.Element]) {
        var array = self.value
        array.append(contentsOf: elements)
        self.accept(array)
    }

    func remove(at: Element.Index) {
        var array = self.value
        array.remove(at: at)
        self.accept(array)
    }
    func replace(_ element: Element.Element ,at: Element.Index) {
        var array = self.value
        array.remove(at: at)
        array.append(element)
        self.accept(array)
    }

}
public extension BehaviorRelay where Element: RangeReplaceableCollection, Element.Element: Equatable {


    func remove(_ element: Element.Element) {
        var array = self.value
        if let index = array.firstIndex(of: element) {
            array.remove(at: index)
            self.accept(array)
        }

    }

}
