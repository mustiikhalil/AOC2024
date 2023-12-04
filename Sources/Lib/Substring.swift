import Foundation

extension Substring {
  public func parseNumbersFromEndOfString(separatedBy separator: Character = " ") -> Int? {
    var str = ""
    for v in reversed() {
      if v.isNumber {
        str.insert(v, at: str.startIndex)
      }
      if v == separator {
        break
      }
    }
    return Int(str)
  }

  public func parseArrayOfNumbers() -> [Int] {
    return components(separatedBy: .whitespacesAndNewlines)
      .compactMap { Int($0) }
  }
}

