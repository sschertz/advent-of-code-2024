import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [Equation] {
    data.split(separator: "\n").map { $0.split(separator: ":") }.map {
      let result = Int($0[0])
      let values = $0[1].split(separator: " ").compactMap { Int($0) }
      return Equation(result: result!, values: values)
    }
  }

  // Attempt to combine the previous result with the next value
  // in the array using the operators. 
  func evaluate(_ previousResult: inout Int, boundedBy: Int, remaining: [Int],
    operations: [Operator]
  ) -> Bool {

    guard !remaining.isEmpty, previousResult <= boundedBy else {
      return previousResult == boundedBy
    }
    let nextValue = remaining.first!
    let nextRemaining = Array(remaining.dropFirst())
    for operation in operations {
      let op = operation.operation
      var result = op(previousResult, nextValue)
      if evaluate(
        &result, boundedBy: boundedBy, remaining: nextRemaining,
        operations: operations)
      {
        return true
      }
    }
    return false
  }

  func part1() -> Any {
    let equations = entities

    let partOneOperators = [Operator.plus, Operator.mul]
    print("Solve with operators: \(partOneOperators)")

    return equations.compactMap { equation in
      let expectedResult = equation.result
      let remainingValues = Array(equation.values.dropFirst())
      var startValue = equation.values.first!

      if evaluate(
        &startValue, boundedBy: expectedResult, remaining: remainingValues,
        operations: partOneOperators)
      {
        return equation.result
      } else {
        return nil
      }
    }.reduce(0, +)
  }

  func part2() -> Any {
    let equations = entities
    let partTwoOperators = Operator.allCases
    print("Solve with operators: \(partTwoOperators)")

    return equations.compactMap { equation in
      let expectedResult = equation.result
      let remainingValues = Array(equation.values.dropFirst())
      var startValue = equation.values.first!

      if evaluate(
        &startValue, boundedBy: expectedResult, remaining: remainingValues,
        operations: partTwoOperators)
      {
        return equation.result
      } else {
        return nil
      }
    }.reduce(0, +)

  }
}

infix operator ||

extension Int {
  static func || (lhs: Int, rhs: Int) -> Int {
    return Int(String(lhs) + String(rhs))!
  }
}

struct Equation: CustomStringConvertible {
  var result: Int
  var values: [Int]

  public var description: String {
    return "\(result): \(values)"
  }
}

public enum Operator: CaseIterable, CustomStringConvertible {

  public var description: String {
    switch self {
    case .plus:
      return "+"
    case .mul:
      return "*"
    case .concat:
      return "||"
    }
  }

  case plus, mul, concat

  public var operation: (Int, Int) -> Int {
    switch self {
    case .plus:
      return (+)
    case .mul:
      return (*)
    case .concat:
      return (||)
    }
  }
}
