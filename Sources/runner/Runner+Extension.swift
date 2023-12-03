import ArgumentParser
import Days

extension Runner {
  enum Day: Int, Decodable, ExpressibleByArgument {
    case day1 = 1, day2, day3
  }

}

extension Runner.Day {

  func day(file: String) -> any Days.Day {
    switch self {
    case .day1:
      Day1(file: file)
    case .day2:
      Day2(file: file)
    case .day3:
      Day3(file: file)
    }
  }
}

extension Part: ExpressibleByArgument {}
