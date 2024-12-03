import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  func part1() -> Any {
    let mulPattern = /mul\((\d{1,3}),(\d{1,3})\)/
    let matches = data.matches(of: mulPattern)

    for match in matches {
        print("0: \(match.0), 1: \(match.1), 2: \(match.2)")
    }

    return matches.map{
        Int($0.1)! * Int($0.2)!
    }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}
