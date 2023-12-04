import Foundation
import Lib

public struct Day4: Day {
  private let file: String

  public init(file: String) {
    self.file = file
  }

  public func start(part: Part) {
    let separators: Set<Character> = Set([":", "|"])
    var cards: [OrderedCards] = []
    for line in file.lines {
      let card = OrderedCards(line: line, separators: separators)
      cards.append(card)
    }

    switch part {
    case .one:
      let value = cards
        .map { $0.contained.multipleOfTwo }
        .reduce(0, +)
      print(value)
    case .two:
      process(cards: &cards)
    }
  }

  func process(cards: inout [OrderedCards]) {
    var index = 0
    while index < cards.count {
      let card = cards[index]
      index += 1

      if !card.isEmpty {
        for i in card.id + 1 ... card.id + card.count {
          if i >= cards.count {
            // loop around since we know for sure there will only be 1 instance of ticket 1
            cards[0].instance += cards[card.id].instance
          } else {
            cards[i].instance += cards[card.id].instance
          }
        }
      }
    }
    let total = cards
      .reduce(0) { r, v in
        r + v.instance
      }
    print(total)
  }
}

struct OrderedCards {

  let id: Int
  var instance = 1
  let contained: [Int]

  var isEmpty: Bool {
    contained.isEmpty
  }

  var count: Int {
    contained.count
  }

  init(line: String, separators: Set<Character>) {
    var readIndex: IndexReader = .leading(index: 0)
    var id: Int?
    var values: [Int] = []
    var winnings: [Int] = []
    var slicedString: Substring = Substring(line)
    while readIndex.index < line.count {
      // we reading string
      var index = slicedString.firstIndex(where: { separators.contains($0) }) ?? slicedString.endIndex
      if index != slicedString.endIndex {
        index = slicedString.index(after: index)
      }
      let s = slicedString[slicedString.startIndex..<index]

      if s.last == ":" {
        id = s.parseNumbersFromEndOfString()
      }
      if s.last == "|" {
        winnings = s.parseArrayOfNumbers()
      } else if s.last?.isNumber == true {
        values = s.parseArrayOfNumbers()
      }
      slicedString = slicedString[index..<slicedString.endIndex]
      readIndex = readIndex.next(index: s.count)
    }

    self.id = id ?? -1
    contained = values.filter { winnings.contains($0) }
  }

}

extension Array {
  var multipleOfTwo: Int {
    if isEmpty { return 0 }
    if self.count == 1 { return 1 }
    if self.count == 2 { return 2 }
    var value = 2
    for _ in 2..<count {
      value = value * 2
    }
    return value
  }
}
