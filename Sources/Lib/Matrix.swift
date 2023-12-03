//
//  File.swift
//  
//
//  Created by Mustafa Khalil on 2023-12-04.
//

import Foundation

public struct Matrix<V, T> {

  public let rows: Int
  public let columns: Int
  public var grid: [T] = []

  public init(str: String, proccecing: @escaping (String, inout [T]) -> (Int, Int)) {
    (rows, columns) = proccecing(str, &grid)
  }

  public func indexIsValid(row: Int, column: Int) -> Bool {
    return row >= 0 && row < rows && column >= 0 && column < columns
  }

  public func endOfColumn(_ v: Int) -> Bool {
    v == columns
  }

  public subscript(row: Int, column: Int) -> T {
    get {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    }
    set {
      assert(indexIsValid(row: row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }

  public func printMatrix() {
    var r = 0
    var c = 0
    while r < rows {
      var s = ""
      while c < columns {
        s.append("\(self[r, c])")
        c += 1
      }
      c = 0
      r += 1
      print(s)
    }
  }
}
