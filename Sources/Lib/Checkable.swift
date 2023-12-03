//
//  File.swift
//  
//
//  Created by Mustafa Khalil on 2023-12-04.
//

import Foundation

public protocol Checkable {
  associatedtype Element
  var isNumber: Bool { get }
  func check() -> Bool
  static var emptyValue: Element { get }
}

extension Character: Checkable {
  public typealias Element = Character
  public static var emptyValue: Element {
    "."
  }

  public func check() -> Bool {
    !isNumber && self != "."
  }

  public var endOfNumber: Bool {
    !isNumber || self == "."
  }

  public var isGear: Bool {
    self == "*"
  }

}
