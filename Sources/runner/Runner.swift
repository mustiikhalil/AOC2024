import ArgumentParser
import Days
import Foundation
import Lib

@main
struct Runner: ParsableCommand {

  @Option
  var day: Runner.Day

  @Option
  var part: Part

  mutating func run() throws {
    let fileManager = try LibFileManager(filename: "\(day)")
    guard let data = try fileManager.read(), let str = String(data: data, encoding: .utf8) else {
      throw Errors.couldntReadData
    }
    let day: Days.Day = day.day(file: str)
    day.start(part: part)
  }
}
