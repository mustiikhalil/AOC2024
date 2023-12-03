import Foundation
import Lib

public struct Day3: Day {
  private let file: String

  public init(file: String) {
    self.file = file
  }

  public func start(part: Part) {

    var matrix = Matrix<Character, Character>(str: file) { str, grid in
      let array = str
        .components(separatedBy: .newlines)

      var numberOfRows = 0
      for row in array {
        guard !row.isEmpty else { continue }
        grid.append(contentsOf: row.map { $0 })
        numberOfRows += 1
      }

      return (numberOfRows, array[0].count)
    }

    switch part {
    case .one:
      startPartOne(matrix)
    case .two:
      startPartTwo(&matrix)
    }
  }

  func startPartOne(_ matrix: Matrix<Character, Character>) {
    var row = 0
    var column = 0
    var number = 0

    while row < matrix.rows {
      var s = ""
      var hasSymbol = false
      while column < matrix.columns {
        let currentValue = matrix[row, column]
        if currentValue.isNumber {
          s.append(currentValue)
        }
        if matrix.hasNear(row: row, column: column, check: { $0.check() }) && !s.isEmpty {
          hasSymbol = true
        }

        let nextPeak = column + 1
        if matrix.peakValue(row: row, column: nextPeak)?.endOfNumber == true || matrix.endOfColumn(nextPeak) {
          if hasSymbol, let v = Int(s) {
            number += v
          }
          hasSymbol = false
          s = ""
        }
        column += 1
      }
      column = 0
      row += 1
      matrix.printMatrix()
    }
    print(number)
  }

  func startPartTwo(_ matrix: inout Matrix<Character, Character>) {
    var row = 0
    var column = 0
    var number = 0

    while row < matrix.rows {
      while column < matrix.columns {
        let currentValue = matrix[row, column]
        if currentValue.isGear {
          if matrix.hasNear(row: row, column: column, check: { $0.isNumber }), 
              let n = matrix.getNumbersAround(row: row, column: column) {
            number += n
          }
        }
        column += 1
      }
      column = 0
      row += 1
    }
    print(number)
  }
}

private extension Matrix where V: Checkable, T == Character {

  func hasNear(row: Int, column: Int, check: @escaping (T) -> Bool) -> Bool {
    peak(row: row - 1, column: column - 1, check: check) ||
    peak(row: row - 1, column: column, check: check) ||
    peak(row: row - 1, column: column + 1, check: check) ||
    peak(row: row, column: column - 1, check: check) ||
    peak(row: row, column: column + 1, check: check) ||
    peak(row: row + 1, column: column - 1, check: check) ||
    peak(row: row + 1, column: column, check: check) ||
    peak(row: row + 1, column: column + 1, check: check)
  }

  mutating func getNumbersAround(row: Int, column: Int) -> Int? {
    var numbers: [Int] = []

    if let s = readString(row: row - 1, column: column - 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }

    if let s = readString(row: row - 1, column: column, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }

    if let s = readString(row: row - 1, column: column + 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }

    if let s = readString(row: row, column: column - 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }

    if let s = readString(row: row, column: column + 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }
    if let s = readString(row: row + 1, column: column - 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }
    if let s = readString(row: row + 1, column: column, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }
    if let s = readString(row: row + 1, column: column + 1, transform: { $0 - 1 }), let n = Int(s) {
      numbers.append(n)
    }

    if numbers.count == 2 {
      return numbers.reduce(1, *)
    }
    return nil
  }

  func peak(row: Int, column: Int, check: @escaping (T) -> Bool) -> Bool {
    guard let v = peakValue(row: row, column: column) else { return false }
    return check(v)
  }

  func peakValue(row: Int, column: Int) -> T? {
    guard row >= 0 && column >= 0 && row < rows && column < columns else { return nil }
    return self[row, column]
  }

  private mutating func readString(row: Int, column: Int, transform: @escaping (Int) -> Int) -> String? {
    if let startPointer = findStartNumber(row: row, column: column, transform: transform) {
      var s = ""
      for c in startPointer.c..<columns {
        let value = self[startPointer.r, c]
        if value.isNumber {
          s.append("\(value)")
          self[startPointer.r, c] = T.emptyValue
        } else {
          break
        }
      }
      return s
    }
    return nil
  }

  private func findStartNumber(row: Int, column: Int, transform: @escaping (Int) -> Int) -> (r: Int, c: Int)? {
    guard row >= 0 && column >= 0, row < rows && column < columns && self[row, column].isNumber else { return nil }
    var c = column
    while row >= 0 && c >= 0 && row < rows && c < columns {
      let prevIndex = transform(c)
      if (prevIndex >= 0 && !self[row, prevIndex].isNumber) || c <= 0 || c >= columns {
        return (row, c)
      }
      c = prevIndex
    }
    return nil
  }

}
