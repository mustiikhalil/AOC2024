import Foundation
import Lib

public struct Day2: Day {
  private let file: String

  public init(file: String) {
    self.file = file
  }

  public func start(part: Part) {
    switch part {
    case .one:
      partOne()
    case .two:
      partTwo()
    }
  }

  public func partOne() {
    var value = 0
    for line in file.components(separatedBy: .newlines) {
      guard !line.isEmpty else { continue }
      let game = Game(str: line)
      if game.play(r: 12, b: 14, g: 13) {
        value += game.id
      }
    }
    print(value)
  }

  public func partTwo() {
    var value = 0
    for line in file.components(separatedBy: .newlines) {
      guard !line.isEmpty else { continue }
      let game = Game(str: line)
      value += game.play()
    }
    print(value)
  }
}

enum Color {
  case red(v: Int), blue(v: Int), green(v: Int)

  var value: Int {
    switch self {
    case .red(let v):
      return v
    case .blue(let v):
      return v
    case .green(let v):
      return v
    }
  }

  static func from(str: String, v: Int) -> Color {
    switch str {
    case "red":
      return .red(v: v)
    case "green":
      return .green(v: v)
    case "blue":
      return .blue(v: v)
    default: fatalError("Not supported")
    }
  }
}

enum Turn {
  case round(v: [Color])

  var values: [Color] {
    switch self {
    case .round(let v):
      return v
    }
  }
}

struct Game {

  private static let tokens: Set<Character> = [":", ",", ";"]

  let id: Int
  let turns: [Turn]

  init(str: String) {
    var leading: IndexReader = .leading(index: 0)
    var slicedString = Substring(str)
    var id: Int?
    var colors: [Color] = []
    var round: [Turn] = []
    var iterations = 0
    while leading.index < str.count {
      iterations += 1
      var firstIndex = slicedString.firstIndex(where: { Game.tokens.contains($0) }) ?? slicedString.endIndex

      if !(firstIndex == slicedString.endIndex) {
        firstIndex = slicedString.index(after: firstIndex)
      }

      let slice = slicedString[slicedString.startIndex..<firstIndex]
      if slice.last == ":" {
        id = slice.parseNumbersFromEndOfString()
      } else {
        colors.append(Game.parseColor(string: slice)!)
        if slice.last == ";" || slice.last?.isLetter == true {
          round.append(.round(v: colors))
          colors = []
        }
      }
      leading = leading.next(index: slice.count)
      slicedString = slicedString[firstIndex..<slicedString.endIndex]
    }

    if let id {
      self.id = id
    } else {
      fatalError("Couldnt parse id")
    }
    turns = round
  }

  func play(r: Int, b: Int, g: Int) -> Bool {
    for turn in turns {
      for color in turn.values {
        switch color {
        case .red(let v):
          if v > r {
            return false
          }
        case .blue(let v):
          if v > b {
            return false
          }
        case .green(let v):
          if v > g {
            return false
          }
        }
      }
    }
    return true
  }

  func play() -> Int {
    var maxRed = 0
    var maxBlue = 0
    var maxGreen = 0
    for turn in turns {
      for color in turn.values {
        switch color {
        case .red(let v):
          maxRed = max(maxRed, v)
        case .blue(let v):
          maxBlue = max(maxBlue, v)
        case .green(let v):
          maxGreen = max(maxGreen, v)
        }
      }
    }
    return maxRed * maxBlue * maxGreen
  }

  static func parseColor(string: Substring) -> Color? {
    let str = string.components(separatedBy: " ").filter { !$0.isEmpty }
    if str[1].last?.isLetter == true {
      return Color.from(str: str[1], v: Int(str[0])!)
    } else {
      let color = str[1].dropLast(1)
      return Color.from(str: String(color), v: Int(str[0])!)

    }
  }

}
