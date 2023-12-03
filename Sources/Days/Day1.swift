import Foundation
import Lib

public struct Day1: Day {

  private let file: String

  public init(file: String) {
    self.file = file
  }

  public func start(part: Part) {
    let strings = file.components(separatedBy: .newlines)
    var count: Int = 0

    for string in strings {
      let str = checkIntsWithinString(
        part: part,
        string: string)
      if let v = Int(str) {
        count += v
      }
    }
    print(count)
  }

  private func checkIntsWithinString(part: Part, string: String) -> String {
    var firstValue: Int?
    var lastValue: Int?

    var leading: IndexReader = .leading(index: 0)
    var trailing: IndexReader = .trailing(index: string.count)

    var whileIndex = 0

    while whileIndex < string.count {
      if firstValue == nil, leading.index < string.count {
        (firstValue, leading) = parse(
          string: string,
          index: leading,
          part: part)
      }

      if lastValue == nil, trailing.index >= 0 {
        (lastValue, trailing) = parse(
          string: string,
          index: trailing,
          part: part)
      }

      if !firstValue.isEmpty && !lastValue.isEmpty {
        break
      }
      whileIndex += 1
    }

    return switch (firstValue, lastValue) {
    case let (.some(f), .none): "\(f)\(f)"
    case let (.none, .some(l)): "\(l)\(l)"
    case let (.some(f), .some(l)): "\(f)\(l)"
    default: ""
    }
  }

  private func parse(
    string: String,
    index: IndexReader,
    part: Part
  ) -> (Int?, IndexReader) {
    let str = string.slice(
      start: index.start,
      end: index.end)
    if let v = Int(str) {
      return (v, index.next(index: 1))
    }

    if part == .two {
      let value = checkTokenizedString(
        str,
        in: string,
        using: index)

      if let value, let v = value.number {
        return (v, index.next(index: value.count))
      }
    }

    return (nil, index.next(index: 1))
  }

  private func checkTokenizedString(
    _ token: Substring,
    in str: String,
    using index: IndexReader) -> String?
  {
    let checkedValues = switch index {
    case .leading:
      numbers.filter({ Character(String(token)) == $0.first })
    case .trailing:
      numbers.filter({ Character(String(token)) == $0.last })
    }

    for value in checkedValues {

      let (start, end) = switch index {
      case .leading(let index):
        (index, index + value.count)
      case .trailing(let index):
        (index - value.count, index)
      }
      guard end <= str.count && start >= 0 else { continue }
      let slice = str.slice(start: start, end: end)
      if slice == value {
        return value
      }
    }
    return nil
  }

  private let numbers: [String] = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
  ]

}


private extension IndexReader {
  var start: Int {
    switch self {
    case .leading(let index):
      index
    case .trailing(let index):
      index - 1
    }
  }

  var end: Int {
    switch self {
    case .leading(let index):
      index + 1
    case .trailing(let index):
      index
    }
  }
}
