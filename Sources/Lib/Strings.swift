import Foundation

public enum IndexReader {
  case leading(index: Int)
  case trailing(index: Int)

  public var index: Int {
    switch self {
    case .leading(let index):
      return index
    case .trailing(let index):
      return index
    }
  }

  public func next(index: Int) -> IndexReader {
    switch self {
    case .leading(let i):
      return .leading(index: i + index)
    case .trailing(let i):
      return .trailing(index: i - index)
    }
  }
}

extension String {

  public var lines: [String] {
    if isEmpty { return [] }
    let lines = self.components(separatedBy: .newlines)
    if lines.last?.isEmpty == true {
      return lines.dropLast()
    }
    return lines
  }

  public func slice(start: Int, end: Int) -> Substring {
    let start = index(startIndex, offsetBy: start)
    let end = index(startIndex, offsetBy: end)
    return self[start..<end]
  }
}

extension String {
  public var number: Int? {
    switch self {
    case "one":
      return 1
    case "two":
      return 2
    case "three":
      return 3
    case "four":
      return 4
    case "five":
      return 5
    case "six":
      return 6
    case "seven":
      return 7
    case "eight":
      return 8
    case "nine":
      return 9
    default:
      return nil
    }
  }

}
