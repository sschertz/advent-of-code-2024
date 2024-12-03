import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Split input data into an array of Int arrays
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }
  
  

  
  func part1() -> Any {
    let input = entities
    return input.map{
        if $0.isArraySafe() {return 1} else {return 0}
    }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}

// extend array struct with new functions
extension Array where Element == Int {

  static func isValidChange(a: Int, b: Int,
                            by isInValidOrder: (Int, Int) -> Bool) -> Bool {
    if isInValidOrder(a, b) && abs(a - b) <= 3 { return true }
    return false
  }

  func isArraySafe() -> Bool {
    guard self[0] != self[1] else {
      // exit with false if the first two elements are equal, as we are already
      // failing to increase or decrease
      return false
    }

    var comparisonOperator: (Int, Int) -> Bool = (<)

    if self[0] > self[1] {
      comparisonOperator = (>)
    }

    for i in 0..<self.endIndex-1 {
      if !Array<Int>.isValidChange(a: self[i], b: self[i + 1], by: comparisonOperator) {
        return false
      }
    }
    return true
  }

}
