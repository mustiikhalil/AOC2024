import Foundation
import Lib

public struct Day4: Day {
  private let file: String

  public init(file: String) {
    self.file = file
  }

  public func start(part: Part) {
    let separators: Set<Character> = Set([":", "|"])
    var cards: [Card] = []
    for line in file.lines {
      let card = Card(line: line, separators: separators)
      cards.append(card)
    }

    switch part {
    case .one:
      let value = cards
        .map { $0.contained.multipleOfTwo }
        .reduce(0, +)
      print("## value: \(value)")
    case .two:
      process(cards: cards)
    }
  }

  func process(cards: [Card]) {
    let mutableCards = cards.map { OrderedCards(card: $0) }
    var index = 0
    while index < mutableCards.count {
      let card = mutableCards[index]
      index += 1

      if !card.isEmpty {
        for i in card.id + 1 ... card.id + card.count {
          if i >= mutableCards.count {
            // loop around since we know for sure there will only be 1 instance of ticket 1
            mutableCards[0].instance += mutableCards[card.id].instance
          } else {
            mutableCards[i].instance += mutableCards[card.id].instance
          }
        }
      }
    }
    let total = mutableCards
      .reduce(0) { r, v in
        r + v.instance
      }
    print(total)
  }
}


final class OrderedCards {

  private let card: Card
  var instance = 1

  var id: Int {
    card.id
  }

  var isEmpty: Bool {
    card.contained.isEmpty
  }

  var count: Int {
    card.contained.count
  }

  init(card: Card) {
    self.card = card
  }

}

struct Card {

  let id: Int
  let values: [Int]
  let winnings: [Int]
  let contained: [Int]

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
    self.values = values
    self.winnings = winnings
    contained = values.filter { winnings.contains($0) }
  }

}

extension Array {
  var multipleOfTwo: Int {
    if isEmpty { return 0 }
    if self.count == 1 { return 1 }
    if self.count == 2 { return 2 }
    var value = 2
    for i in 2..<count {
      value = value * 2
    }
    return value
  }
}
