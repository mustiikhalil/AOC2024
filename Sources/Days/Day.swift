import Foundation

public enum Part: String, Decodable {
  case one, two
}

public protocol Day {
  func start(part: Part)
}
