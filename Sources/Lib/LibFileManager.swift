import Foundation

public struct LibFileManager {

  private let filename: String
  private let fileManager: FileManager

  public init(filename: String, fileManager: FileManager = FileManager.default) throws {
    guard fileManager.currentDirectoryPath.contains("AOC2024") else {
      throw Errors.workingDirectory
    }
    self.filename = filename
    self.fileManager = fileManager
  }

  public func read() throws -> Data? {
    let buildedPath = "\(fileManager.currentDirectoryPath)/files/\(filename)"
    guard fileManager.fileExists(atPath: buildedPath) else { throw Errors.fileNotFound }
    return fileManager.contents(atPath: buildedPath)
  }

}
