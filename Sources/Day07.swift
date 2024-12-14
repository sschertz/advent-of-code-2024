import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Equation] {
    data.split(separator: "\n").map{$0.split(separator: ":")}.map{
      let result = Int($0[0])
      let values = $0[1].split(separator: " ").compactMap{Int($0)}
      return Equation(result: result!, values: values)
    }
  }
  
  struct Equation {
    var result: Int
    var values: [Int]
    var numberOperators: Int {
      return values.count-1
    }
    var operators:[Character] {
      Array(repeating: "+", count: numberOperators )
      + Array(repeating: "*", count: numberOperators)
    }
    
    var operatorsWithConcat: [Character] {
      Array(repeating: "+", count: numberOperators )
      + Array(repeating: "*", count: numberOperators)
      + Array(repeating: "|", count: numberOperators)
    }
    
    var basicOperatorCombos: [[Character]] {
      operators.uniquePermutations(ofCount:numberOperators).map{Array($0)}
    }
    
    var concatOperatorCombos: [[Character]]{
      let basicOperatorCombos = Set(basicOperatorCombos)
      let all = Set(operatorsWithConcat.uniquePermutations(ofCount: numberOperators).map{Array($0)})
      return Array(all.subtracting(basicOperatorCombos))
    }
    
    // might nto need this anymore?
    func getOperatorPermutations(includeAll: Bool = false) -> [[Character]]{
      let operators = (includeAll ? self.operatorsWithConcat : self.operators)
      return operators.uniquePermutations(ofCount:numberOperators).map{Array($0)}
    }
  }

  func getOperator (_ input: Character) -> (Int,Int) -> Int {
    if input == "+" {
      return (+)
    } else if input == "*" { return (*)
    } else { return (||) }
  }
  
  func processEquations (_ equations:[Equation], includeAll: Bool = false) -> (Int,[Equation]) {
    var failedEquations: [Equation] = []
    
    let result = equations.compactMap { equation in
      var values = equation.values
      print("solving \(equation.result)")
      
      let combinationsToTry: [[Character]] =
      includeAll ? equation.concatOperatorCombos : equation.basicOperatorCombos
      
      let runningTotal = values.removeFirst()
      
      for comboToTest in combinationsToTry {
        let testResult = values.enumerated().reduce(runningTotal) { partialResult, nextItem in
          //partialResult is the sum so far. nextItem is the next value
          let (operatorIndex,value) = nextItem
          let operation = getOperator(comboToTest[operatorIndex])
          return operation(partialResult,value)
        }
        if testResult == equation.result { return equation.result }
      }
      failedEquations.append(equation)
      return nil
    }.reduce(0, + )
    
    return (result,failedEquations)
    
  }

  
  func part1() -> Any {
    let equations = entities
    return equations.compactMap { equation in
      let result = equation.result
      var values = equation.values
      let combinationsToTry = equation.operators.uniquePermutations(ofCount: equation.numberOperators).map{Array($0)}
      // print("Find operators to get \(result) from \(values)")

      // Get the first number to start the reduce
      let runningTotal = values.removeFirst()
      
      // Loop all the combos, bail out when we find a match
      for comboToTest in combinationsToTry {
        let testResult = values.enumerated().reduce(runningTotal) { partialResult, nextItem in
          //partialResult is the sum so far. nextItem is the next value
          let (operatorIndex,value) = nextItem
          let operation = getOperator(comboToTest[operatorIndex])
          return operation(partialResult,value)
        }
        if testResult == result { return result }
      }
      return nil
    }.reduce(0, + )
  }

  func part2() -> Any {
    
    let equations = entities
    
    let (firstPassResult, failedEquations) = processEquations(equations, includeAll: false)
    print("done with the first pass. Need to reprocess \(failedEquations.count)")
    
    
    let (secondPassResult, _) = processEquations(failedEquations, includeAll: true)
    
    return firstPassResult + secondPassResult
  }
}

infix operator ||
extension Int {
  static func || (lhs: Int, rhs: Int) -> Int {
    return Int(String(lhs) + String(rhs))!
  }
}
