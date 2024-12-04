import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  func part1() -> Any {
    let mulPattern = /mul\((\d{1,3}),(\d{1,3})\)/
    let matches = data.matches(of: mulPattern)
    
    return matches.map{
      Int($0.1)! * Int($0.2)!
    }.reduce(0, +)
  }
  
  func part2() -> Any {
    
    let patternWithDoDont = /don't\(\)|do\(\)|mul\((\d{1,3}),(\d{1,3})\)/
    let matches = data.matches(of: patternWithDoDont)
    
    var validInstructions: [Int] = []
    var isDoMatches = true
    
    for match in matches {
      //print("Processing match: 0: \(match.0), 1: \(String(describing: match.1)), 2: \(String(describing: match.2)))")
      switch match.0 {
      case "don't()":
        isDoMatches = false
      case "do()":
        isDoMatches = true
      default:
        if isDoMatches {
          if let m1 = match.1, let m2 = match.2 {
            validInstructions.append(Int(m1)! * Int(m2)!)
          }
        }
      }
    }
    
    return validInstructions.reduce(0, +)
  }
}
